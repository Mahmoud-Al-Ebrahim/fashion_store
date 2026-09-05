import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/screen_util.dart';
import '../../shop/widgets/wallet_id_card.dart';
import '../widgets/admin_async_view.dart';
import '../../../core/localization/translation_keys.dart';
import '../../payment_employee/widgets/transaction_details_sheet.dart';

class AdminWalletPage extends StatefulWidget {
  const AdminWalletPage({super.key});

  @override
  State<AdminWalletPage> createState() => _AdminWalletPageState();
}

class _AdminWalletPageState extends State<AdminWalletPage> {
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
        title: Text(LK.adminWalletTransactions.tr()),
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
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                    SizedBox(height: height(6)),
                    Text(
                      state.wallet == null
                          ? '-'
                          : state.wallet!.balance.toStringAsFixed(2),
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
              // A store owner does not top this wallet up - it fills from
              // their sales - so the id is there to look the balance up,
              // not to hand to the payment desk.
              WalletIdCard(
                walletId: state.wallet?.id,
                hint: LK.walletIdHintBalance.tr(),
              ),
              SizedBox(height: height(20)),
              Text(
                LK.profileTransactions.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: height(10)),
              AdminAsyncView(
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
                child: Column(
                  children: state.transactions.map((t) {
                    final isDeposit = t.transactionType == 'Deposit';
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      // Same ledger detail the payment desk and the platform
                      // admin get: what order this payment settled.
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
                                    '${t.date.year}-${t.date.month}-${t.date.day}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              t.amount.toStringAsFixed(2),
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
