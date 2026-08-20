import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/product/product_ref.dart';
import '../../../shop/widgets/price_tag.dart';
import 'one_item_more_detail.dart';

/// Grey info strip under the product name: store name (when known) + price.
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
            if ((product.storeName ?? '').isNotEmpty) ...[
              Flexible(
                child: OneItemMoreDetail(
                  icon: "assets/svg/who_i_follow.svg",
                  title: product.storeName!,
                ),
              ),
              SizedBox(width: width(24)),
            ],
            if (product.rating != null && product.rating! > 0) ...[
              OneItemMoreDetail(
                icon: "assets/svg/Coins.svg",
                title: '${LK.productRating.tr()} ${product.rating!.toStringAsFixed(1)}',
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
