import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../widgets/admin_async_view.dart';
import '../widgets/admin_status_badge.dart';
import 'admin_order_detail_page.dart';
import '../../../core/localization/translation_keys.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<OrderBloc>().add(GetAllOrdersEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.adminOrders.tr()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return AdminAsyncView(
              isLoading: state.getAllOrdersStatus == GetAllOrdersStatus.loading,
              isFailure: state.getAllOrdersStatus == GetAllOrdersStatus.failure,
              isEmpty:
                  state.getAllOrdersStatus == GetAllOrdersStatus.success &&
                  state.orders.isEmpty,
              errorMessage: state.errorMessage,
              emptyText: LK.adminNoOrders.tr(),
              onRetry: _load,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                itemCount: state.orders.length,
                separatorBuilder: (_, __) => SizedBox(height: height(10)),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(14),
                      vertical: height(12),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD3D3E4)),
                    ),
                    child: InkWell(
                      onTap: () => context.pushPage(
                        AdminOrderDetailPage(
                          orderId: order.id,
                          orderStatus: order.status,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${LK.ordersOrderNumber.tr()}${order.id}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                SizedBox(height: height(4)),
                                Text(
                                  order.address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                SizedBox(height: height(4)),
                                Text(
                                  '${LK.ordersTotal.tr()}: ${order.totalPrice.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          AdminStatusBadge(status: order.status),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
