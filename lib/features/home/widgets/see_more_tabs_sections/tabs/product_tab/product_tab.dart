import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/widgets/async_view.dart';
import '../../../../../../blocs/product_bloc/product_bloc.dart';
import '../../../../../../core/localization/translation_keys.dart';
import '../../../../../../core/screen_util.dart';
import '../../../../../../models/product/product_ref.dart';
import '../../../product_card/product-card.dart';

/// Explore > products. Shows search results when a query is active,
/// otherwise the (optionally filtered) catalog.
class ProductsTab extends StatelessWidget {
  final bool hasQuery;
  final VoidCallback onRetry;

  const ProductsTab({super.key, required this.hasQuery, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final results = hasQuery ? state.searchResults : state.filterResults;
        final status = hasQuery
            ? state.searchProductsStatus.index
            : state.filterProductsStatus.index;
        // Both enums share the init/loading/failure/success ordering.
        final isLoading = status == 1;
        final isFailure = status == 2;
        final isSuccess = status == 3;

        return AsyncView(
          isLoading: isLoading,
          isFailure: isFailure,
          isEmpty: isSuccess && results.isEmpty,
          errorMessage: state.errorMessage,
          emptyText: LK.exploreNoResults.tr(),
          onRetry: onRetry,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: width(8),
              vertical: height(8),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) => ProductCard(
              isWithDetail: true,
              product: ProductRef.fromCatalog(results[index]),
            ),
          ),
        );
      },
    );
  }
}
