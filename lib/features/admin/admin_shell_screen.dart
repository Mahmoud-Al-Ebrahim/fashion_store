import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/store_bloc/store_bloc.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/admin_more_page.dart';
import 'pages/admin_orders_page.dart';
import 'pages/admin_posts_page.dart';
import 'pages/admin_products_page.dart';
import 'pages/store_pending_page.dart';
import '../../core/localization/translation_keys.dart';

/// Root shell for the store-owner ("Admin" role) dashboard. Provides every
/// bloc the admin screens need once, then switches between the five main
/// sections with a bottom navigation bar - mirrors `UserNavBar`'s
/// IndexedStack shell but with Material icons instead of the customer app's
/// SVG icon set.
class AdminShellScreen extends StatefulWidget {
  const AdminShellScreen({super.key});

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Blocs come from FashionApp; load the store this dashboard belongs to.
    context.read<StoreBloc>().add(GetStoreByAdminEvent());
  }

  /// Built per-frame so the labels follow the active locale.
  List<({IconData icon, IconData selectedIcon, String label})> get _items => [
        (
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          label: LK.adminDashboard.tr()
        ),
        (
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
          label: LK.adminProducts.tr()
        ),
        (
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
          label: LK.adminOrders.tr()
        ),
        (
          icon: Icons.dynamic_feed_outlined,
          selectedIcon: Icons.dynamic_feed,
          label: LK.adminPosts.tr()
        ),
        (
          icon: Icons.more_horiz,
          selectedIcon: Icons.more_horiz,
          label: LK.adminMore.tr()
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
        buildWhen: (p, c) =>
            p.getStoreByAdminStatus != c.getStoreByAdminStatus ||
            p.myStore != c.myStore,
        builder: (context, storeState) {
          // Gate the dashboard on an approved store: the role alone isn't
          // enough, the platform admin must have approved the request.
          final loading = storeState.getStoreByAdminStatus ==
                  GetStoreByAdminStatus.init ||
              storeState.getStoreByAdminStatus ==
                  GetStoreByAdminStatus.loading;
          if (loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final store = storeState.myStore;
          if (store == null || store.storeStatus != 'Approved') {
            return const StorePendingPage();
          }
          return _buildShell(context);
        },
    );
  }

  Widget _buildShell(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            AdminDashboardPage(),
            AdminProductsPage(),
            AdminOrdersPage(),
            AdminPostsPage(),
            AdminMorePage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: _items
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
    );
  }
}
