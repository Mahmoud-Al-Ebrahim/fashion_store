import 'package:easy_localization/easy_localization.dart';
import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:fashion_store/features/nav_bar/user_nav_bar/user_nav_bar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../blocs/cart_bloc/cart_bloc.dart';
import '../../../blocs/category_bloc/category_bloc.dart';
import '../../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../../blocs/comment_bloc/comment_bloc.dart';
import '../../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../blocs/rating_bloc/rating_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../blocs/user_bloc/user_bloc.dart';
import '../../../blocs/wallet_bloc/wallet_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../community/pages/community_page.dart';
import '../../home/pages/home_page_screen.dart';
import '../../home/pages/see_more_bar.dart';
import '../../home/widgets/drawer/drawer.dart';
import '../../shop/pages/cart_page.dart';
import '../../shop/pages/orders_page.dart';

/// Customer shell. Provides every bloc the shopping flow needs, then swaps
/// between Home / Community / Explore / Orders with the original custom
/// bottom bar. The cart lives in the app bar and the profile in the drawer.
class UserNavBar extends StatefulWidget {
  static String name = "UserNavBar";
  static String path = "/UserNavBar";

  const UserNavBar({super.key});

  @override
  State<UserNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavBarBloc()),
        BlocProvider(create: (_) => UserBloc()..add(GetUserProfileEvent())),
        BlocProvider(create: (_) => StoreBloc()),
        BlocProvider(create: (_) => ProductBloc()),
        BlocProvider(create: (_) => ClothingItemBloc()),
        BlocProvider(create: (_) => StoreFollowerBloc()),
        BlocProvider(create: (_) => CartBloc()..add(GetCartItemsEvent())),
        BlocProvider(create: (_) => OrderBloc()),
        BlocProvider(create: (_) => PostBloc()),
        BlocProvider(create: (_) => CommentBloc()),
        BlocProvider(create: (_) => RatingBloc()),
        BlocProvider(create: (_) => CategoryBloc()),
        BlocProvider(create: (_) => ComplaintBloc()),
        BlocProvider(create: (_) => WalletBloc()),
        BlocProvider(create: (_) => StoreRequestBloc()),
      ],
      child: const _UserNavBarView(),
    );
  }
}

class _UserNavBarView extends StatelessWidget {
  const _UserNavBarView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorSelected = theme.colorScheme.primary;
        const colorUnselected = Colors.grey;

        final items = <_NavItemData>[
          _NavItemData("assets/svg/home.svg", LK.navHome.tr()),
          _NavItemData("assets/svg/community.svg", LK.navCommunity.tr()),
          _NavItemData("assets/svg/Search.svg", LK.navExplore.tr()),
          _NavItemData("assets/svg/bag.svg", LK.navOrders.tr()),
        ];

        const screens = [
          HomePageScreen(),
          CommunityPage(),
          SeeMoreBar(),
          OrdersPage(),
        ];

        return Scaffold(
          backgroundColor: theme.colorScheme.onPrimary,
          drawer: const CustomDrawer(),
          appBar: AppBar(
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              items[state.currentIndex].label,
              style: theme.textTheme.bodyMedium,
            ),
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: SvgPicture.asset(
                  "assets/svg/drawer.svg",
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            actions: [
              // Cart with a live item-count badge.
              BlocBuilder<CartBloc, CartState>(
                buildWhen: (p, c) => p.cart != c.cart,
                builder: (context, cartState) {
                  final count = cartState.cart?.items.length ?? 0;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () => context.pushPage(const CartPage()),
                      child: Badge(
                        isLabelVisible: count > 0,
                        label: Text('$count'),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(index: state.currentIndex, children: screens),
          bottomNavigationBar: Container(
            color: theme.colorScheme.onPrimary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == state.currentIndex;

                return GestureDetector(
                  onTap: () =>
                      context.read<NavBarBloc>().add(ChangeNavBar(index: index)),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 45,
                        height: 2,
                        decoration: BoxDecoration(
                          color:
                              isSelected ? colorSelected : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: height(6)),
                      SvgPicture.asset(
                        item.svgPath,
                        width: width(24),
                        height: height(24),
                        colorFilter: ColorFilter.mode(
                          isSelected ? colorSelected : colorUnselected,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: height(6)),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'El Messiri',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? colorSelected : colorUnselected,
                        ),
                      ),
                      SizedBox(height: height(4)),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _NavItemData {
  final String svgPath;
  final String label;

  _NavItemData(this.svgPath, this.label);
}
