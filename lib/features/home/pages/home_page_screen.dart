import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../models/product/product_ref.dart';
import '../../nav_bar/user_nav_bar/user_nav_bar_bloc.dart';
import '../widgets/product_card/store_card_list_view.dart';
import '../widgets/store_card/store_list_view.dart';
import '../widgets/title_and_see_more.dart';

/// Customer home. Sections are driven by real endpoints:
///  - discounted products  -> `Product/GetAllDiscountProduct`
///  - recommended stores   -> `Store/GetAllStores`
///  - followed stores feed -> `StoreFollower/GetProductsByFollowerStores`
///
/// The old "nearest stores to you" section was removed along with location
/// support, and the ad banner that used to head the page was dropped too -
/// both per the dropped-features decision. The widgets themselves are kept
/// in the tree in case they come back.
class HomePageScreen extends StatefulWidget {
  static String name = "home-screen";
  static String path = "/home-screen";

  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<ProductBloc>().add(GetAllDiscountProductEvent());
    context.read<StoreBloc>().add(GetAllStoresEvent());
    context.read<StoreFollowerBloc>().add(GetProductsByFollowerStoresEvent());
  }

  void _goToExplore() =>
      context.read<NavBarBloc>().add(ChangeNavBar(index: 2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: Padding(
          padding: EdgeInsets.only(right: width(20)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: height(22),
              children: [
                // ----- discounted products -----
                TitleAndSeeMore(
                      onSeeMore: _goToExplore,
                      title: LK.homeDiscounted.tr(),
                    )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(-1, 0), duration: 500.ms),

                BlocBuilder<ProductBloc, ProductState>(
                  buildWhen: (p, c) =>
                      p.getAllDiscountProductStatus !=
                          c.getAllDiscountProductStatus ||
                      p.discountedProducts != c.discountedProducts,
                  builder: (context, state) {
                    return SizedBox(
                      height: height(200),
                      child: AsyncView(
                        isLoading: state.getAllDiscountProductStatus ==
                            GetAllDiscountProductStatus.loading,
                        isFailure: state.getAllDiscountProductStatus ==
                            GetAllDiscountProductStatus.failure,
                        isEmpty: state.discountedProducts.isEmpty,
                        errorMessage: state.errorMessage,
                        emptyText: LK.commonNoData.tr(),
                        emptyImageHeight: height(90),
                        onRetry: _load,
                        child: ProductCardListView(
                          favouriteProducts: state.discountedProducts
                              .map(ProductRef.fromCatalog)
                              .toList(),
                          isHomePage: true,
                        ),
                      ),
                    );
                  },
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                // ----- stores -----
                TitleAndSeeMore(
                      onSeeMore: _goToExplore,
                      title: LK.homeRecommendedStores.tr(),
                    )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(-1, 0), duration: 500.ms),

                BlocBuilder<StoreBloc, StoreState>(
                  buildWhen: (p, c) =>
                      p.getAllStoresStatus != c.getAllStoresStatus ||
                      p.stores != c.stores,
                  builder: (context, state) {
                    return SizedBox(
                      height: height(200),
                      child: AsyncView(
                        isLoading: state.getAllStoresStatus ==
                            GetAllStoresStatus.loading,
                        isFailure: state.getAllStoresStatus ==
                            GetAllStoresStatus.failure,
                        isEmpty: state.stores.isEmpty,
                        errorMessage: state.errorMessage,
                        emptyImageHeight: height(90),
                        onRetry: _load,
                        child: StoreListView(stores: state.stores),
                      ),
                    );
                  },
                )
                    .animate(delay: 800.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                // ----- products from stores the user follows -----
                BlocBuilder<StoreFollowerBloc, StoreFollowerState>(
                  buildWhen: (p, c) =>
                      p.followedStoresProducts != c.followedStoresProducts,
                  builder: (context, state) {
                    if (state.followedStoresProducts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      spacing: height(22),
                      children: [
                        TitleAndSeeMore(
                          onSeeMore: _goToExplore,
                          title: LK.homeFollowedProducts.tr(),
                        ),
                        ProductCardListView(
                          favouriteProducts: state.followedStoresProducts
                              .map(ProductRef.fromCatalog)
                              .toList(),
                          isHomePage: true,
                        ),
                      ],
                    );
                  },
                )
                    .animate(delay: 1000.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                SizedBox(height: height(25)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
