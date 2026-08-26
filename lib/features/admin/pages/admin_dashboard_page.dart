import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/admin_bloc/admin_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/screen_util.dart';
import '../../../core/constants/product_enums.dart';
import '../../../models/admin/admin_dashboard_model.dart';
import '../../shop/widgets/price_tag.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/date_range_bar.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/admin/product_dashboard_model.dart';
import 'admin_product_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/api_service.dart';
import '../../shop/pages/product_by_id_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late DateTime _fromDate;
  late DateTime _toDate;

  @override
  void initState() {
    super.initState();
    _toDate = DateTime.now();
    _fromDate = _toDate.subtract(const Duration(days: 30));
    context.read<AdminBloc>().add(GetDashboardSummaryEvent());
    context.read<AdminBloc>().add(
      GetDashboardAnalyticsEvent(fromDate: _fromDate, endDate: _toDate),
    );
    // Same window as the analytics cards: the per-variant breakdown behind
    // the headline numbers.
    context.read<AdminBloc>().add(
      GetOrdersDetailEvent(startDate: _fromDate, endDate: _toDate),
    );
    context.read<AdminBloc>().add(GetProductInventoryAlertEvent());
    // The alerts only carry a productId; the dashboard's product list is
    // what turns that into the model the detail screen needs.
    context.read<AdminBloc>().add(
      GetProductDashboardEvent(pageNumber: 1, pageSize: 100),
    );
  }

  void _refresh() {
    context.read<AdminBloc>().add(GetDashboardSummaryEvent());
    context.read<AdminBloc>().add(
      GetDashboardAnalyticsEvent(fromDate: _fromDate, endDate: _toDate),
    );
    // Same window as the analytics cards: the per-variant breakdown behind
    // the headline numbers.
    context.read<AdminBloc>().add(
      GetOrdersDetailEvent(startDate: _fromDate, endDate: _toDate),
    );
    context.read<AdminBloc>().add(GetProductInventoryAlertEvent());
    context.read<AdminBloc>().add(
      GetProductDashboardEvent(pageNumber: 1, pageSize: 100),
    );
  }

  /// Opens the product a low-stock alert refers to.
  ///
  /// The alert row is keyed by `productId`, while the detail screen wants
  /// the full dashboard model, so it is looked up in the list loaded above.
  /// If the product isn't in the current page the tap is a no-op rather than
  /// a crash.
  Future<void> _openAlertProduct(int productId) async {
    final products =
        context.read<AdminBloc>().state.productDashboard?.products ?? const [];
    ProductDashboardItemModel? match;
    for (final product in products) {
      if (product.id == productId) {
        match = product;
        break;
      }
    }
    if (match == null) {
      showMessage(LK.commonNoData.tr());
      return;
    }
    final changed = await context.pushPage<bool>(
      AdminProductDetailPage(product: match),
    );
    if (changed == true && mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            return Text(
              state.myStore?.storeName ?? LK.adminDashboard.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminSectionHeader(title: LK.adminOverview.tr()),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  final summary = state.dashboardSummary;
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: width(12),
                    crossAxisSpacing: width(12),
                    childAspectRatio: 1.5,
                    children: [
                      AdminStatCard(
                        label: LK.adminProductsCount.tr(),
                        value: '${summary?.productsCount ?? '-'}',
                        icon: Icons.inventory_2_outlined,
                      ),
                      AdminStatCard(
                        label: LK.adminFollowersCount.tr(),
                        value: '${summary?.followersCount ?? '-'}',
                        icon: Icons.people_outline,
                      ),
                      AdminStatCard(
                        label: LK.adminPostsCount.tr(),
                        value: '${summary?.postsCount ?? '-'}',
                        icon: Icons.dynamic_feed_outlined,
                      ),
                      AdminStatCard(
                        label: LK.adminReactionsCount.tr(),
                        value: '${summary?.totalReactions ?? '-'}',
                        icon: Icons.favorite_border,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: height(20)),
              AdminSectionHeader(title: LK.adminFinancial.tr()),
              DateRangeBar(
                startDate: _fromDate,
                endDate: _toDate,
                onStartChanged: (d) => setState(() => _fromDate = d),
                onEndChanged: (d) => setState(() => _toDate = d),
                onApply: () {
                  final bloc = context.read<AdminBloc>();
                  bloc.add(
                    GetDashboardAnalyticsEvent(
                      fromDate: _fromDate,
                      endDate: _toDate,
                    ),
                  );
                  bloc.add(
                    GetOrdersDetailEvent(
                      startDate: _fromDate,
                      endDate: _toDate,
                    ),
                  );
                },
              ),
              SizedBox(height: height(12)),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  final analytics = state.dashboardAnalytics;
                  return Row(
                    children: [
                      Expanded(
                        child: AdminStatCard(
                          label: LK.adminOrdersCount.tr(),
                          value: '${analytics?.ordersCount ?? '-'}',
                          icon: Icons.shopping_bag_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: width(10)),
                      Expanded(
                        child: AdminStatCard(
                          label: LK.adminTotalSales.tr(),
                          value: analytics == null
                              ? '-'
                              : analytics.totalSales.toStringAsFixed(0),
                          icon: Icons.payments_outlined,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: width(10)),
                      Expanded(
                        child: AdminStatCard(
                          label: LK.adminCustomersCount.tr(),
                          value: '${analytics?.customersCount ?? '-'}',
                          icon: Icons.person_outline,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: height(20)),
              // Per-variant detail behind the financial headline numbers,
              // filtered by the same date range as the cards above.
              AdminSectionHeader(title: LK.adminSalesBreakdown.tr()),
              BlocBuilder<AdminBloc, AdminState>(
                buildWhen: (p, c) =>
                    p.getOrdersDetailStatus != c.getOrdersDetailStatus ||
                    p.ordersDetail != c.ordersDetail,
                builder: (context, state) {
                  if (state.getOrdersDetailStatus ==
                      GetOrdersDetailStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.ordersDetail.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: height(10)),
                      child: Text(
                        LK.adminNoSalesInRange.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
                    );
                  }
                  return Column(
                    children: state.ordersDetail
                        .map((row) => _SalesBreakdownRow(row: row))
                        .toList(),
                  );
                },
              ),
              SizedBox(height: height(20)),
              AdminSectionHeader(title: LK.adminInventoryAlerts.tr()),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  if (state.getProductInventoryAlertStatus ==
                      GetProductInventoryAlertStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.inventoryAlerts.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: height(16)),
                      child: Text(
                        LK.adminNoInventoryAlerts.tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return Column(
                    children: state.inventoryAlerts.map((alert) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _openAlertProduct(alert.productId),
                        child: Container(
                          margin: EdgeInsets.only(bottom: height(8)),
                          padding: EdgeInsets.symmetric(
                            horizontal: width(12),
                            vertical: height(10),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      alert.colorHexCode.replaceFirst(
                                        '#',
                                        '0xff',
                                      ),
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black12),
                                ),
                              ),
                              SizedBox(width: width(10)),
                              Expanded(
                                child: Text(
                                  '${LK.adminProductNumber.tr()}${alert.productId} - ${localizedColorName(alert.color)} - ${sizeLabel(alert.size)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                '${LK.adminQuantityLabel.tr()}: ${alert.quantity}',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              SizedBox(width: width(4)),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Colors.orange.shade800,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: height(20)),
            ],
          ),
        ),
      ),
    );
  }
}

/// One (product, colour, size) line of the sales breakdown: how many units
/// moved in the selected window, what they earned, and what is left.
class _SalesBreakdownRow extends StatelessWidget {
  const _SalesBreakdownRow({required this.row});

  final AdminOrderDetailStatModel row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final out = row.remainingQuantity <= 0;
    final image = ApiService.resolveUrl(row.image) ?? '';
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => openProductById(context, row.productId),
      child: Container(
        margin: EdgeInsets.only(bottom: height(8)),
        padding: EdgeInsets.symmetric(
          horizontal: width(12),
          vertical: height(10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD3D3E4)),
        ),
        child: Row(
          children: [
            // The endpoint has no image yet; show the colour swatch until it
            // does, then the photo takes over with no further change here.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.isEmpty
                  ? Container(
                      width: width(40),
                      height: width(40),
                      alignment: Alignment.center,
                      color: Colors.grey.shade100,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: _hex(row.colorHexCode),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: image,
                      width: width(40),
                      height: width(40),
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: width(40),
                        height: width(40),
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 16,
                        ),
                      ),
                    ),
            ),
            SizedBox(width: width(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${LK.adminProductNumber.tr()}${row.productId} - '
                    '${localizedColorName(row.color)} - '
                    '${sizeLabel(row.size)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: height(2)),
                  Text(
                    '${LK.adminUnitsSold.tr()}: ${row.numberOfSales}   '
                    '${LK.adminRemaining.tr()}: ${row.remainingQuantity}',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: out ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${formatPrice(row.price)} ${LK.commonCurrency.tr()}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: width(4)),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  static Color _hex(String value) {
    var v = value.replaceAll('#', '').trim();
    if (v.length == 6) v = 'FF$v';
    return Color(int.tryParse(v, radix: 16) ?? 0xFF9E9E9E);
  }
}
