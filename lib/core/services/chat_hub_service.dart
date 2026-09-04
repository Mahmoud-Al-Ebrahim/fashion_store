import 'dart:async';
import 'dart:developer';

import 'package:signalr_netcore/signalr_client.dart';

import '../utils/api_service.dart';
import '../utils/json_parse.dart';
import 'utf8_signalr_http_client.dart';
import '../utils/my_shared_pref.dart';

/// A message as it arrives over the hub. Field names are read leniently
/// because the hub payload shape isn't described in Swagger.
class HubMessage {
  final int? id;
  final int complaintId;
  final String senderId;
  final String? senderName;
  final String text;
  final DateTime createdAt;

  const HubMessage({
    this.id,
    required this.complaintId,
    required this.senderId,
    this.senderName,
    required this.text,
    required this.createdAt,
  });

  /// Tolerates the common casing/naming variants a .NET hub might emit.
  factory HubMessage.fromDynamic(dynamic raw) {
    final map = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    T? pick<T>(List<String> keys) {
      for (final k in keys) {
        final v = map[k] ?? map[k[0].toUpperCase() + k.substring(1)];
        if (v is T) return v;
        if (v != null && T == String) return v.toString() as T;
      }
      return null;
    }

    final createdRaw = pick<String>([
      'createdAt',
      'sentAt',
      'date',
      'timeStamp',
    ]);
    return HubMessage(
      id: pick<int>(['id', 'messageId']),
      complaintId: pick<int>(['complaintId']) ?? 0,
      senderId: pick<String>(['senderId', 'userId', 'fromUserId']) ?? '',
      senderName: pick<String>(['senderName', 'userFullName', 'fullName']),
      // `messageText` is what the hub actually sends; without it every
      // arriving message rendered blank.
      text:
          pick<String>(['messageText', 'text', 'content', 'message', 'body']) ??
          '',
      // Same UTC-without-a-Z shape the REST endpoint returns - parsing it
      // as local time put live messages three hours in the past.
      createdAt: asServerDateOrNull(createdRaw) ?? DateTime.now(),
    );
  }
}

/// Connection lifecycle surfaced to the UI.
enum ChatConnectionState { disconnected, connecting, connected, reconnecting }

/// Thin wrapper over the backend's SignalR `/chatHub`, used for the
/// customer <-> store conversation attached to a complaint.
///
/// Every name and payload below is taken from the hub source and confirmed
/// against the running server by driving the protocol by hand.
///
/// ## Why LongPolling is forced
///
/// `negotiate` advertises WebSockets, ServerSentEvents and LongPolling, and
/// signalr_netcore documents that "if transport is null and the server
/// supports all transport protocols than HttpTransportType.WebSockets is
/// used". But the host does not actually proxy the upgrade: a WebSocket
/// handshake against `/chatHub` answers `200 OK` with
/// `Content-Type: application/octet-stream` instead of
/// `101 Switching Protocols`. The socket therefore never opens and the UI
/// sat on "disconnected" forever. LongPolling completes the handshake and
/// carries invocations and pushes normally, so it is selected explicitly.
/// Drop this back to the default once the host supports upgrades.
class ChatHubService {
  ChatHubService._();

  static final ChatHubService instance = ChatHubService._();

  static const String hubPath = '/chatHub';

  // ----- methods this client invokes on the hub -----

  /// `SendMessageAsync(RequestAddMessageDto)` - one object argument,
  /// `{ complaintId, messageText }`. The previous code called
  /// `SendMessage(complaintId, text)`: wrong name, and two positional
  /// arguments where the hub expects a single DTO.
  static const String sendMethod = 'SendMessageAsync';

  /// `JoinComplaintGroup(int complaintId)` - positional, not a DTO.
  static const String joinMethod = 'JoinComplaintGroup';

  /// The counterpart to [joinMethod]. Called on the way out of a thread so
  /// the connection stops receiving that group's broadcasts: `ReceiveMessage`
  /// carries no `complaintId`, so a connection left in two groups delivers
  /// one thread's messages into the other's view. Invoked defensively - if
  /// the hub has no such method the invocation just fails and is logged.
  static const String leaveMethod = 'LeaveComplaintGroup';

  /// `MarkMessagesAsRead(RequestUpdateReadMessageDto)` - note there is no
  /// `Async` suffix on this one, unlike its neighbours.
  static const String markReadMethod = 'MarkMessagesAsRead';

  /// `DeleteMessageAsync(RequestRemoveMessageDto)` -
  /// `{ complaintId, messageId }`.
  static const String deleteMethod = 'DeleteMessageAsync';

  /// `EditMessageAsync(RequestUpdateMessageDto)` -
  /// `{ complaintId, messageId, messageText }`.
  static const String editMethod = 'EditMessageAsync';

  // ----- callbacks the hub pushes to this client -----

  /// New message. Payload is `ResponseGetMessageDto` - note it carries no
  /// `complaintId`, so the listener treats it as belonging to whichever
  /// thread is open.
  static const String receiveMessageEvent = 'ReceiveMessage';

  /// An existing message was edited. Payload is the updated message.
  static const String messageEditedEvent = 'MessageEdited';

  /// Broadcast when the peer opens the thread and their unread messages are
  /// cleared. Payload: `{ complaintId, readBy }`.
  static const String messagesMarkedAsReadEvent = 'MessagesMarkedAsRead';

  /// Broadcast when a message is removed. Payload is the deleted message.
  static const String messageDeletedEvent = 'MessageDeleted';

  HubConnection? _connection;

  final _messages = StreamController<HubMessage>.broadcast();
  final _state = StreamController<ChatConnectionState>.broadcast();
  final _readReceipts = StreamController<int>.broadcast();
  final _deletions = StreamController<int>.broadcast();
  final _edits = StreamController<HubMessage>.broadcast();

  /// Messages pushed by the server.
  Stream<HubMessage> get messages => _messages.stream;

  /// Connection state changes, for the header indicator.
  Stream<ChatConnectionState> get connectionState => _state.stream;

  /// Complaint ids whose messages the peer just marked as read.
  Stream<int> get readReceipts => _readReceipts.stream;

  /// Ids of messages the hub reported as deleted.
  Stream<int> get deletions => _deletions.stream;

  /// Messages the hub reported as edited.
  Stream<HubMessage> get edits => _edits.stream;

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  /// Opens the hub connection if it isn't already open.
  Future<void> connect() async {
    if (isConnected) return;
    final token = MySharedPref.getToken();
    if (token == null) {
      _state.add(ChatConnectionState.disconnected);
      return;
    }

    _state.add(ChatConnectionState.connecting);
    try {
      final connection = HubConnectionBuilder()
          .withUrl(
            '${ApiService.baseUrl}$hubPath',
            options: HttpConnectionOptions(
              accessTokenFactory: () async => MySharedPref.getToken() ?? '',
              // The hub's long-polling responses declare no charset, so the
              // default client decodes them as latin1 and mangles Arabic.
              httpClient: Utf8SignalRHttpClient(),
              // See the class doc: the host refuses the WebSocket upgrade.
              transport: HttpTransportType.LongPolling,
              // The default is 2s, which this server routinely exceeds on a
              // cold call. Polls use the transport's own 100s budget, so
              // this only bounds invocations.
              requestTimeout: 30000,
            ),
          )
          .withAutomaticReconnect()
          .build();

      connection.onclose(({error}) {
        log('chatHub closed: $error');
        _state.add(ChatConnectionState.disconnected);
      });
      connection.onreconnecting(({error}) {
        _state.add(ChatConnectionState.reconnecting);
      });
      connection.onreconnected(({connectionId}) {
        _state.add(ChatConnectionState.connected);
      });

      connection.on(receiveMessageEvent, (args) {
        if (args == null || args.isEmpty) return;
        _messages.add(HubMessage.fromDynamic(args.first));
      });

      // An edit re-emits the message; the page replaces it by id.
      connection.on(messageEditedEvent, (args) {
        if (args == null || args.isEmpty) return;
        _edits.add(HubMessage.fromDynamic(args.first));
      });

      connection.on(messagesMarkedAsReadEvent, (args) {
        if (args == null || args.isEmpty) return;
        final payload = args.first;
        if (payload is Map) {
          final id = payload['complaintId'] ?? payload['ComplaintId'];
          final parsed = id is int ? id : int.tryParse('$id');
          if (parsed != null) _readReceipts.add(parsed);
        }
      });

      connection.on(messageDeletedEvent, (args) {
        if (args == null || args.isEmpty) return;
        final payload = args.first;
        final id = payload is Map
            ? (payload['id'] ?? payload['Id'] ?? payload['messageId'])
            : payload;
        final parsed = id is int ? id : int.tryParse('$id');
        if (parsed != null) _deletions.add(parsed);
      });

      await connection.start();
      _connection = connection;
      _state.add(ChatConnectionState.connected);
    } catch (error) {
      log('chatHub connect failed: $error');
      _state.add(ChatConnectionState.disconnected);
      rethrow;
    }
  }

  /// Joins the per-complaint group.
  ///
  /// Confirmed against the hub source: `JoinComplaintGroup(int complaintId)`
  /// adds the connection to the `complaint-{id}` group, after checking the
  /// caller is that complaint's customer or store owner. Every broadcast the
  /// hub makes (`MessageDeleted`, `MessagesMarkedAsRead`, new messages) goes
  /// to that group, so joining is required, not optional.
  Future<void> joinComplaint(int complaintId) async {
    if (!isConnected) await connect();
    try {
      await _connection?.invoke(joinMethod, args: [complaintId]);
    } catch (error) {
      // The hub throws HubException for an unknown or unauthorised
      // complaint - the caller stays on the history it already loaded.
      log('chatHub $joinMethod failed: $error');
    }
  }

  /// Leaves the per-complaint group. Failure is not an error: the caller
  /// is closing the screen either way.
  Future<void> leaveComplaint(int complaintId) async {
    if (!isConnected) return;
    try {
      await _connection?.invoke(leaveMethod, args: [complaintId]);
    } catch (error) {
      log('chatHub $leaveMethod failed: $error');
    }
  }

  /// Marks every message of [complaintId] as read.
  ///
  /// The hub answers by broadcasting `MessagesMarkedAsRead` to the group,
  /// so the peer's unread badge clears too.
  Future<bool> markAsRead(int complaintId) async {
    if (!isConnected) await connect();
    if (_connection == null) return false;
    try {
      await _connection!.invoke(
        markReadMethod,
        args: [
          {'complaintId': complaintId},
        ],
      );
      return true;
    } catch (error) {
      log('chatHub $markReadMethod failed: $error');
      return false;
    }
  }

  /// Deletes one of the caller's own messages.
  ///
  /// Confirmed: `DeleteMessageAsync(RequestRemoveMessageDto)`. The hub
  /// rejects deleting somebody else's message, then broadcasts
  /// `MessageDeleted` to the group.
  Future<bool> deleteMessage({
    required int complaintId,
    required int messageId,
  }) async {
    if (!isConnected) await connect();
    if (_connection == null) return false;
    try {
      await _connection!.invoke(
        deleteMethod,
        args: [
          {'complaintId': complaintId, 'messageId': messageId},
        ],
      );
      return true;
    } catch (error) {
      log('chatHub $deleteMethod failed: $error');
      return false;
    }
  }

  /// Sends [text] on [complaintId]. Returns true when the hub accepted it.
  ///
  /// The hub echoes the saved message back over `ReceiveMessage`, so the
  /// caller does not append anything locally - it just waits for the push.
  Future<bool> sendMessage({
    required int complaintId,
    required String text,
  }) async {
    if (!isConnected) await connect();
    if (_connection == null) return false;
    try {
      await _connection!.invoke(
        sendMethod,
        args: [
          {'complaintId': complaintId, 'messageText': text},
        ],
      );
      return true;
    } catch (error) {
      log('chatHub $sendMethod failed: $error');
      return false;
    }
  }

  /// Edits one of the caller's own messages.
  Future<bool> editMessage({
    required int complaintId,
    required int messageId,
    required String text,
  }) async {
    if (!isConnected) await connect();
    if (_connection == null) return false;
    try {
      await _connection!.invoke(
        editMethod,
        args: [
          {
            'complaintId': complaintId,
            'messageId': messageId,
            'messageText': text,
          },
        ],
      );
      return true;
    } catch (error) {
      log('chatHub $editMethod failed: $error');
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _connection?.stop();
    } catch (_) {
      // ignore - we're tearing down anyway
    }
    _connection = null;
    _state.add(ChatConnectionState.disconnected);
  }
}
