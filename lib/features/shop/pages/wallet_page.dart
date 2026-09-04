import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../widgets/price_tag.dart';
import '../../../core/utils/whatsapp.dart';
import '../../payment_employee/widgets/transaction_details_sheet.dart';
import '../widgets/wallet_id_card.dart';

/// Customer wallet balance + transaction ledger.
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetWalletEvent());
    context.read<WalletBloc>().add(GetAllTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.profileWallet.tr()),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(width(16)),
            children: [
              Container(
                padding: EdgeInsets.all(width(20)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LK.profileBalance.tr(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: height(6)),
                    Text(
                      state.wallet == null
                          ? '-'
                          : '${formatPrice(state.wallet!.balance)} ${LK.commonCurrency.tr()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height(14)),
              // The payment desk credits wallets by id, so surface it here.
              WalletIdCard(walletId: state.wallet?.id),
              SizedBox(height: height(12)),
              // Top-ups are done by a human at the payment desk, so give the
              // customer a direct line with their wallet id pre-filled.
              _TopUpAgentButton(walletId: state.wallet?.id),
              SizedBox(height: height(20)),
              Text(
                LK.profileTransactions.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: height(10)),
              AsyncView(
                isLoading:
                    state.getAllTransactionsStatus ==
                    GetAllTransactionsStatus.loading,
                isFailure:
                    state.getAllTransactionsStatus ==
                    GetAllTransactionsStatus.failure,
                isEmpty:
                    state.getAllTransactionsStatus ==
                        GetAllTransactionsStatus.success &&
                    state.transactions.isEmpty,
                errorMessage: state.errorMessage,
                emptyText: LK.profileNoTransactions.tr(),
                emptyImageHeight: height(120),
                child: Column(
                  children: state.transactions.map((t) {
                    final isDeposit = t.transactionType == 'Deposit';
                    // A top-up has no order behind it - `paymentId` is
                    // null and GetOrderDetailsByPayment answers 404 - so it
                    // gets no details affordance. Note the gate is the
                    // payment link, not the type: a Deposit that carries a
                    // paymentId is money arriving from a sale and does have
                    // an order worth showing.
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      // Every operation opens its details; a top-up simply
                      // explains itself instead of offering a retry.
                      onTap: () => showTransactionDetailsSheet(context, t),
                      child: Container(
                        margin: EdgeInsets.only(bottom: height(8)),
                        padding: EdgeInsets.symmetric(
                          horizontal: width(12),
                          vertical: height(10),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD3D3E4)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDeposit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isDeposit ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: width(10)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isDeposit
                                        ? LK.profileDeposit.tr()
                                        : LK.profileWithdraw.tr(),
                                  ),
                                  Text(
                                    '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatPrice(t.amount),
                              style: TextStyle(
                                color: isDeposit ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: width(4)),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// "Top up via WhatsApp" call-to-action.
///
/// Opens a chat with the payment desk, pre-filling the customer's wallet id
/// so the operator does not have to ask for it - that id is exactly what
/// `Transaction/AddTransaction` needs on their side.
class _TopUpAgentButton extends StatelessWidget {
  const _TopUpAgentButton({required this.walletId});

  final String? walletId;

  @override
  Widget build(BuildContext context) {
    const whatsappGreen = Color(0xFF25D366);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => openWhatsApp(
        context,
        phone: kTopUpAgentWhatsApp,
        message: walletId == null || walletId!.isEmpty
            ? null
            : LK.walletContactAgentMessage.tr(args: [walletId!]),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width(12),
          vertical: height(12),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: whatsappGreen),
          borderRadius: BorderRadius.circular(14),
          color: whatsappGreen.withValues(alpha: 0.08),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(width(8)),
              decoration: const BoxDecoration(
                color: whatsappGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chat, color: Colors.white, size: width(18)),
            ),
            SizedBox(width: width(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LK.walletContactAgent.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: height(2)),
                  Text(
                    LK.walletContactAgentHint.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
