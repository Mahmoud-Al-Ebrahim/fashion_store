import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/session.dart';
import '../../../core/utils/show_message.dart';
import '../../../core/utils/validators.dart';
import '../../shop/widgets/price_tag.dart';

/// Credits a wallet with funds (`Transaction/AddTransaction`).
///
/// The wallet id is entered by hand - the users endpoint doesn't expose
/// wallet ids, so there's nothing to pick from. Amounts are credit-only and
/// must be a real number greater than zero; the screen refuses to submit
/// anything else.
///
/// Reachable only by [AppRole.paymentEmployee] and [AppRole.superAdmin].
class WalletTopUpPage extends StatefulWidget {
  /// When hosted inside a shell that already draws an app bar, render just
  /// the body so the two titles do not stack.
  final bool embedded;
  final bool isSuperAdmin;

  const WalletTopUpPage({super.key, this.embedded = false, this.isSuperAdmin = false});

  @override
  State<WalletTopUpPage> createState() => _WalletTopUpPageState();
}

class _WalletTopUpPageState extends State<WalletTopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _walletIdController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _walletIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final walletId = _walletIdController.text.trim();
    final amount = double.parse(_amountController.text.trim());

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LK.paymentConfirmTitle.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LK.paymentConfirmBody.tr()),
            SizedBox(height: height(12)),
            Text(
              '+ ${formatPrice(amount)} ${LK.commonCurrency.tr()}',
              style: Theme.of(dialogContext).textTheme.titleMedium!.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: height(6)),
            Text(
              walletId,
              style: Theme.of(dialogContext).textTheme.bodySmall!.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LK.commonCancel.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LK.commonConfirm.tr()),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    context.read<WalletBloc>().add(
      AddTransactionEvent(walletId: walletId, amount: amount),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Defensive: this screen must never be reachable by other roles.
    if (!Session.canTopUpWallets) {
      return Scaffold(
        appBar: AppBar(title: Text(LK.paymentNewTopup.tr())),
        body: Center(child: Text(LK.commonErrorGeneric.tr())),
      );
    }

    final content = BlocListener<WalletBloc, WalletState>(
        listenWhen: (p, c) => p.addTransactionStatus != c.addTransactionStatus,
        listener: (context, state) {
          if (state.addTransactionStatus == AddTransactionStatus.success) {
            showMessage(LK.paymentSuccess.tr(), hasError: false);
            _walletIdController.clear();
            _amountController.clear();
            FocusScope.of(context).unfocus();
          } else if (state.addTransactionStatus ==
              AddTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width(16)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(width(12)),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.green,
                      ),
                      SizedBox(width: width(8)),
                      Expanded(
                        child: Text(
                          LK.paymentDepositOnlyNote.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height(20)),
                AuthTextField(
                  controller: _walletIdController,
                  hintText: LK.paymentWalletIdHint.tr(),
                  validator: validateWalletId,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _amountController,
                  hintText: LK.paymentAmount.tr(),
                  // Digits and a single decimal separator only - no minus
                  // sign, so a negative amount can't even be typed.
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: validatePositiveAmount,
                ),
                SizedBox(height: height(24)),
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    final loading = state.addTransactionStatus ==
                        AddTransactionStatus.loading;
                    return AuthButton(
                      text: loading
                          ? LK.commonLoading.tr()
                          : LK.paymentSubmit.tr(),
                      onTap: loading ? null : _submit,
                      widthButton: double.infinity,
                      heightButton: height(54),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    );

    if (widget.embedded) return content;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.paymentNewTopup.tr()),
      ),
      body: content,
    );
  }
}
