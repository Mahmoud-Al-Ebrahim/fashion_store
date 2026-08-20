import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../models/product/product_ref.dart';
import '../../pages/product_screen.dart';
import '../../../shop/widgets/price_tag.dart';
import 'layers/image_layer.dart';
import 'layers/name_store_name_layer.dart';
import 'layers/name_store_price_time.dart';

/// Product tile - the original layered design (rounded-34 image with a
/// gradient scrim, text block overlaid) now driven by the real API product.
///
/// The old Save / Add / Delete overlay layers were removed: the backend has no
/// favourites endpoint, and adding to the cart needs a `productSizeId` that
/// only exists once a colour + size are chosen on the details page.
class ProductCard extends StatelessWidget {
  final bool isWithDetail;
  final ProductRef product;

  const ProductCard({
    super.key,
    required this.product,
    this.isWithDetail = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => context.pushPage(ProductScreen(product: product)),
        child: Container(
          height: height(190),
          width: width(170),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(34)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ImageLayer(
                imageUrl: ApiService.resolveUrl(product.imageUrl) ?? '',
              ),
              if (product.hasDiscount)
                PositionedDirectional(
                  top: height(10),
                  end: width(10),
                  child: DiscountBadge(
                    percentage: product.discountPercentage!,
                  ),
                ),
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
