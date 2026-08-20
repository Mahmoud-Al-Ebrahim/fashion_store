import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/admin_bloc/admin_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/screen_util.dart';
import '../../../core/constants/product_enums.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/date_range_bar.dart';
import '../../../core/localization/translation_keys.dart';

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
    context.read<AdminBloc>().add(GetProductInventoryAlertEvent());
  }

  void _refresh() {
    context.read<AdminBloc>().add(GetDashboardSummaryEvent());
    context.read<AdminBloc>().add(
      GetDashboardAnalyticsEvent(fromDate: _fromDate, endDate: _toDate),
    );
    context.read<AdminBloc>().add(GetProductInventoryAlertEvent());
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
                onApply: () => context.read<AdminBloc>().add(
                  GetDashboardAnalyticsEvent(fromDate: _fromDate, endDate: _toDate),
                ),
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
                      return Container(
                        margin: EdgeInsets.only(bottom: height(8)),
                        padding: EdgeInsets.symmetric(
                          horizontal: width(12),
                          vertical: height(10),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.orange.withOpacity(0.25)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    alert.colorHexCode.replaceFirst('#', '0xff'),
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
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
