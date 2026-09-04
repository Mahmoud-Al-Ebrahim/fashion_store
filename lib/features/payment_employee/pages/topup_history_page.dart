import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../shop/widgets/price_tag.dart';
import '../widgets/transaction_details_sheet.dart';

/// Past wallet top-up operations from `Transaction/GetAllTransactions`.
///
/// Note: the endpoint is scoped to the caller's own wallet server-side, so
/// this is the operator's own ledger rather than a platform-wide feed - the
/// API exposes no "all transactions" endpoint.
class TopUpHistoryPage extends StatefulWidget {
  /// When hosted inside a shell that already draws an app bar, render just
  /// the body so the two titles do not stack.
  final bool embedded;

  const TopUpHistoryPage({super.key, this.embedded = false});

  @override
  State<TopUpHistoryPage> createState() => _TopUpHistoryPageState();
}

class _TopUpHistoryPageState extends State<TopUpHistoryPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<WalletBloc>().add(GetAllTransactionsEvent());

  @override
  Widget build(BuildContext context) {
    final content = BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width(16),
                vertical: height(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: width(6)),
                  Expanded(
                    child: Text(
                      LK.paymentHistoryScopeNote.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncView(
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
                emptyText: LK.paymentNoTopups.tr(),
                onRetry: _load,
                child: RefreshIndicator(
                  onRefresh: () async => _load(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(width(16)),
                    itemCount: state.transactions.length,
                    separatorBuilder: (_, __) => SizedBox(height: height(10)),
                    itemBuilder: (context, index) {
                      final t = state.transactions[index];
                      final isDeposit = t.transactionType == 'Deposit';
                      // Wallet top-ups carry no `paymentId` and have no
                      // order behind them, so they offer no details. Same
                      // rule as the customer's wallet.
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => showTransactionDetailsSheet(context, t),
                        child: Container(
                          padding: EdgeInsets.all(width(12)),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD3D3E4)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    (isDeposit ? Colors.green : Colors.red)
                                        .withValues(alpha: 0.12),
                                child: Icon(
                                  isDeposit
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  size: 18,
                                  color: isDeposit ? Colors.green : Colors.red,
                                ),
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    SizedBox(height: height(2)),
                                    Text(
                                      '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                    Text(
                                      t.walletId,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isDeposit ? '+' : '-'}${formatPrice(t.amount)}',
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
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (widget.embedded) return content;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.paymentTopups.tr()),
      ),
      body: content,
    );
  }
}
