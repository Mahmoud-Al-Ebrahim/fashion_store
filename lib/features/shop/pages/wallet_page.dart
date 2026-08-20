import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../widgets/price_tag.dart';

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
              SizedBox(height: height(20)),
              Text(
                LK.profileTransactions.tr(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: height(10)),
              AsyncView(
                isLoading: state.getAllTransactionsStatus ==
                    GetAllTransactionsStatus.loading,
                isFailure: state.getAllTransactionsStatus ==
                    GetAllTransactionsStatus.failure,
                isEmpty: state.getAllTransactionsStatus ==
                        GetAllTransactionsStatus.success &&
                    state.transactions.isEmpty,
                errorMessage: state.errorMessage,
                emptyText: LK.profileNoTransactions.tr(),
                emptyImageHeight: height(120),
                child: Column(
                  children: state.transactions.map((t) {
                    final isDeposit = t.transactionType == 'Deposit';
                    return Container(
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
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
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
                        ],
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
