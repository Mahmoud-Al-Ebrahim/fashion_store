import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../shop/pages/product_by_id_page.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/option_picker_field.dart';

class AdminOrderDetailPage extends StatefulWidget {
  final int orderId;

  /// The order's own status - `Processing`, `Delivered` or `Cancelled`.
  ///
  /// The detail endpoints return the order's items and its *payment*, and
  /// the payment reads `Paid` even for cancelled orders, so nothing on this
  /// screen could tell whether the order is still open. Without it the
  /// status editor was always offered, and the server answered every
  /// attempt with "لا يمكن تعديل الطلب لأنه في حالة Cancelled بالفعل" -
  /// which is why changing an order's status looked broken.
  final String? orderStatus;

  const AdminOrderDetailPage({
    super.key,
    required this.orderId,
    this.orderStatus,
  });

  @override
  State<AdminOrderDetailPage> createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  String? _selectedStatus;

  /// True when nothing about this order's status can still be changed.
  ///
  /// Only a `Processing` order is actionable: `Delivered` and `Cancelled`
  /// are terminal, and the server rejects any move out of them. An order
  /// opened without a known status is treated as locked too - guessing
  /// would just produce a rejected request.
  bool get _statusIsFinal => !orderStatusIsEditable(widget.orderStatus);

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
        listenWhen: (p, c) =>
            p.updateOrderStatusStatus != c.updateOrderStatusStatus,
        listener: (context, state) {
          if (state.updateOrderStatusStatus ==
              UpdateOrderStatusStatus.success) {
            showMessage(LK.ordersStatusUpdated.tr(), hasError: false);
          } else if (state.updateOrderStatusStatus ==
              UpdateOrderStatusStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state.getOrderItemsStatus == GetOrderItemsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.all(width(16)),
            children: [
              if (state.payment != null) ...[
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
                          Text(
                            '${LK.ordersPaymentAmount.tr()}: ${state.payment!.amount.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      if (widget.orderStatus != 'Cancelled')
                        AdminStatusBadge(status: state.payment!.status),
                    ],
                  ),
                ),
                SizedBox(height: height(16)),
              ],
              // `Delivered` and `Cancelled` are terminal: the server refuses
              // any further change, so the editor is hidden rather than
              // shown and rejected.
              if (_statusIsFinal) ...[
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: width(6)),
                    Expanded(
                      child: Text(
                        LK.ordersStatusFinal.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  LK.ordersUpdateStatus.tr(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: height(8)),
                OptionPickerField(
                  hintText: LK.ordersStatus.tr(),
                  // One move, one option: mark it delivered.
                  options: orderStatusUpdateOptions(),
                  selectedValue: _selectedStatus,
                  onSelected: (o) => setState(() => _selectedStatus = o.value),
                ),
                SizedBox(height: height(10)),
                AuthButton(
                  // The call takes a moment; without this the button looked
                  // inert and invited a second tap.
                  text:
                      state.updateOrderStatusStatus ==
                          UpdateOrderStatusStatus.loading
                      ? LK.commonSaving.tr()
                      : LK.commonSave.tr(),
                  widthButton: double.infinity,
                  heightButton: height(50),
                  onTap:
                      state.updateOrderStatusStatus ==
                              UpdateOrderStatusStatus.loading ||
                          _selectedStatus == null
                      ? null
                      : () {
                          context.read<OrderBloc>().add(
                            UpdateOrderStatusEvent(
                              orderId: widget.orderId,
                              status: _selectedStatus!,
                            ),
                          );
                        },
                ),
              ],
              SizedBox(height: height(20)),
              Text(
                '${LK.ordersItems.tr()} (${state.orderItems.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: height(8)),
              ...state.orderItems.map((item) {
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  // Reached by the store owner and by the super admin from
                  // the platform order history - both land on the same
                  // product screen a customer would see.
                  // Store owner and super admin both reach this screen to
                  // administrate an order - neither is shopping, so the
                  // product opens without a buy affordance.
                  onTap: () => openProductById(
                    context,
                    item.productId,
                    allowPurchase: false,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: height(10)),
                    padding: EdgeInsets.all(width(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD3D3E4)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.image,
                            width: width(56),
                            height: width(56),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: width(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${LK.adminProductNumber.tr()}${item.productId}',
                              ),
                              Text(
                                '${localizedColorName(item.color)} - ${sizeLabel(item.size)} × ${item.quantity}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(item.price.toStringAsFixed(0)),
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
              }),
            ],
          );
        },
      ),
    );
  }
}
