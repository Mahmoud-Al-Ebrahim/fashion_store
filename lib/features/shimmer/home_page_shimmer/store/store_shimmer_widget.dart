import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/screen_util.dart';
import '../../one_item_shimmer.dart';

class StoreShimmerWidget extends StatelessWidget {
  const StoreShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[350]!,
          highlightColor: Colors.grey[200]!,
          period: const Duration(milliseconds: 1500),
          child: OneItemShimmer(
            itemHeight: 190,
            itemWidth: 170,
            borderWidth: 2,
            radius: 32,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: OneItemShimmer(
                      itemHeight: 30,
                      itemWidth: 30,
                      borderWidth: 2,
                      radius: 32,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OneItemShimmer(
                          itemHeight: 20,
                          itemWidth: 20,
                          radius: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height(30)),
                  OneItemShimmer(itemHeight: 12, itemWidth: 100, radius: 20),
                  SizedBox(height: height(10)),

                  Row(
                    children: [
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      SizedBox(width: width(3)),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      SizedBox(width: width(3)),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      SizedBox(width: width(3)),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      SizedBox(width: width(3)),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),

                    ],
                  ),
                  SizedBox(height: height(10)),
                  OneItemShimmer(itemHeight: 12, itemWidth: 140, radius: 20),
                  SizedBox(height: height(10)),
                  OneItemShimmer(itemHeight: 12, itemWidth: 140, radius: 20),
                  SizedBox(height: height(10)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: 0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[350]!,
            highlightColor: Colors.grey[200]!,
            period: const Duration(milliseconds: 1500),
            child: OneItemShimmer(
              itemHeight: 50,
              itemWidth: 50,
              radius: 32,
              borderWidth: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OneItemShimmer(
                  itemHeight: 20,
                  itemWidth: 20,
                  radius: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
