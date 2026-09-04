import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../models/complaint/complaint_model.dart';
import '../widgets/unread_badge.dart';
import '../../../core/utils/show_message.dart';
import '../../admin/widgets/option_picker_field.dart';
import '../../../core/extensions/build_context.dart';
import 'complaint_chat_page.dart';

/// Complaints the customer has filed, plus a form to raise a new one
/// against a store.
class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ComplaintBloc>().add(GetAllComplaintsByUserEvent());
    if (context.read<StoreBloc>().state.stores.isEmpty) {
      context.read<StoreBloc>().add(GetAllStoresEvent());
    }
  }

  /// Opens the existing conversation with [storeId] if there is one.
  ///
  /// Filing a second complaint against a store the customer is already
  /// talking to would split the conversation across two threads, and the
  /// store owner would answer in whichever one they happened to open. The
  /// complaint list already carries `storeId`, so the match is local.
  bool _hasThreadWith(int storeId) => _threadsWith(storeId).isNotEmpty;

  List<UserComplaintModel> _threadsWith(int storeId) => context
      .read<ComplaintBloc>()
      .state
      .userComplaints
      .where((c) => c.storeId == storeId)
      .toList();

  bool _openExistingThread(int storeId) {
    final existing = _threadsWith(storeId);
    if (existing.isEmpty) return false;

    // Most recently active thread with this store.
    existing.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    final complaint = existing.first;
    showMessage(LK.complaintsExistingThread.tr(), hasError: false);
    context.pushPage(
      ComplaintChatPage(
        complaintId: complaint.complaintId,
        counterpartName: complaint.storeName,
      ),
    );
    return true;
  }

  Future<void> _newComplaint() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    int? storeId;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: width(20),
            right: width(20),
            top: height(20),
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + height(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LK.profileNewComplaint.tr(),
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              SizedBox(height: height(14)),
              BlocBuilder<StoreBloc, StoreState>(
                builder: (context, storeState) => OptionPickerField(
                  hintText: LK.storeTitle.tr(),
                  options: storeState.stores
                      .map((s) => PickerOption(s.id.toString(), s.storeName))
                      .toList(),
                  selectedValue: storeId?.toString(),
                  onSelected: (o) {
                    final picked = int.parse(o.value);
                    if (_hasThreadWith(picked)) {
                      // Close the sheet *before* pushing: popping afterwards
                      // would take the chat page straight back off again.
                      Navigator.of(sheetContext).pop();
                      // Straight into the existing conversation - no point
                      // making them fill in a title first.
                      _openExistingThread(picked);
                      return;
                    }
                    setSheetState(() => storeId = picked);
                  },
                ),
              ),
              SizedBox(height: height(10)),
              AuthTextField(
                controller: titleController,
                hintText: LK.profileComplaintTitle.tr(),
                validator: (_) => null,
              ),
              SizedBox(height: height(10)),
              AuthTextField(
                controller: descriptionController,
                hintText: LK.profileComplaintDescription.tr(),
                maxLines: 4,
                validator: (_) => null,
              ),
              SizedBox(height: height(18)),
              AuthButton(
                text: LK.commonSave.tr(),
                widthButton: double.infinity,
                heightButton: height(50),
                onTap: () {
                  if (storeId == null || titleController.text.trim().isEmpty) {
                    showMessage(LK.commonRequiredField.tr());
                    return;
                  }
                  Navigator.of(sheetContext).pop();
                  // The list may have refreshed while the sheet was open.
                  if (_openExistingThread(storeId!)) return;
                  context.read<ComplaintBloc>().add(
                    AddComplaintEvent(
                      storeId: storeId!,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.profileComplaints.tr()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newComplaint,
        icon: const Icon(Icons.add),
        label: Text(LK.profileNewComplaint.tr()),
      ),
      body: BlocConsumer<ComplaintBloc, ComplaintState>(
        listenWhen: (p, c) => p.addComplaintStatus != c.addComplaintStatus,
        listener: (context, state) {
          if (state.addComplaintStatus == AddComplaintStatus.success) {
            showMessage(LK.profileComplaintSent.tr(), hasError: false);
          } else if (state.addComplaintStatus == AddComplaintStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          // Most recently active first. `lastMessageAt` is now returned by
          // GetAllComplaintsByUser, so this is true last-activity order and
          // no longer has to approximate it from the unread count; a thread
          // with no messages at all falls back to when it was filed.
          final sorted = [...state.userComplaints]
            ..sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
          return AsyncView(
            isLoading:
                state.getAllComplaintsByUserStatus ==
                GetAllComplaintsByUserStatus.loading,
            isFailure:
                state.getAllComplaintsByUserStatus ==
                GetAllComplaintsByUserStatus.failure,
            isEmpty:
                state.getAllComplaintsByUserStatus ==
                    GetAllComplaintsByUserStatus.success &&
                state.userComplaints.isEmpty,
            errorMessage: state.errorMessage,
            emptyText: LK.profileNoComplaints.tr(),
            onRetry: () => context.read<ComplaintBloc>().add(
              GetAllComplaintsByUserEvent(),
            ),
            child: ListView.separated(
              padding: EdgeInsets.all(width(16)),
              itemCount: sorted.length,
              separatorBuilder: (_, __) => SizedBox(height: height(10)),
              itemBuilder: (context, index) {
                final complaint = sorted[index];
                return Container(
                  padding: EdgeInsets.all(width(14)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD3D3E4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              complaint.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          // Unread messages waiting in this thread.
                          UnreadBadge(count: complaint.numberOfUnReadMessage),
                        ],
                      ),
                      SizedBox(height: height(4)),
                      Text(
                        complaint.storeName,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: height(6)),
                      Text(
                        complaint.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: height(6)),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton.icon(
                          onPressed: () => context.pushPage(
                            ComplaintChatPage(
                              complaintId: complaint.complaintId,
                              counterpartName: complaint.storeName,
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: Text(LK.chatOpenChat.tr()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
