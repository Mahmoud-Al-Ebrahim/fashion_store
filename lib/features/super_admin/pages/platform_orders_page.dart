import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/super_admin_bloc/super_admin_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/extensions/build_context.dart';
import '../../admin/pages/admin_order_detail_page.dart';
import '../../admin/widgets/admin_status_badge.dart';
import '../../shop/widgets/price_tag.dart';

/// Platform-wide order list, filterable by status.
class PlatformOrdersPage extends StatefulWidget {
  const PlatformOrdersPage({super.key});

  @override
  State<PlatformOrdersPage> createState() => _PlatformOrdersPageState();
}

class _PlatformOrdersPageState extends State<PlatformOrdersPage> {
  String _status = 'Processing';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<SuperAdminBloc>().add(
      GetAllFilterOrdersEvent(
        orderStatus: _status,
        pageNumber: 1,
        pageSize: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.superadminPlatformOrders.tr()),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height(50),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: width(16)),
              itemCount: kOrderStatusValues.length,
              separatorBuilder: (_, __) => SizedBox(width: width(8)),
              itemBuilder: (context, index) {
                final status = kOrderStatusValues[index];
                return Center(
                  child: ChoiceChip(
                    label: Text(LK.statusKey(status).tr()),
                    selected: status == _status,
                    onSelected: (_) {
                      setState(() => _status = status);
                      _load();
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SuperAdminBloc, SuperAdminState>(
              builder: (context, state) {
                return AsyncView(
                  isLoading:
                      state.getAllFilterOrdersStatus ==
                      GetAllFilterOrdersStatus.loading,
                  isFailure:
                      state.getAllFilterOrdersStatus ==
                      GetAllFilterOrdersStatus.failure,
                  isEmpty:
                      state.getAllFilterOrdersStatus ==
                          GetAllFilterOrdersStatus.success &&
                      state.orders.isEmpty,
                  errorMessage: state.errorMessage,
                  emptyText: LK.ordersNoOrders.tr(),
                  onRetry: _load,
                  child: RefreshIndicator(
                    onRefresh: () async => _load(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(width(16)),
                      itemCount: state.orders.length,
                      separatorBuilder: (_, __) => SizedBox(height: height(10)),
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          // A super admin can do everything a store owner
                          // can, so the same detail screen is reused rather
                          // than duplicated - it only needs an order id.
                          onTap: () => context.pushPage(
                            AdminOrderDetailPage(
                              orderId: order.id,
                              orderStatus: order.status,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(width(14)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD3D3E4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${LK.ordersOrderNumber.tr()}${order.id}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    const Spacer(),
                                    AdminStatusBadge(status: order.status),
                                  ],
                                ),
                                if ((order.storeName ?? '').isNotEmpty) ...[
                                  SizedBox(height: height(6)),
                                  Text(
                                    order.storeName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                                if ((order.customerFullName ?? '')
                                    .isNotEmpty) ...[
                                  SizedBox(height: height(4)),
                                  Text(
                                    order.customerFullName!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
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
                                    SizedBox(width: width(4)),
                                    const Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
