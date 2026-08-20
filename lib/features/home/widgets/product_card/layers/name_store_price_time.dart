import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/product/product_ref.dart';
import '../../../../shop/widgets/price_tag.dart';

/// Text block overlaid on the product card: name, description, store name and
/// price. Same layout as before - only the model behind it changed.
class NameStorePriceTime extends StatelessWidget {
  final ProductRef product;

  const NameStorePriceTime({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Positioned(
      top: height(62),
      child: Padding(
        padding: EdgeInsets.only(right: width(10), left: width(10)),
        child: Column(
          spacing: height(5),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width(150),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if ((product.description ?? '').isNotEmpty)
              SizedBox(
                width: width(150),
                child: Text(
                  product.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if ((product.storeName ?? '').isNotEmpty)
              SizedBox(
                width: width(150),
                child: Text(
                  product.storeName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            PriceTag(
              price: product.price,
              priceAfterDiscount: product.priceAfterDiscount,
              hasDiscount: product.hasDiscount,
              color: onPrimary,
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}
