import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/store/store_products_model.dart';
import 'product-card.dart';

class ProductCardListView extends StatelessWidget {
  final List<Product> favouriteProducts;

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
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 10),
            child: ProductCard(
              isWithDetail: false,
              product: favouriteProducts[index],
              isShowProductDetail: isHomePage,
            ),
          );
        },
      ),
    );
  }
}
