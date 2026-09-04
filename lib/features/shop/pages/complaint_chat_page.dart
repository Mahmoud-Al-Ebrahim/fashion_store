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
import '../../admin/widgets/confirm_dialog.dart';
import 'dart:ui' as ui;

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
  StreamSubscription<int>? _deleteSub;
  StreamSubscription<int>? _readSub;
  StreamSubscription<HubMessage>? _editSub;

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
      // The push shows instantly, but REST is what carries the real id and
      // read state - and it is scoped to this complaint, so anything that
      // leaked in from another thread's group drops back out.
      _reloadHistory();
      // A message that arrives while the thread is open has been seen -
      // but only the peer's. The hub echoes our own sends back to us too,
      // and marking those read would be reporting on ourselves.
      if (!Session.owns(message.senderId)) {
        _hub.markAsRead(widget.complaintId);
      }
    });

    // The peer opened the thread: our own bubbles move from "sent" to
    // "read". Nothing consumed this stream before, so the tick never
    // updated until the screen was reopened.
    _readSub = _hub.readReceipts.listen((complaintId) {
      if (!mounted || complaintId != widget.complaintId) return;
      _reloadHistory();
    });

    // A peer edit or delete rewrites history, so re-read it rather than
    // trying to patch the local copy.
    _deleteSub = _hub.deletions.listen((messageId) {
      if (!mounted) return;
      setState(() => _live.removeWhere((m) => m.id == messageId));
      context.read<ComplaintBloc>().add(
        GetComplaintMessagesEvent(complaintId: widget.complaintId),
      );
    });
    _editSub = _hub.edits.listen((_) {
      if (!mounted) return;
      context.read<ComplaintBloc>().add(
        GetComplaintMessagesEvent(complaintId: widget.complaintId),
      );
    });

    try {
      await _hub.connect();
      await _hub.joinComplaint(widget.complaintId);
      // Opening the thread is what "reading" means, so clear the unread
      // counter the complaint lists badge off. The hub echoes
      // `MessagesMarkedAsRead` back to the group so the peer's view updates
      // too.
      await _hub.markAsRead(widget.complaintId);
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

  /// Offers edit/delete on a message the signed-in user sent.
  ///
  /// The hub authorises this server-side too - it refuses to touch somebody
  /// else's message - so this menu is a convenience, not the control.
  Future<void> _messageActions(MessageModel message) async {
    if (!Session.owns(message.senderId)) return;
    // Editing and deleting both go over the hub, so they are impossible
    // while the connection is down - say so rather than opening a menu
    // whose actions would silently fail.
    if (_connection != ChatConnectionState.connected) {
      showMessage(LK.chatOfflineNoActions.tr());
      return;
    }
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(LK.chatEditMessage.tr()),
              onTap: () => Navigator.of(sheetContext).pop('edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                LK.chatDeleteMessage.tr(),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.of(sheetContext).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    if (action == 'edit') {
      await _editMessage(message);
    } else {
      await _deleteMessage(message);
    }
  }

  Future<void> _editMessage(MessageModel message) async {
    final controller = TextEditingController(text: message.text);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LK.chatEditMessage.tr()),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          minLines: 1,
          decoration: InputDecoration(hintText: LK.chatHint.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LK.commonCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LK.commonSave.tr()),
          ),
        ],
      ),
    );
    final text = controller.text.trim();
    if (saved != true || text.isEmpty || text == message.text) return;

    final ok = await _hub.editMessage(
      complaintId: widget.complaintId,
      messageId: message.id,
      text: text,
    );
    if (!mounted) return;
    showMessage(
      ok ? LK.chatMessageEdited.tr() : LK.chatEditFailed.tr(),
      hasError: !ok,
    );
    if (ok) _reloadHistory();
  }

  Future<void> _deleteMessage(MessageModel message) async {
    final confirmed = await confirmDialog(
      context,
      title: LK.chatDeleteMessage.tr(),
      message: LK.chatDeleteConfirm.tr(),
      confirmText: LK.commonDelete.tr(),
    );
    if (!confirmed || !mounted) return;

    final ok = await _hub.deleteMessage(
      complaintId: widget.complaintId,
      messageId: message.id,
    );
    if (!mounted) return;
    showMessage(
      ok ? LK.chatMessageDeleted.tr() : LK.chatDeleteFailed.tr(),
      hasError: !ok,
    );
    if (ok) {
      setState(() => _live.removeWhere((m) => m.id == message.id));
      _reloadHistory();
    }
  }

  void _reloadHistory() => context.read<ComplaintBloc>().add(
    GetComplaintMessagesEvent(complaintId: widget.complaintId),
  );

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
    _deleteSub?.cancel();
    _readSub?.cancel();
    _editSub?.cancel();
    // Stop receiving this thread's broadcasts; the next thread opened on the
    // same connection would otherwise still be in this group.
    _hub.leaveComplaint(widget.complaintId);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Refreshes whichever complaint list brought us here, so its unread badge
  /// reflects the messages just read. Which list that is depends on the
  /// caller's role, so both events are dispatched - each bloc ignores the
  /// one that isn't its own view.
  void _refreshComplaintLists() {
    // Unconditional: the REST read fires on entry whether or not the hub
    // connected, so the badge must be refreshed either way.
    final bloc = context.read<ComplaintBloc>();
    bloc.add(GetAllComplaintsByUserEvent());
    if (Session.canManageStore) bloc.add(GetAllComplaintsEvent());
  }

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
          // Just the counterpart. The connected/disconnected line that used
          // to sit under it was noise: the connection is an implementation
          // detail, and the two places it actually matters - sending, and
          // editing or deleting - report it themselves.
          title: Text(
            widget.counterpartName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Column(
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
                        itemBuilder: (context, index) => _Bubble(
                          message: merged[index],
                          onLongPress: () => _messageActions(merged[index]),
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onLongPress;

  const _Bubble({required this.message, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final mine = Session.owns(message.senderId);
    final primary = Theme.of(context).colorScheme.primary;
    return Align(
      // Deliberately NOT AlignmentDirectional: under RTL "end" resolves to
      // the left, so in Arabic the sender's own messages were drawn on the
      // left and read as if they had been received. Chat convention is
      // absolute - mine on the right, theirs on the left - in every
      // language.
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        // Only your own messages can be edited or removed.
        onLongPress: mine ? onLongPress : null,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatMessageTimestamp(message.createdAt),
                    style: TextStyle(
                      fontSize: 9,
                      color: mine ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  if (message.isEdited) ...[
                    SizedBox(width: width(4)),
                    Text(
                      LK.chatEdited.tr(),
                      style: TextStyle(
                        fontSize: 9,
                        fontStyle: FontStyle.italic,
                        color: mine ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                  // Delivery state belongs to the sender only - telling
                  // someone their own incoming message is "read" is
                  // meaningless.
                  if (mine) ...[
                    SizedBox(width: width(5)),
                    Icon(
                      message.isRead ? Icons.done_all : Icons.done,
                      size: 11,
                      color: message.isRead
                          ? const Color(0xFF9BE7FF)
                          : Colors.white70,
                    ),
                    SizedBox(width: width(3)),
                    Text(
                      message.isRead ? LK.chatSeen.tr() : LK.chatSent.tr(),
                      style: TextStyle(
                        fontSize: 9,
                        color: message.isRead
                            ? const Color(0xFF9BE7FF)
                            : Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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

/// "اليوم 4:30 م" for today, "أمس 4:30 م" for yesterday, and
/// "2026-09-01 4:30 م" for anything older.
///
/// Deliberately hand-rolled rather than `DateFormat.jm()`: the 12-hour
/// marker has to come from the language files so that the Arabic build says
/// ص/م and the English one AM/PM, whatever locale data is bundled.
String formatMessageTimestamp(DateTime when) {
  final now = DateTime.now();
  final day = DateTime(when.year, when.month, when.day);
  final today = DateTime(now.year, now.month, now.day);
  final difference = today.difference(day).inDays;

  final String datePart;
  if (difference == 0) {
    datePart = LK.chatToday.tr();
  } else if (difference == 1) {
    datePart = LK.chatYesterday.tr();
  } else {
    datePart =
        '${when.year}-${when.month.toString().padLeft(2, '0')}-'
        '${when.day.toString().padLeft(2, '0')}';
  }

  final marker = when.hour < 12 ? LK.chatAm.tr() : LK.chatPm.tr();
  final hour12 = when.hour % 12 == 0 ? 12 : when.hour % 12;
  final minute = when.minute.toString().padLeft(2, '0');

  return '$datePart $hour12:$minute $marker';
}
