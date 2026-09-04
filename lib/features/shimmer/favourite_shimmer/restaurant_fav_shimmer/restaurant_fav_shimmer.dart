import 'package:fashion_store/features/shimmer/favourite_shimmer/restaurant_fav_shimmer/restaurant_fav_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/screen_util.dart';

class StoreFavShimmer extends StatelessWidget {
  const StoreFavShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(700),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12.14),
          child: GridView.builder(
            itemCount: 8, // عدد العناصر
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عدد الأعمدة
              crossAxisSpacing: 18, // المسافة الأفقية
              mainAxisSpacing: 10, // المسافة العمودية
              childAspectRatio: 0.9, // نسبة العرض إلى الارتفاع
            ),
            itemBuilder: (context, index) {
              // كل عنصر داخل Grid
              return StoreFavCardShimmer();
            },
          ),
        ),
      ),
    );
  }
}
