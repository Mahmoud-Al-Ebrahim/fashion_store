import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import 'product_card.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(190),
      child: ListView.builder(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (builder, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ProductCardShimmer(),
          );
        },
      ),
    );
  }
}
