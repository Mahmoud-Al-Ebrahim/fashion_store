import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/admin_bloc/admin_bloc.dart';
import '../../blocs/category_bloc/category_bloc.dart';
import '../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../blocs/comment_bloc/comment_bloc.dart';
import '../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../blocs/order_bloc/order_bloc.dart';
import '../../blocs/post_bloc/post_bloc.dart';
import '../../blocs/product_bloc/product_bloc.dart';
import '../../blocs/rating_bloc/rating_bloc.dart';
import '../../blocs/store_bloc/store_bloc.dart';
import '../../blocs/wallet_bloc/wallet_bloc.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/admin_more_page.dart';
import 'pages/admin_orders_page.dart';
import 'pages/admin_posts_page.dart';
import 'pages/admin_products_page.dart';

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

  static const _items = [
    (icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'الرئيسية'),
    (icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, label: 'المنتجات'),
    (icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: 'الطلبات'),
    (icon: Icons.dynamic_feed_outlined, selectedIcon: Icons.dynamic_feed, label: 'المنشورات'),
    (icon: Icons.more_horiz, selectedIcon: Icons.more_horiz, label: 'المزيد'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StoreBloc()..add(GetStoreByAdminEvent())),
        BlocProvider(create: (_) => AdminBloc()),
        BlocProvider(create: (_) => ProductBloc()),
        BlocProvider(create: (_) => ClothingItemBloc()),
        BlocProvider(create: (_) => OrderBloc()),
        BlocProvider(create: (_) => PostBloc()),
        BlocProvider(create: (_) => ComplaintBloc()),
        BlocProvider(create: (_) => WalletBloc()),
        BlocProvider(create: (_) => CategoryBloc()),
        BlocProvider(create: (_) => CommentBloc()),
        BlocProvider(create: (_) => RatingBloc()),
      ],
      child: Scaffold(
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
      ),
    );
  }
}
