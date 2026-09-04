import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/localization/translation_keys.dart';
import 'pages/global_categories_page.dart';
import 'pages/platform_orders_page.dart';
import 'pages/store_requests_page.dart';
import 'pages/super_admin_more_page.dart';
import 'pages/users_management_page.dart';

/// Platform administration shell (SuperAdmin role).
///
/// A super admin can do everything a store owner can *plus* approve/reject
/// store requests and manage users - the store-owner dashboard is reachable
/// from the "More" tab, while the four tabs here are the platform-only tools.
class SuperAdminShellScreen extends StatefulWidget {
  const SuperAdminShellScreen({super.key});

  @override
  State<SuperAdminShellScreen> createState() => _SuperAdminShellScreenState();
}

class _SuperAdminShellScreenState extends State<SuperAdminShellScreen> {
  int _currentIndex = 0;

  List<({IconData icon, IconData selectedIcon, String label})> get _items => [
    (
      icon: Icons.store_mall_directory_outlined,
      selectedIcon: Icons.store_mall_directory,
      label: LK.superadminRequests.tr(),
    ),
    (
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: LK.superadminUsers.tr(),
    ),
    (
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
      label: LK.superadminCatalog.tr(),
    ),
    (
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: LK.superadminPlatformOrders.tr(),
    ),
    (
      icon: Icons.more_horiz,
      selectedIcon: Icons.more_horiz,
      label: LK.adminMore.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          StoreRequestsPage(),
          UsersManagementPage(),
          GlobalCategoriesPage(),
          PlatformOrdersPage(),
          SuperAdminMorePage(),
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
