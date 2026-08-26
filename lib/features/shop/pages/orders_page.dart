import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../app/widgets/button.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/utils/session.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';
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
    // A guest has no orders to fetch, and the call would 401 anyway.
    if (!Session.isGuest) _load();
  }

  void _load() => context.read<OrderBloc>().add(GetAllOrdersEvent());

  @override
  Widget build(BuildContext context) {
    // Guests browse the catalogue freely, but orders belong to an account -
    // say so plainly instead of showing an empty list they cannot fill.
    if (Session.isGuest) return const _GuestOrdersView();

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
              isEmpty:
                  state.getAllOrdersStatus == GetAllOrdersStatus.success &&
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
                    onTap: () =>
                        context.pushPage(OrderDetailsPage(orderId: order.id)),
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
                                style: Theme.of(context).textTheme.bodySmall!
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

/// What the orders tab shows to a guest: why it is empty, and the way out.
class _GuestOrdersView extends StatelessWidget {
  const _GuestOrdersView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: width(64),
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              SizedBox(height: height(16)),
              Text(
                LK.ordersGuestTitle.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: height(8)),
              Text(
                LK.ordersGuestBody.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
              SizedBox(height: height(24)),
              AuthButton(
                text: LK.authLoginNow.tr(),
                widthButton: double.infinity,
                heightButton: height(50),
                onTap: () => HelperFunctions.navigateToPageAndPopAll(
                  context,
                  const SignInScreen(),
                  true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
