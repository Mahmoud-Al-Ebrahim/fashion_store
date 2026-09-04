import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/product/product_ref.dart';
import '../../../shop/widgets/price_tag.dart';
import 'one_item_more_detail.dart';

/// Grey info strip under the product name: rating (when known) + price.
///
/// The store used to be a chip in here. It moved to `ProductStoreBlock`
/// directly below, which shows the store's name *and* its description and
/// resolves both from the store list - so a product opened from the home
/// page names its seller too, which this chip never could.
class MoreDetailAboutProduct extends StatelessWidget {
  final ProductRef product;

  const MoreDetailAboutProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(57),
      decoration: BoxDecoration(
        color: const Color(0xFF666A7A).withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 0.05,
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(20)),
        child: Row(
          children: [
            if (product.rating != null && product.rating! > 0) ...[
              OneItemMoreDetail(
                icon: "assets/svg/Coins.svg",
                title:
                    '${LK.productRating.tr()} ${product.rating!.toStringAsFixed(1)}',
              ),
              SizedBox(width: width(24)),
            ],
            PriceTag(
              price: product.price,
              priceAfterDiscount: product.priceAfterDiscount,
              hasDiscount: product.hasDiscount,
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}
