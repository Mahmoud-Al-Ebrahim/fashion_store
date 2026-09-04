import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';

class ChooseProductKindShimmer extends StatelessWidget {
  const ChooseProductKindShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(550),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عنصرين بكل سطر
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95, // تتحكم بالشكل الطولي
          ),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[350]!,
              highlightColor: Colors.grey[200]!,
              period: const Duration(milliseconds: 1500),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OneItemShimmer(
                        itemHeight: 72,
                        itemWidth: 72,
                        radius: 100, // صورة دائرية
                      ),
                      const SizedBox(height: 12),
                      OneItemShimmer(itemHeight: 15, itemWidth: 100, radius: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
