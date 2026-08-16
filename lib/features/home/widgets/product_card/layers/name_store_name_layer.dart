import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/store/store_products_model.dart';
class NameStoreNameLayer extends StatelessWidget {
  final Product favoriteProduct;
  const NameStoreNameLayer({super.key, required this.favoriteProduct});


  @override
  Widget build(BuildContext context) {
    return
      Positioned(
      top: 62,
      child: Padding(
        padding: EdgeInsets.only(right: width(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favoriteProduct.name??"_____",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              favoriteProduct.store?.name??"_____",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
