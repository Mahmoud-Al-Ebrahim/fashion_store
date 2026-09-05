import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../core/helper/helper_functions.dart';
import '../../core/localization/language_service.dart';
import '../../core/localization/translation_keys.dart';
import '../admin/widgets/confirm_dialog.dart';
import '../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../common/support_sheet.dart';
import 'pages/wallet_topup_page.dart';
import '../../core/utils/clear_session_blocs.dart';

/// Shell for the payment-desk role ("EmployeeOfPayment").
///
/// Deliberately narrow: this account only reviews past top-ups and credits
/// wallets. It has no catalog, order or user-management surface.
class PaymentEmployeeShellScreen extends StatefulWidget {
  const PaymentEmployeeShellScreen({super.key});

  @override
  State<PaymentEmployeeShellScreen> createState() =>
      _PaymentEmployeeShellScreenState();
}

class _PaymentEmployeeShellScreenState
    extends State<PaymentEmployeeShellScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetAllTransactionsEvent());
  }

  Future<void> _switchLanguage(BuildContext context) async {
    final current = context.locale.languageCode;
    final picked = await showModalBottomSheet<LangCode>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: LangCode.values
              .map(
                (code) => ListTile(
                  title: Text(languageNameAndLanguageCode[code.name]!),
                  trailing: current == code.name
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(sheetContext).colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(code),
                ),
              )
              .toList(),
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
        title: Text(LK.paymentTitle.tr()),
        actions: [
          IconButton(
            tooltip: LK.profileLanguage.tr(),
            icon: const Icon(Icons.language),
            onPressed: () => _switchLanguage(context),
          ),
          IconButton(
            tooltip: LK.authLogout.tr(),
            icon: const Icon(Icons.logout),
            onPressed: () async {
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
      // No drawer and no "more" list on this shell, so support gets a
      // floating button rather than being unreachable for this role.
      floatingActionButton: FloatingActionButton.small(
        tooltip: LK.supportTitle.tr(),
        onPressed: () => showSupportSheet(context),
        child: const Icon(Icons.headset_mic_outlined),
      ),
      // The top-up history tab was removed on request, leaving crediting a
      // wallet as the only screen. The app bar still carries language and
      // sign-out, so nothing became unreachable, and the bottom bar is gone
      // because a single destination does not need one.
      body: const WalletTopUpPage(embedded: true),
    );
  }
}
