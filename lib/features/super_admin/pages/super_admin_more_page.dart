import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../admin/admin_shell_screen.dart';
import '../../admin/widgets/confirm_dialog.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../../../core/utils/app_website.dart';
import '../../common/support_sheet.dart';
import '../../home/widgets/drawer/drawer_card.dart';
import '../../payment_employee/pages/wallet_topup_page.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import '../../../core/utils/clear_session_blocs.dart';

/// "More" tab for the platform admin. A super admin can do everything a
/// store owner can, so the store dashboard is reachable from here, as is the
/// customer view, the language switcher and sign-out.
class SuperAdminMorePage extends StatelessWidget {
  const SuperAdminMorePage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.adminMore.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: height(10)),
        children: [
          // _tile(
          //   context,
          //   icon: Icons.account_balance_wallet_outlined,
          //   title: LK.superadminWalletTopup.tr(),
          //   onTap: () => context.pushPage(
          //     BlocProvider(
          //       create: (_) => WalletBloc(),
          //       child: const WalletTopUpPage(),
          //     ),
          //   ),
          // ),
          _tile(
            context,
            icon: Icons.storefront_outlined,
            title: LK.superadminManageOwnStore.tr(),
            onTap: () => context.pushPage(const AdminShellScreen()),
          ),
          _tile(
            context,
            icon: Icons.language,
            title: LK.profileLanguage.tr(),
            onTap: () => _switchLanguage(context),
          ),
          _tile(
            context,
            icon: Icons.headset_mic_outlined,
            title: LK.supportTitle.tr(),
            onTap: () => showSupportSheet(context),
          ),
          _tile(
            context,
            icon: Icons.language,
            title: LK.supportWebsite.tr(),
            onTap: openAppWebsite,
          ),
          const Divider(),
          _tile(
            context,
            icon: Icons.logout,
            title: LK.authLogout.tr(),
            color: Colors.red,
            onTap: () async {
              final confirmed = await confirmDialog(
                context,
                title: LK.authLogout.tr(),
                message: LK.authLogoutConfirm.tr(),
                confirmText: LK.authLogout.tr(),
              );
              if (!confirmed || !context.mounted) return;
              // Wipe every bloc first: they live at the app root and
              // would otherwise carry this session's data into the
              // next sign-in.
              clearSessionBlocs(context);
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
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_left),
      onTap: onTap,
    );
  }
}
