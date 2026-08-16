import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';
import '../../../core/screen_util.dart';
import '../../../models/store/store_products_model.dart';
import '../widgets/product/add_to_card_card.dart';
import '../widgets/product/column_layer.dart';
import '../widgets/product/fav_product_button.dart';
import '../widgets/product/product_image.dart';
import '../widgets/product/return_icon.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final Store store;
  static String name = "product-screen";
  static String path = "/product-screen";

  const ProductScreen({super.key, required this.product, required this.store});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // late HomeAndProductBloc homeAndProductBloc;

  bool isExpanded = false;

  @override
  void initState() {
    // homeAndProductBloc = getIt<HomeAndProductBloc>();
    // homeAndProductBloc.add(ProductEvent(productId: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ProductImage(imageUrl: widget.product.imageUrl!),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top:
            isExpanded
                ? height(150)
                : height(390),
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: ProductColumnLayer(
                product: widget.product,
                store: widget.store,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 0 : 1,
              curve: Curves.easeOut,
              child: AddToCardCard(
                productPrice: widget.product.price ?? 0,
                productId: widget.product.id ?? "",
              ),
            ),
          ),
          ReturnIcon(),
          FavProductButton(
            productId: widget.product.id ?? "",
            isLiked: false , //state.isLiked ?? false, productId: state.id??"",
          ),
        ],
      )

      // BlocSelector<
      //   HomeAndProductBloc,
      //   HomeAndProductState,
      //   BlocStateData<ProductModel>
      // >(
      //   selector: (state) => state.productState,
      //   builder: (context, state) {
      //     return BlocStateDataBuilder(
      //       data: state,
      //       onLoading: ProductShimmer(),
      //       onSuccess: (state) {
      //         return ;
      //       },
      //     );
      //   },
      // ),
    );
  }
}
