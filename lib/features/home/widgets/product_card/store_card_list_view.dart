import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/product/product_ref.dart';
import 'product-card.dart';

/// Horizontal product carousel used by the home sections.
class ProductCardListView extends StatelessWidget {
  final List<ProductRef> favouriteProducts;

  /// Home carousels show the compact overlay; list/grid contexts show the
  /// fuller one with description and price.
  final bool isHomePage;

  const ProductCardListView({
    super.key,
    required this.favouriteProducts,
    required this.isHomePage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(200),
      child: ListView.builder(
        itemCount: favouriteProducts.length,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ProductCard(
              isWithDetail: !isHomePage,
              product: favouriteProducts[index],
            ),
          );
        },
      ),
    );
  }
}
