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
import '../nav_bar/user_nav_bar/user_nav_bar_screen.dart';
import '../../core/extensions/build_context.dart';
import 'pages/topup_history_page.dart';
import 'pages/wallet_topup_page.dart';

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
  int _currentIndex = 0;

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
              // Every role can browse the catalogue (and therefore rate and
              // comment on products), even this narrow back-office one.
              IconButton(
                tooltip: LK.storeStatusBrowseAsCustomer.tr(),
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => context.pushPage(const UserNavBar()),
              ),
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
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              TopUpHistoryPage(embedded: true),
              WalletTopUpPage(embedded: true),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long),
                label: LK.paymentTopups.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: const Icon(Icons.account_balance_wallet),
                label: LK.paymentNewTopup.tr(),
              ),
            ],
          ),
    );
  }
}
