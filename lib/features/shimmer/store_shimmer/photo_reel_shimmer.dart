import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/screen_util.dart';
import '../home_page_shimmer/product/product_card.dart';
import '../one_item_shimmer.dart';

class PhotoReelShimmer extends StatelessWidget {
  const PhotoReelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[200]!,
      period: const Duration(milliseconds: 1500),
      child: SizedBox(
        height: height(550),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: 12, // عدد العناصر (غيره حسب حاجتك)
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // عدد الأعمدة
              crossAxisSpacing: 10, // المسافة الأفقية
              mainAxisSpacing: 10, // المسافة العمودية
              childAspectRatio: 0.6, // نسبة العرض إلى الارتفاع
            ),
            itemBuilder: (context, index) {
              return const OneItemShimmer(
                itemHeight: 200,
                itemWidth: 50,
                radius: 20,
              );
            },
          ),
        ),
      ),
    );
    ;
  }
}
