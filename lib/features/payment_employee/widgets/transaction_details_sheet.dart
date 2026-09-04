import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../models/wallet/payment_order_details_model.dart';
import '../../../models/wallet/transaction_model.dart';
import '../../shop/widgets/price_tag.dart';

/// Opens the details of [transaction] in a bottom sheet.
///
/// Fetches `Transaction/GetOrderDetailsByPayment/{id}` through [WalletBloc],
/// so the caller only has to hand over the row that was tapped. The bloc is
/// resolved from the calling context and passed down with `BlocProvider
/// .value`: `showModalBottomSheet` builds its content under the Navigator,
/// outside the caller's provider subtree.
Future<void> showTransactionDetailsSheet(
  BuildContext context,
  TransactionModel transaction,
) {
  final walletBloc = context.read<WalletBloc>()
    ..add(GetOrderDetailsByPaymentEvent(transactionId: transaction.id));

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => BlocProvider.value(
      value: walletBloc,
      child: _TransactionDetailsSheet(transaction: transaction),
    ),
  );
}

class _TransactionDetailsSheet extends StatelessWidget {
  const _TransactionDetailsSheet({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.transactionType == 'Deposit';
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Column(
          children: [
            SizedBox(height: height(10)),
            Container(
              width: width(44),
              height: height(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: height(12)),
            Text(
              LK.paymentTxDetails.tr(),
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: height(12)),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: width(16)),
                children: [
                  // ----- the transaction itself, straight from the row -----
                  _InfoTile(
                    label: LK.paymentTxAmount.tr(),
                    value:
                        '${formatPrice(transaction.amount)} '
                        '${LK.commonCurrency.tr()}',
                    valueColor: isDeposit ? Colors.green : Colors.red,
                  ),
                  _InfoTile(
                    label: LK.paymentTxType.tr(),
                    value: isDeposit
                        ? LK.profileDeposit.tr()
                        : LK.profileWithdraw.tr(),
                  ),
                  _InfoTile(
                    label: LK.paymentTxDate.tr(),
                    value: _formatDateTime(transaction.date),
                  ),
                  _InfoTile(
                    label: LK.paymentTxWallet.tr(),
                    value: transaction.walletId,
                    small: true,
                  ),
                  SizedBox(height: height(16)),

                  // ----- the order this payment settled -----
                  BlocBuilder<WalletBloc, WalletState>(
                    buildWhen: (p, c) =>
                        p.getOrderDetailsByPaymentStatus !=
                            c.getOrderDetailsByPaymentStatus ||
                        p.paymentOrderDetails != c.paymentOrderDetails,
                    builder: (context, state) {
                      final status = state.getOrderDetailsByPaymentStatus;
                      final details = state.paymentOrderDetails;

                      // A wallet top-up carries no `paymentId` and has no
                      // order behind it, so the lookup answers 404. That is
                      // the normal, expected outcome for a top-up - not a
                      // failure worth a Retry button - so it is explained
                      // in place instead.
                      final isBalanceTransfer = transaction.paymentId == null;
                      if (isBalanceTransfer &&
                          status != GetOrderDetailsByPaymentStatus.loading &&
                          status != GetOrderDetailsByPaymentStatus.init) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: height(18)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.swap_horiz,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: width(8)),
                              Expanded(
                                child: Text(
                                  LK.paymentFromBalanceTransfer.tr(),
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return AsyncView(
                        isLoading:
                            status == GetOrderDetailsByPaymentStatus.loading ||
                            status == GetOrderDetailsByPaymentStatus.init,
                        isFailure:
                            status == GetOrderDetailsByPaymentStatus.failure,
                        isEmpty:
                            status == GetOrderDetailsByPaymentStatus.success &&
                            (details == null || details.products.isEmpty),
                        errorMessage: state.errorMessage,
                        emptyText: LK.paymentTxNoDetails.tr(),
                        emptyImageHeight: height(90),
                        onRetry: () => context.read<WalletBloc>().add(
                          GetOrderDetailsByPaymentEvent(
                            transactionId: transaction.id,
                          ),
                        ),
                        child: details == null
                            ? const SizedBox.shrink()
                            : _OrderDetails(details: details),
                      );
                    },
                  ),
                  SizedBox(height: height(24)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.details});

  final PaymentOrderDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        SizedBox(height: height(8)),
        Text(
          LK.paymentTxOrder.tr(args: ['${details.orderId}']),
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: height(8)),
        _InfoTile(
          label: LK.paymentTxCustomer.tr(),
          value: details.customerName,
        ),
        SizedBox(height: height(10)),
        Text(
          LK.paymentTxProducts.tr(),
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: height(8)),
        ...details.products.map((p) => _ProductLine(product: p)),
        SizedBox(height: height(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LK.cartTotal.tr(),
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${formatPrice(details.total)} ${LK.commonCurrency.tr()}',
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductLine extends StatelessWidget {
  const _ProductLine({required this.product});

  final PaymentOrderProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = ApiService.resolveUrl(product.image) ?? '';
    return Container(
      margin: EdgeInsets.only(bottom: height(8)),
      padding: EdgeInsets.all(width(8)),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD3D3E4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: url.isEmpty
                ? _imageFallback()
                : CachedNetworkImage(
                    imageUrl: url,
                    width: width(46),
                    height: height(46),
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _imageFallback(),
                  ),
          ),
          SizedBox(width: width(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.storeName,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height(3)),
                Wrap(
                  spacing: width(8),
                  runSpacing: height(4),
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (product.color.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: width(12),
                            height: width(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _hex(product.colorHex),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                          ),
                          SizedBox(width: width(4)),
                          Text(
                            localizedColorName(product.color),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    if (product.size.isNotEmpty)
                      Text(
                        sizeLabel(product.size),
                        style: theme.textTheme.bodySmall,
                      ),
                    Text(
                      '${LK.paymentTxQty.tr()}: ${product.quantity}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: width(8)),
          Text(
            formatPrice(product.totalPrice),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() => Container(
    width: width(46),
    height: height(46),
    color: Colors.grey.shade200,
    child: const Icon(Icons.image_not_supported, size: 18),
  );

  /// The API hands back `#RRGGBB`; pad it to ARGB and fall back to grey.
  static Color _hex(String value) {
    var v = value.replaceAll('#', '').trim();
    if (v.length == 6) v = 'FF$v';
    return Color(int.tryParse(v, radix: 16) ?? 0xFF9E9E9E);
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.valueColor,
    this.small = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
          SizedBox(width: width(12)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:
                  (small
                          ? theme.textTheme.bodySmall!
                          : theme.textTheme.bodyMedium!)
                      .copyWith(fontWeight: FontWeight.w600, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')} '
    '${d.hour.toString().padLeft(2, '0')}:'
    '${d.minute.toString().padLeft(2, '0')}';
