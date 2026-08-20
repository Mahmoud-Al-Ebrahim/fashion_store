import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/product/product_ref.dart';

/// Compact overlay used on home carousels: product name + store name only.
class NameStoreNameLayer extends StatelessWidget {
  final ProductRef favoriteProduct;

  const NameStoreNameLayer({super.key, required this.favoriteProduct});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Positioned(
      top: 62,
      child: Padding(
        padding: EdgeInsets.only(right: width(10), left: width(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width(150),
              child: Text(
                favoriteProduct.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if ((favoriteProduct.storeName ?? '').isNotEmpty)
              SizedBox(
                width: width(150),
                child: Text(
                  favoriteProduct.storeName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
