import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/store/store_products_model.dart';
import '../product_time.dart';

class NameStorePriceTime extends StatelessWidget {
  final Product product;
  const NameStorePriceTime({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height(62),
      child: Padding(
        padding: EdgeInsets.only(right: width(10)),
        child: Column(
          spacing: height(5),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name??"_____",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: width(150),
              child: Text(
               product.description??"_____",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              product.store?.name??"_____",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              " \$ ${product.price??0}",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          // ProductTime(product: product,)
          ],
        ),
      ),
    );
  }
}
