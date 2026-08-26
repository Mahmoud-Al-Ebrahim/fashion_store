import 'dart:async';
import 'dart:developer';

import 'package:signalr_netcore/signalr_client.dart';

import '../utils/api_service.dart';
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
    final map = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};

    T? pick<T>(List<String> keys) {
      for (final k in keys) {
        final v = map[k] ?? map[k[0].toUpperCase() + k.substring(1)];
        if (v is T) return v;
        if (v != null && T == String) return v.toString() as T;
      }
      return null;
    }

    final createdRaw = pick<String>(['createdAt', 'sentAt', 'date', 'timeStamp']);
    return HubMessage(
      id: pick<int>(['id', 'messageId']),
      complaintId: pick<int>(['complaintId']) ?? 0,
      senderId: pick<String>(['senderId', 'userId', 'fromUserId']) ?? '',
      senderName: pick<String>(['senderName', 'userFullName', 'fullName']),
      text: pick<String>(['text', 'content', 'message', 'body']) ?? '',
      createdAt: DateTime.tryParse(createdRaw ?? '')?.toLocal() ?? DateTime.now(),
    );
  }
}

/// Connection lifecycle surfaced to the UI.
enum ChatConnectionState { disconnected, connecting, connected, reconnecting }

/// Thin wrapper over the backend's SignalR `/chatHub`, used for the
/// customer <-> store conversation attached to a complaint.
///
/// The hub endpoint and its auth were verified against the server
/// (`POST /chatHub/negotiate` returns a connection token for a bearer
/// token). The *method names* below are not published in Swagger, so they
/// are declared here as constants and the send path tries the documented
/// name first, then known fallbacks, rather than failing outright.
class ChatHubService {
  ChatHubService._();

  static final ChatHubService instance = ChatHubService._();

  static const String hubPath = '/chatHub';

  /// Server methods this client may invoke to send a message.
  /// The first that the hub accepts is remembered for the session.
  static const List<String> sendMethodCandidates = [
    'SendMessage',
    'SendMessageToComplaint',
    'SendComplaintMessage',
  ];

  /// Client callbacks the server may push new messages on.
  static const List<String> receiveMethodCandidates = [
    'ReceiveMessage',
    'ReceiveComplaintMessage',
    'NewMessage',
  ];

  /// Broadcast when the peer opens the thread and their unread messages are
  /// cleared. Payload: `{ complaintId, readBy }`.
  static const String messagesMarkedAsReadEvent = 'MessagesMarkedAsRead';

  /// Broadcast when a message is removed. Payload is the deleted message.
  static const String messageDeletedEvent = 'MessageDeleted';

  HubConnection? _connection;
  String? _resolvedSendMethod;
  String? _resolvedMarkReadMethod;

  final _messages = StreamController<HubMessage>.broadcast();
  final _state = StreamController<ChatConnectionState>.broadcast();
  final _readReceipts = StreamController<int>.broadcast();
  final _deletions = StreamController<int>.broadcast();

  /// Messages pushed by the server.
  Stream<HubMessage> get messages => _messages.stream;

  /// Connection state changes, for the header indicator.
  Stream<ChatConnectionState> get connectionState => _state.stream;

  /// Complaint ids whose messages the peer just marked as read.
  Stream<int> get readReceipts => _readReceipts.stream;

  /// Ids of messages the hub reported as deleted.
  Stream<int> get deletions => _deletions.stream;

  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected;

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

      // Listen on every plausible callback name; whichever the server uses
      // ends up on the same stream.
      for (final method in receiveMethodCandidates) {
        connection.on(method, (args) {
          if (args == null || args.isEmpty) return;
          _messages.add(HubMessage.fromDynamic(args.first));
        });
      }

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
      await _connection?.invoke('JoinComplaintGroup', args: [complaintId]);
    } catch (error) {
      // The hub throws HubException for an unknown/unauthorised complaint.
      log('chatHub JoinComplaintGroup failed: $error');
    }
  }

  /// Marks every message of [complaintId] as read.
  ///
  /// The hub takes a `RequestUpdateReadMessageDto` (`{ complaintId }`) and
  /// broadcasts `MessagesMarkedAsRead` to the group on success. The exact
  /// method name was cut off in the excerpt we were given, so the known
  /// naming convention is tried in order and the winner cached.
  static const List<String> markReadMethodCandidates = [
    'MarkMessagesAsReadAsync',
    'MarkMessagesAsRead',
    'UpdateReadMessageAsync',
    'UpdateReadMessage',
  ];

  Future<bool> markAsRead(int complaintId) async {
    if (!isConnected) await connect();
    if (_connection == null) return false;

    final candidates = _resolvedMarkReadMethod != null
        ? [_resolvedMarkReadMethod!]
        : markReadMethodCandidates;

    for (final method in candidates) {
      try {
        await _connection!.invoke(
          method,
          args: [
            {'complaintId': complaintId},
          ],
        );
        _resolvedMarkReadMethod = method;
        return true;
      } catch (error) {
        log('chatHub $method failed: $error');
      }
    }
    return false;
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
        'DeleteMessageAsync',
        args: [
          {'complaintId': complaintId, 'messageId': messageId},
        ],
      );
      return true;
    } catch (error) {
      log('chatHub DeleteMessageAsync failed: $error');
      return false;
    }
  }

  /// Sends [text] on [complaintId]. Returns true when the hub accepted it.
  Future<bool> sendMessage({
    required int complaintId,
    required String text,
  }) async {
    if (!isConnected) await connect();
    if (_connection == null) return false;

    final candidates = _resolvedSendMethod != null
        ? [_resolvedSendMethod!]
        : sendMethodCandidates;

    for (final method in candidates) {
      try {
        await _connection!.invoke(method, args: [complaintId, text]);
        _resolvedSendMethod = method;
        return true;
      } catch (error) {
        log('chatHub $method failed: $error');
      }
    }
    return false;
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
