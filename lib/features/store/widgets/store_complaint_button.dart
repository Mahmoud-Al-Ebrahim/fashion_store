import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/session.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/complaint/complaint_model.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../../shop/pages/complaint_chat_page.dart';

/// "Report this store" on the store page - or "open the conversation" when
/// one already exists.
///
/// Reaching the store you have a problem with used to mean backing out to
/// the drawer, opening Complaints, and picking that store out of a list of
/// every store on the platform. The thread is per store, so the button also
/// has to avoid filing a second complaint against a store the customer is
/// already talking to: the store owner would answer in whichever of the two
/// they happened to open.
class StoreComplaintButton extends StatefulWidget {
  const StoreComplaintButton({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  final int storeId;
  final String storeName;

  @override
  State<StoreComplaintButton> createState() => _StoreComplaintButtonState();
}

class _StoreComplaintButtonState extends State<StoreComplaintButton> {
  /// Set between filing a complaint and its thread appearing in the list,
  /// so the new conversation opens by itself once the server has it.
  bool _openWhenCreated = false;

  @override
  void initState() {
    super.initState();
    // Needed to answer "is there already a thread with this store?". Guests
    // have none and the call would 401.
    if (Session.isSignedIn) {
      context.read<ComplaintBloc>().add(GetAllComplaintsByUserEvent());
    }
  }

  UserComplaintModel? _existingThread(ComplaintState state) {
    final threads = state.userComplaints
        .where((c) => c.storeId == widget.storeId)
        .toList();
    if (threads.isEmpty) return null;
    threads.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    return threads.first;
  }

  void _openThread(UserComplaintModel thread) {
    context.pushPage(
      ComplaintChatPage(
        complaintId: thread.complaintId,
        counterpartName: widget.storeName,
      ),
    );
  }

  Future<void> _onTap(UserComplaintModel? existing) async {
    if (!await requireAuth(
      context,
      onSignIn: () => HelperFunctions.navigateToPageAndPopAll(
        context,
        const SignInScreen(),
        true,
      ),
    )) {
      return;
    }
    if (!mounted) return;

    if (existing != null) {
      _openThread(existing);
      return;
    }
    await _fileComplaint();
  }

  Future<void> _fileComplaint() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
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
              LK.storeReport.tr(),
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
            SizedBox(height: height(4)),
            // The store is fixed here, unlike the complaints screen where it
            // has to be picked - so it is stated rather than chosen.
            Text(
              widget.storeName,
              style: Theme.of(sheetContext).textTheme.bodySmall!.copyWith(
                color: Theme.of(sheetContext).colorScheme.primary,
              ),
            ),
            SizedBox(height: height(4)),
            Text(
              LK.storeReportHint.tr(),
              style: Theme.of(
                sheetContext,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
            SizedBox(height: height(14)),
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
                if (titleController.text.trim().isEmpty) {
                  showMessage(LK.commonRequiredField.tr());
                  return;
                }
                Navigator.of(sheetContext).pop(true);
              },
            ),
          ],
        ),
      ),
    );

    if (submitted != true || !mounted) return;
    setState(() => _openWhenCreated = true);
    context.read<ComplaintBloc>().add(
      AddComplaintEvent(
        storeId: widget.storeId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComplaintBloc, ComplaintState>(
      listenWhen: (p, c) =>
          p.addComplaintStatus != c.addComplaintStatus ||
          p.userComplaints != c.userComplaints,
      listener: (context, state) {
        if (state.addComplaintStatus == AddComplaintStatus.failure) {
          setState(() => _openWhenCreated = false);
          showMessage(state.errorMessage);
          return;
        }
        // `AddComplaintEvent` refetches the list on success, so the new
        // thread arrives here a moment later - that is when it can be
        // opened, because only the list carries its complaint id.
        if (!_openWhenCreated) return;
        final thread = _existingThread(state);
        if (thread == null) return;
        setState(() => _openWhenCreated = false);
        showMessage(LK.profileComplaintSent.tr(), hasError: false);
        _openThread(thread);
      },
      builder: (context, state) {
        final existing = _existingThread(state);
        final busy =
            _openWhenCreated ||
            state.addComplaintStatus == AddComplaintStatus.loading;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width(13)),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: busy ? null : () => _onTap(existing),
              icon: Icon(
                existing == null
                    ? Icons.report_gmailerrorred_outlined
                    : Icons.forum_outlined,
                size: 18,
              ),
              label: Text(
                existing == null ? LK.storeReport.tr() : LK.chatOpenChat.tr(),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: height(10)),
              ),
            ),
          ),
        );
      },
    );
  }
}
