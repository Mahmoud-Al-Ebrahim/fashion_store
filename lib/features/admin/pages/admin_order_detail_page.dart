import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../admin_enums.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/option_picker_field.dart';

class AdminOrderDetailPage extends StatefulWidget {
  final int orderId;

  const AdminOrderDetailPage({super.key, required this.orderId});

  @override
  State<AdminOrderDetailPage> createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  String? _selectedStatus;

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
        title: Text('طلب #${widget.orderId}'),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listenWhen: (p, c) => p.updateOrderStatusStatus != c.updateOrderStatusStatus,
        listener: (context, state) {
          if (state.updateOrderStatusStatus == UpdateOrderStatusStatus.success) {
            showMessage('تم تحديث حالة الطلب', hasError: false);
          } else if (state.updateOrderStatusStatus == UpdateOrderStatusStatus.failure) {
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
                          Text('الدفع', style: Theme.of(context).textTheme.titleSmall),
                          Text(
                            'المبلغ: ${state.payment!.amount.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      AdminStatusBadge(status: state.payment!.status),
                    ],
                  ),
                ),
                SizedBox(height: height(16)),
              ],
              Text(
                'تحديث حالة الطلب',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: height(8)),
              OptionPickerField(
                hintText: 'الحالة',
                options: kOrderStatusOptions,
                selectedValue: _selectedStatus,
                onSelected: (o) => setState(() => _selectedStatus = o.value),
              ),
              SizedBox(height: height(10)),
              AuthButton(
                text: 'حفظ الحالة',
                widthButton: double.infinity,
                heightButton: height(50),
                onTap: _selectedStatus == null
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
              SizedBox(height: height(20)),
              Text(
                'المنتجات (${state.orderItems.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: height(8)),
              ...state.orderItems.map((item) {
                return Container(
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
                            Text('منتج #${item.productId}'),
                            Text(
                              '${item.color} - ${item.size} × ${item.quantity}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(item.price.toStringAsFixed(0)),
                    ],
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
