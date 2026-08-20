import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/widgets/async_view.dart';
import '../../../../../blocs/store_bloc/store_bloc.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/product/product_ref.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../home/widgets/product_card/product-card.dart';

/// "Products" tab - the store's catalog from `Store/GetAllProductsByStore`,
/// rendered with the shared product card.
class CategoriesTab extends StatelessWidget {
  final StoreModel store;

  const CategoriesTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      buildWhen: (p, c) =>
          p.getAllProductsByStoreStatus != c.getAllProductsByStoreStatus ||
          p.storeProducts != c.storeProducts,
      builder: (context, state) {
        return AsyncView(
          isLoading: state.getAllProductsByStoreStatus ==
              GetAllProductsByStoreStatus.loading,
          isFailure: state.getAllProductsByStoreStatus ==
              GetAllProductsByStoreStatus.failure,
          isEmpty: state.storeProducts.isEmpty,
          errorMessage: state.errorMessage,
          emptyText: LK.storeNoProducts.tr(),
          onRetry: () => context.read<StoreBloc>().add(
            GetAllProductsByStoreEvent(storeId: store.id),
          ),
          child: GridView.builder(
            padding: EdgeInsets.all(width(16)),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: state.storeProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                isWithDetail: true,
                product: ProductRef.fromStoreProduct(
                  state.storeProducts[index],
                  storeId: store.id,
                  storeName: store.storeName,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
