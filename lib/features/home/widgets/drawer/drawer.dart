import 'package:easy_localization/easy_localization.dart';
import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../../blocs/user_bloc/user_bloc.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../../core/localization/language_service.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/session.dart';
import '../../../admin/pages/store_pending_page.dart';
import '../../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../../../shop/pages/complaints_page.dart';
import '../../../shop/pages/profile_page.dart';
import '../../../shop/pages/seller_request_page.dart';
import '../../../shop/pages/wallet_page.dart';
import '../../pages/drawer_pages/who_i_following_screen.dart';
import 'drawer_card.dart';
import '../../../../core/utils/clear_session_blocs.dart';

/// Side drawer: profile, wallet, complaints, seller onboarding, language
/// switcher and sign-out.
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _switchLanguage(BuildContext context) async {
    final current = context.locale.languageCode;
    final picked = await showModalBottomSheet<LangCode>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: LangCode.values.map((code) {
            return ListTile(
              title: Text(languageNameAndLanguageCode[code.name]!),
              trailing: current == code.name
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(sheetContext).colorScheme.primary,
                    )
                  : null,
              onTap: () => Navigator.of(sheetContext).pop(code),
            );
          }).toList(),
        ),
      ),
    );
    if (picked != null && context.mounted) {
      await LanguageService.switchTo(context, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: width(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height(40)),
                if (Session.isGuest)
                  DrawerCard(
                    showArrow: false,
                    icon: "assets/svg/user.svg",
                    title: LK.authGuestMode.tr(),
                    onTap: () => HelperFunctions.navigateToPageAndPopAll(
                      context,
                      const SignInScreen(),
                      true,
                    ),
                  )
                else
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      final profile = state.userProfile;
                      return DrawerCard(
                        showArrow: false,
                        icon: "assets/svg/user.svg",
                        title: profile == null
                            ? LK.profileTitle.tr()
                            : profile.fullName,
                        onTap: () => context.pushPage(const ProfilePage()),
                      );
                    },
                  ),
                Divider(thickness: 0.5, color: onPrimary, endIndent: width(40)),
                SizedBox(height: height(30)),
                if (Session.isSignedIn) ...[
                  DrawerCard(
                    icon: "assets/svg/who_i_follow.svg",
                    title: LK.profileFollowing.tr(),
                    onTap: () => context.pushPage(const WhoIFollowingScreen()),
                  ),
                  SizedBox(height: height(4)),
                  DrawerCard(
                    icon: "assets/svg/save.svg",
                    title: LK.profileWallet.tr(),
                    onTap: () => context.pushPage(const WalletPage()),
                  ),
                  SizedBox(height: height(4)),
                  DrawerCard(
                    icon: "assets/svg/calling.svg",
                    title: LK.profileComplaints.tr(),
                    onTap: () => context.pushPage(const ComplaintsPage()),
                  ),
                  SizedBox(height: height(4)),
                  const _SellerEntry(),
                  SizedBox(height: height(4)),
                ],
                DrawerCard(
                  icon: "assets/svg/lock.svg",
                  title: LK.profileLanguage.tr(),
                  onTap: () => _switchLanguage(context),
                ),
                SizedBox(height: height(60)),
                Divider(thickness: 0.5, color: onPrimary, endIndent: width(40)),
                DrawerCard(
                  icon: "assets/svg/log_out.svg",
                  title: Session.isGuest
                      ? LK.authLogin.tr()
                      : LK.authLogout.tr(),
                  onTap: () => Session.isGuest
                      ? HelperFunctions.navigateToPageAndPopAll(
                          context,
                          const SignInScreen(),
                          true,
                        )
                      : _confirmLogout(context),
                ),
                SizedBox(height: height(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          LK.authLogout.tr(),
          style: Theme.of(dialogContext).textTheme.titleLarge!.copyWith(
            color: Theme.of(dialogContext).colorScheme.primary,
          ),
        ),
        content: Text(
          LK.authLogoutConfirm.tr(),
          style: Theme.of(dialogContext).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              LK.commonNo.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Wipe every bloc first: they live at the app root and
              // would otherwise carry this session's data into the
              // next sign-in.
              clearSessionBlocs(context);
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pop(dialogContext);
              HelperFunctions.navigateToPageAndPopAll(
                context,
                const SignInScreen(),
                true,
              );
            },
            child: Text(
              LK.commonYes.tr(),
              style: Theme.of(dialogContext).textTheme.titleMedium!.copyWith(
                color: Theme.of(dialogContext).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One drawer row that is either "open your own store" or "review my store
/// request", decided by `StoreRequest/GetAllRequestStoreByUser`.
///
/// A customer with a request still under review has nothing to gain from the
/// application form - it would file a second request - so they get the
/// review screen (status, edit, cancel) instead. Anyone else, including
/// someone whose last request was rejected or cancelled, gets the form.
///
/// The list is refetched by [UserNavBar] every time the drawer opens, so
/// submitting or cancelling a request is reflected the next time it is
/// pulled out.
class _SellerEntry extends StatelessWidget {
  const _SellerEntry();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreRequestBloc, StoreRequestState>(
      buildWhen: (p, c) => p.storeRequests != c.storeRequests,
      builder: (context, state) {
        final requests = [...state.storeRequests]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final isUnderReview =
            requests.isNotEmpty && requests.first.storeStatus == 'Pending';

        if (isUnderReview) {
          return DrawerCard(
            icon: "assets/svg/flag.svg",
            title: LK.drawerReviewStoreRequest.tr(),
            onTap: () => context.pushPage(
              const StorePendingPage(showAccountActions: false),
            ),
          );
        }
        return DrawerCard(
          icon: "assets/svg/flag.svg",
          title: LK.profileBecomeSeller.tr(),
          onTap: () => context.pushPage(const SellerRequestPage()),
        );
      },
    );
  }
}
