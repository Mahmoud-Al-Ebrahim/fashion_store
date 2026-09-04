import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import 'product_by_id_page.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/show_message.dart';
import '../../admin/widgets/admin_status_badge.dart';
import '../../admin/widgets/confirm_dialog.dart';
import '../widgets/price_tag.dart';

/// Order detail: line items, payment record, and cancel action.
class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  /// Order status from the list that opened this screen - `Processing`,
  /// `Delivered` or `Cancelled`.
  ///
  /// The detail endpoints return the order's *items* and its *payment*, and
  /// the payment reads `Paid` for every order including cancelled ones, so
  /// it cannot say whether cancelling is still allowed. The status travels
  /// from the list instead, which is the only place the API exposes it.
  final String? orderStatus;

  const OrderDetailsPage({super.key, required this.orderId, this.orderStatus});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderItemsEvent(orderId: widget.orderId));
    context.read<OrderBloc>().add(GetPaymentEvent(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text('${LK.ordersOrderNumber.tr()}${widget.orderId}'),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listenWhen: (p, c) => p.cancelOrderStatus != c.cancelOrderStatus,
        listener: (context, state) {
          if (state.cancelOrderStatus == CancelOrderStatus.success) {
            showMessage(LK.ordersCancelledSuccess.tr(), hasError: false);
            Navigator.of(context).pop();
          } else if (state.cancelOrderStatus == CancelOrderStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state.getOrderItemsStatus == GetOrderItemsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final payment = state.payment;

          // A customer may only withdraw an order that is still being
          // processed. Once it is delivered - or already cancelled - the
          // button is gone rather than shown and rejected by the server.
          final status = widget.orderStatus;
          final cancellable = status == null
              ? payment?.status != 'Cancelled'
              : status == 'Processing';

          return ListView(
            padding: EdgeInsets.all(width(16)),
            children: [
              // A cancelled order was never settled, so its payment line
              // is noise at best and misleading at worst.
              if (payment != null && status != 'Cancelled')
                Container(
                  padding: EdgeInsets.all(width(14)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAF2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LK.ordersPayment.tr(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: height(4)),
                          PriceTag(
                            price: payment.amount,
                            priceAfterDiscount: payment.amount,
                            hasDiscount: false,
                          ),
                        ],
                      ),
                      AdminStatusBadge(status: payment.status),
                    ],
                  ),
                ),
              SizedBox(height: height(18)),
              Text(
                '${LK.ordersItems.tr()} (${state.orderItems.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: height(10)),
              ...state.orderItems.map(
                (item) => InkWell(
                  borderRadius: BorderRadius.circular(16),
                  // Order lines carry a product id only; resolve it.
                  onTap: () => openProductById(context, item.productId),
                  child: Container(
                    margin: EdgeInsets.only(bottom: height(10)),
                    padding: EdgeInsets.all(width(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD3D3E4)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: ApiService.resolveUrl(item.image) ?? '',
                            width: width(60),
                            height: width(60),
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: const Color(0xFFEAEAF2),
                              child: const Icon(Icons.checkroom),
                            ),
                          ),
                        ),
                        SizedBox(width: width(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: parseHexColor(item.colorHex),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                  ),
                                  SizedBox(width: width(6)),
                                  Text(
                                    '${localizedColorName(item.color)} • ${sizeLabel(item.size)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: height(4)),
                              Text('× ${item.quantity}'),
                            ],
                          ),
                        ),
                        PriceTag(
                          price: item.price,
                          priceAfterDiscount: item.price,
                          hasDiscount: false,
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
                ),
              ),
              SizedBox(height: height(20)),
              if (!cancellable && status != null && status != 'Cancelled')
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: width(6)),
                    Expanded(
                      child: Text(
                        LK.ordersCannotCancel.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              if (cancellable)
                AuthButton(
                  text: LK.ordersCancel.tr(),
                  color: Colors.red,
                  widthButton: double.infinity,
                  heightButton: height(52),
                  onTap: () async {
                    final confirmed = await confirmDialog(
                      context,
                      title: LK.ordersCancel.tr(),
                      message: LK.ordersCancelConfirm.tr(),
                      confirmText: LK.commonYes.tr(),
                    );
                    if (!confirmed || !context.mounted) return;
                    context.read<OrderBloc>().add(
                      CancelOrderEvent(orderId: widget.orderId),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
