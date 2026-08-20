import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/async_view.dart';
import '../../../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/product/product_ref.dart';
import '../../widgets/product_card/product-card.dart';

/// "Stores I follow". The API has no endpoint listing followed stores, only
/// `StoreFollower/GetProductsByFollowerStores`, so this shows the products
/// coming from those stores instead of the store list itself.
class WhoIFollowingScreen extends StatefulWidget {
  const WhoIFollowingScreen({super.key});

  @override
  State<WhoIFollowingScreen> createState() => _WhoIFollowingScreenState();
}

class _WhoIFollowingScreenState extends State<WhoIFollowingScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context
      .read<StoreFollowerBloc>()
      .add(GetProductsByFollowerStoresEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.profileFollowing.tr()),
      ),
      body: BlocBuilder<StoreFollowerBloc, StoreFollowerState>(
        builder: (context, state) {
          return AsyncView(
            isLoading: state.getProductsByFollowerStoresStatus ==
                GetProductsByFollowerStoresStatus.loading,
            isFailure: state.getProductsByFollowerStoresStatus ==
                GetProductsByFollowerStoresStatus.failure,
            isEmpty: state.followedStoresProducts.isEmpty,
            errorMessage: state.errorMessage,
            emptyText: LK.commonNoData.tr(),
            onRetry: _load,
            child: GridView.builder(
              padding: EdgeInsets.all(width(16)),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: state.followedStoresProducts.length,
              itemBuilder: (context, index) => ProductCard(
                isWithDetail: true,
                product: ProductRef.fromCatalog(
                  state.followedStoresProducts[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
