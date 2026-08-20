import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../admin/widgets/admin_status_badge.dart';
import '../widgets/price_tag.dart';
import 'order_details_page.dart';

/// Customer order history from `Order/GetAllOrder`.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<OrderBloc>().add(GetAllOrdersEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: BlocBuilder<OrderBloc, OrderState>(
          buildWhen: (p, c) =>
              p.getAllOrdersStatus != c.getAllOrdersStatus ||
              p.orders != c.orders,
          builder: (context, state) {
            return AsyncView(
              isLoading: state.getAllOrdersStatus == GetAllOrdersStatus.loading,
              isFailure: state.getAllOrdersStatus == GetAllOrdersStatus.failure,
              isEmpty: state.getAllOrdersStatus == GetAllOrdersStatus.success &&
                  state.orders.isEmpty,
              errorMessage: state.errorMessage,
              emptyText: LK.ordersNoOrders.tr(),
              onRetry: _load,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                itemCount: state.orders.length,
                separatorBuilder: (_, __) => SizedBox(height: height(12)),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => context.pushPage(
                      OrderDetailsPage(orderId: order.id),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(width(14)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFD3D3E4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${LK.ordersOrderNumber.tr()}${order.id}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Spacer(),
                              AdminStatusBadge(status: order.status),
                            ],
                          ),
                          SizedBox(height: height(8)),
                          Text(
                            order.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(height: height(6)),
                          Row(
                            children: [
                              Text(
                                '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey),
                              ),
                              const Spacer(),
                              PriceTag(
                                price: order.totalPrice,
                                priceAfterDiscount: order.totalPrice,
                                hasDiscount: false,
                              ),
                            ],
                          ),
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
