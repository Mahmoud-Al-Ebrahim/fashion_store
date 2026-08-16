import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/store/store_products_model.dart';
import '../../pages/product_screen.dart';
import 'layers/add_layer.dart';
import 'layers/delete_layer.dart';
import 'layers/image_layer.dart';
import 'layers/name_store_name_layer.dart';
import 'layers/name_store_price_time.dart';
import 'layers/save_layer.dart';

class ProductCard extends StatelessWidget {
  final bool isWithDetail;
  final Product product;
  final bool isShowProductDetail;

  const ProductCard({
    super.key,
    required this.isWithDetail,
    required this.product,
    required this.isShowProductDetail,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          context.pushPage(
            ProductScreen(product: product, store: product.store!),
          );
        },
        child: Container(
          height: height(190),
          width: width(170),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(34)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ImageLayer(imageUrl: product.imageUrl!),
              // BlocBuilder<StoreBloc, StoreState>(
              //   buildWhen: (p, c) => p.editProductState != c.editProductState,
              //   builder: (context, state) {
              //     return state.editProductState.isLoading
              //         ? Positioned(
              //             bottom: -8,
              //             left: -2,
              //             child: MinBaytyLoader(),
              //           )
              //         :
              AddLayer(
                productId: product.id ?? "",
                price: product.price ?? 0,
                isShowProductDetail: isShowProductDetail,
                isRest: false,
                product: product,
              ),
              DeleteLayer(id: product.id!),
              SaveLayer(id: product.id ?? "", isLiked: product.isLiked ?? false),
              isWithDetail
                  ? NameStorePriceTime(product: product)
                  : NameStoreNameLayer(favoriteProduct: product),
            ],
          ),
        ),
      ),
    );
  }
}
