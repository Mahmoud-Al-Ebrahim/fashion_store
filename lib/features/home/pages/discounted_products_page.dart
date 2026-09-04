import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../models/product/product_ref.dart';
import '../widgets/product_card/product-card.dart';

/// Every discounted product, from `Product/GetAllDiscountProduct`.
///
/// Opened by "see more" on the home page's offers strip. It deliberately
/// does *not* reuse the Explore screen: that screen is search and filtering
/// over the whole catalog, so sending a shopper there dropped the discount
/// context they had just tapped and showed them full-price stock instead.
class DiscountedProductsPage extends StatefulWidget {
  const DiscountedProductsPage({super.key});

  @override
  State<DiscountedProductsPage> createState() => _DiscountedProductsPageState();
}

class _DiscountedProductsPageState extends State<DiscountedProductsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<ProductBloc>().add(GetAllDiscountProductEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.homeDiscountsTitle.tr()),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (p, c) =>
            p.getAllDiscountProductStatus != c.getAllDiscountProductStatus ||
            p.discountedProducts != c.discountedProducts,
        builder: (context, state) {
          final products = state.discountedProducts;
          return RefreshIndicator(
            onRefresh: () async => _load(),
            child: AsyncView(
              isLoading:
                  state.getAllDiscountProductStatus ==
                  GetAllDiscountProductStatus.loading,
              isFailure:
                  state.getAllDiscountProductStatus ==
                  GetAllDiscountProductStatus.failure,
              isEmpty:
                  state.getAllDiscountProductStatus ==
                      GetAllDiscountProductStatus.success &&
                  products.isEmpty,
              errorMessage: state.errorMessage,
              emptyText: LK.commonNoData.tr(),
              onRetry: _load,
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: width(12),
                  vertical: height(12),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(
                  isWithDetail: true,
                  product: ProductRef.fromCatalog(products[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
