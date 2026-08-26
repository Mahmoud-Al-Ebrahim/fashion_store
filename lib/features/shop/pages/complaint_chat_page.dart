import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/services/chat_hub_service.dart';
import '../../../core/utils/session.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/complaint/message_model.dart';

/// Text conversation attached to a complaint, shared by the customer and the
/// store owner.
///
/// History comes from the REST endpoint (`Message/GetMessagesByComplaintId`)
/// and live delivery from the SignalR `/chatHub`; there is no REST endpoint
/// for sending, so sending always goes through the hub.
class ComplaintChatPage extends StatefulWidget {
  final int complaintId;

  /// Shown in the app bar - the counterpart's name (store or customer).
  final String counterpartName;

  const ComplaintChatPage({
    super.key,
    required this.complaintId,
    required this.counterpartName,
  });

  @override
  State<ComplaintChatPage> createState() => _ComplaintChatPageState();
}

class _ComplaintChatPageState extends State<ComplaintChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _hub = ChatHubService.instance;

  /// Messages received live, appended to whatever REST returned.
  final List<MessageModel> _live = [];

  StreamSubscription<HubMessage>? _messageSub;
  StreamSubscription<ChatConnectionState>? _stateSub;

  /// Set once the thread has been marked read, so leaving the page can
  /// refresh the list that shows the unread badge.
  bool _markedRead = false;
  ChatConnectionState _connection = ChatConnectionState.disconnected;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    context.read<ComplaintBloc>().add(
      GetComplaintMessagesEvent(complaintId: widget.complaintId),
    );
    context.read<ComplaintBloc>().add(
      ReadComplaintMessagesEvent(complaintId: widget.complaintId),
    );
    _openHub();
  }

  Future<void> _openHub() async {
    _stateSub = _hub.connectionState.listen((state) {
      if (mounted) setState(() => _connection = state);
    });
    _messageSub = _hub.messages.listen((message) {
      // Ignore chatter belonging to other complaints.
      if (message.complaintId != 0 &&
          message.complaintId != widget.complaintId) {
        return;
      }
      if (!mounted) return;
      setState(() {
        _live.add(
          MessageModel(
            id: message.id ?? DateTime.now().millisecondsSinceEpoch,
            complaintId: widget.complaintId,
            senderId: message.senderId,
            senderName: message.senderName,
            text: message.text,
            isRead: false,
            createdAt: message.createdAt,
          ),
        );
      });
      _scrollToEnd();
    });

    try {
      await _hub.connect();
      await _hub.joinComplaint(widget.complaintId);
      // Opening the thread is what "reading" means, so clear the unread
      // counter the complaint lists badge off. The hub echoes
      // `MessagesMarkedAsRead` back to the group so the peer's view updates
      // too.
      await _hub.markAsRead(widget.complaintId);
      _markedRead = true;
    } catch (_) {
      // The state stream already reported the failure; history still shows.
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    final ok = await _hub.sendMessage(
      complaintId: widget.complaintId,
      text: text,
    );
    if (!mounted) return;
    setState(() => _sending = false);

    if (!ok) {
      showMessage(LK.chatSendFailed.tr());
      return;
    }

    _controller.clear();
    FocusScope.of(context).unfocus();
    // Re-pull history so the stored copy (with its real id) is authoritative.
    context.read<ComplaintBloc>().add(
      GetComplaintMessagesEvent(complaintId: widget.complaintId),
    );
  }

  @override
  void dispose() {
    _messageSub?.cancel();
    _stateSub?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Refreshes whichever complaint list brought us here, so its unread badge
  /// reflects the messages just read. Which list that is depends on the
  /// caller's role, so both events are dispatched - each bloc ignores the
  /// one that isn't its own view.
  void _refreshComplaintLists() {
    if (!_markedRead) return;
    final bloc = context.read<ComplaintBloc>();
    bloc.add(GetAllComplaintsByUserEvent());
    if (Session.canManageStore) bloc.add(GetAllComplaintsEvent());
  }

  String get _statusLabel => switch (_connection) {
    ChatConnectionState.connected => LK.chatConnected.tr(),
    ChatConnectionState.connecting => LK.chatConnecting.tr(),
    ChatConnectionState.reconnecting => LK.chatReconnecting.tr(),
    ChatConnectionState.disconnected => LK.chatDisconnected.tr(),
  };

  Color get _statusColor => switch (_connection) {
    ChatConnectionState.connected => Colors.green,
    ChatConnectionState.connecting ||
    ChatConnectionState.reconnecting => Colors.orange,
    ChatConnectionState.disconnected => Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Leaving the thread is the moment the list behind it needs to drop
      // this complaint's unread badge.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _refreshComplaintLists();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                widget.counterpartName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: width(5)),
                  Text(
                    _statusLabel,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ComplaintBloc, ComplaintState>(
                builder: (context, state) {
                  // History from REST, then anything that arrived live and
                  // isn't already in it.
                  final stored = state.messages;
                  final storedIds = stored.map((m) => m.id).toSet();
                  final merged = [
                    ...stored,
                    ..._live.where((m) => !storedIds.contains(m.id)),
                  ]..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                  return AsyncView(
                    isLoading:
                        state.getComplaintMessagesStatus ==
                            GetComplaintMessagesStatus.loading &&
                        merged.isEmpty,
                    isFailure: false,
                    isEmpty: merged.isEmpty,
                    emptyText: LK.chatEmpty.tr(),
                    emptyImageHeight: height(120),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(width(16)),
                      itemCount: merged.length,
                      itemBuilder: (context, index) =>
                          _Bubble(message: merged[index]),
                    ),
                  );
                },
              ),
            ),
            if (_connection == ChatConnectionState.disconnected)
              Container(
                width: double.infinity,
                color: Colors.orange.withValues(alpha: 0.12),
                padding: EdgeInsets.symmetric(
                  horizontal: width(16),
                  vertical: height(8),
                ),
                child: Text(
                  LK.chatOfflineNote.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            _Composer(
              controller: _controller,
              sending: _sending,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel message;

  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final mine = Session.owns(message.senderId);
    final primary = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: mine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: width(260)),
        margin: EdgeInsets.only(bottom: height(10)),
        padding: EdgeInsets.symmetric(
          horizontal: width(14),
          vertical: height(10),
        ),
        decoration: BoxDecoration(
          color: mine ? primary : const Color(0xFFEAEAF2),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!mine && (message.senderName ?? '').isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: height(2)),
                child: Text(
                  message.senderName!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(color: mine ? Colors.white : Colors.black87),
            ),
            SizedBox(height: height(3)),
            Text(
              '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 9,
                color: mine ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(width(12), height(8), width(12), height(12)),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: LK.chatHint.tr(),
                  filled: true,
                  fillColor: const Color(0xFFEAEAF2),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: width(16),
                    vertical: height(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: width(8)),
            sending
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton.filled(
                    onPressed: onSend,
                    icon: const Icon(Icons.send),
                    tooltip: LK.chatSend.tr(),
                  ),
          ],
        ),
      ),
    );
  }
}
