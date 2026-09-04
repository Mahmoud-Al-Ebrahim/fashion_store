import 'package:flutter/material.dart';

import '../../../core/screen_util.dart';
import '../home_page_shimmer/product/product_card.dart';

class ProductsShimmer extends StatelessWidget {
  const ProductsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(660),
      child: GridView.builder(
        itemCount: 6, // عدد العناصر (غيره حسب حاجتك)
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 10, // المسافة الأفقية
          mainAxisSpacing: 10, // المسافة العمودية
          childAspectRatio: 1, // نسبة العرض إلى الارتفاع
        ),
        itemBuilder: (context, index) {
          return const ProductCardShimmer();
        },
      ),
    );
  }
}
