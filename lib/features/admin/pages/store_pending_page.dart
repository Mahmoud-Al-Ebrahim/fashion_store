import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../../nav_bar/user_nav_bar/user_nav_bar_screen.dart';
import '../../../core/utils/show_message.dart';
import '../../shop/pages/seller_request_page.dart';
import '../widgets/confirm_dialog.dart';
import 'store_request_edit_page.dart';
import 'store_request_history_page.dart';

/// Shown to an account that holds the store-owner role but has no approved
/// store yet - the dashboard stays locked until a platform admin approves
/// the request. Also covers rejected and never-submitted cases.
class StorePendingPage extends StatefulWidget {
  const StorePendingPage({super.key});

  @override
  State<StorePendingPage> createState() => _StorePendingPageState();
}

class _StorePendingPageState extends State<StorePendingPage> {
  @override
  void initState() {
    super.initState();
    context.read<StoreRequestBloc>().add(GetAllStoreRequestsByUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(LK.sellerMyRequests.tr()),
        actions: [
          // Past requests - cancelled, rejected, superseded.
          IconButton(
            tooltip: LK.sellerMyRequests.tr(),
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const StoreRequestHistoryPage(),
              ),
            ),
          ),
          IconButton(
            tooltip: LK.authLogout.tr(),
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              HelperFunctions.navigateToPageAndPopAll(
                context,
                const SignInScreen(),
                true,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<StoreRequestBloc, StoreRequestState>(
        listenWhen: (p, c) =>
            p.storeRequestTransactionStatus != c.storeRequestTransactionStatus,
        listener: (context, state) {
          if (state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.success) {
            showMessage(LK.storeStatusCancelledDone.tr(), hasError: false);
            // Re-read so the screen reflects the new status immediately.
            context.read<StoreRequestBloc>().add(
              GetAllStoreRequestsByUserEvent(),
            );
          } else if (state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state.getAllStoreRequestsStatus ==
              GetAllStoreRequestsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // The newest request decides what we tell them.
          final requests = [...state.storeRequests]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final latest = requests.isEmpty ? null : requests.first;
          final status = latest?.storeStatus;

          final (icon, title, body, color) = switch (status) {
            'Pending' => (
              Icons.hourglass_top,
              LK.storeStatusPendingTitle.tr(),
              LK.storeStatusPendingBody.tr(),
              Colors.orange,
            ),
            'Rejected' => (
              Icons.cancel_outlined,
              LK.storeStatusRejectedTitle.tr(),
              LK.storeStatusRejectedBody.tr(),
              Colors.red,
            ),
            _ => (
              Icons.storefront_outlined,
              LK.storeStatusNoneTitle.tr(),
              LK.storeStatusNoneBody.tr(),
              Theme.of(context).colorScheme.primary,
            ),
          };

          return Padding(
            padding: EdgeInsets.all(width(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 72, color: color),
                SizedBox(height: height(20)),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: height(10)),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color(0xff7A7A7A),
                  ),
                ),
                if (status == 'Rejected' &&
                    (latest?.note ?? '').isNotEmpty) ...[
                  SizedBox(height: height(16)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(width(14)),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LK.storeStatusRejectionReason.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.red),
                        ),
                        SizedBox(height: height(4)),
                        Text(latest!.note!),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: height(30)),
                // A request still under review can be withdrawn or corrected
                // by its owner - both are the applicant's own actions, so
                // they only appear while the request is Pending.
                if (status == 'Pending' && latest != null) ...[
                  AuthButton(
                    text: LK.storeStatusEditRequest.tr(),
                    isWhiteBackground: true,
                    widthButton: double.infinity,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StoreRequestEditPage(request: latest!),
                      ),
                    ),
                  ),
                  SizedBox(height: height(10)),
                  AuthButton(
                    text: LK.storeStatusCancelRequest.tr(),
                    color: Colors.red,
                    widthButton: double.infinity,
                    onTap: () async {
                      final ok = await confirmDialog(
                        context,
                        title: LK.storeStatusCancelRequest.tr(),
                        message: LK.storeStatusCancelConfirm.tr(),
                        confirmText: LK.storeStatusCancelRequest.tr(),
                      );
                      if (!ok || !context.mounted) return;
                      context.read<StoreRequestBloc>().add(
                        CancelStoreRequestEvent(storeRequestId: latest!.id),
                      );
                    },
                  ),
                  SizedBox(height: height(10)),
                ],
                if (status != 'Pending')
                  AuthButton(
                    text: LK.sellerSubmit.tr(),
                    widthButton: double.infinity,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SellerRequestPage(),
                      ),
                    ),
                  ),
                SizedBox(height: height(10)),
                AuthButton(
                  text: LK.storeStatusBrowseAsCustomer.tr(),
                  isWhiteBackground: true,
                  widthButton: double.infinity,
                  onTap: () => HelperFunctions.navigateToPageAndPopAll(
                    context,
                    const UserNavBar(),
                    true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
