import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[200]!,
      period: const Duration(milliseconds: 1500),
      child: SizedBox(
        height: height(33),

        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (builder, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: OneItemShimmer(itemHeight: 30, itemWidth: 70, radius: 15),
            );
          },
        ),
      ),
    );
  }
}
