import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';

class WhoAmIShimmer extends StatelessWidget {
  const WhoAmIShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[350]!,
            highlightColor: Colors.grey[200]!,
            period: const Duration(milliseconds: 1500),
            child: OneItemShimmer(
              itemHeight: 500,
              itemWidth: 400,
              borderWidth: 2,
              radius: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OneItemShimmer(
                    itemHeight: 160,
                    itemWidth: double.infinity,
                    radius: 20,
                  ),
                  SizedBox(height: height(30)),
                  OneItemShimmer(itemHeight: 15, itemWidth: 340, radius: 15),
                  SizedBox(height: height(6)),
                  OneItemShimmer(itemHeight: 15, itemWidth: 340, radius: 15),
                  SizedBox(height: height(6)),
                  OneItemShimmer(itemHeight: 15, itemWidth: 340, radius: 15),
                  SizedBox(height: height(6)),
                  OneItemShimmer(itemHeight: 15, itemWidth: 340, radius: 15),
                  SizedBox(height: height(6)),
                  OneItemShimmer(itemHeight: 15, itemWidth: 340, radius: 15),
                  SizedBox(height: height(30)),
                  OneItemShimmer(itemHeight: 1.5, itemWidth: 340, radius: 15),
                  SizedBox(height: height(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OneItemShimmer(itemHeight: 20, itemWidth: 20, radius: 20),
                      SizedBox(width: width(10)),
                      OneItemShimmer(
                        itemHeight: 12,
                        itemWidth: 100,
                        radius: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: height(20)),
                  OneItemShimmer(itemHeight: 1.5, itemWidth: 340, radius: 15),
                  SizedBox(height: height(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OneItemShimmer(itemHeight: 20, itemWidth: 20, radius: 20),
                      SizedBox(width: width(10)),
                      OneItemShimmer(
                        itemHeight: 12,
                        itemWidth: 100,
                        radius: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: height(20)),
                  OneItemShimmer(itemHeight: 1.5, itemWidth: 340, radius: 15),
                  SizedBox(height: height(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OneItemShimmer(itemHeight: 20, itemWidth: 20, radius: 20),
                      SizedBox(width: width(10)),
                      OneItemShimmer(
                        itemHeight: 12,
                        itemWidth: 100,
                        radius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -35,
            right: 150,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              period: const Duration(milliseconds: 1500),
              child: OneItemShimmer(
                itemHeight: 65,
                itemWidth: 65,
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
      ),
    );
    ;
  }
}
