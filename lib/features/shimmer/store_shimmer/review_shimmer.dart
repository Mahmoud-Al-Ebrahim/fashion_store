import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';

class ReviewShimmer extends StatelessWidget {
  const ReviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(700),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemBuilder: (builder, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[350]!,
                highlightColor: Colors.grey[200]!,
                period: const Duration(milliseconds: 1500),
                child: Column(
                  children: [
                    Row(
                      children: [
                        OneItemShimmer(
                          itemHeight: 55,
                          itemWidth: 55,
                          radius: 32,
                          borderWidth: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OneItemShimmer(
                              itemHeight: 20,
                              itemWidth: 20,
                              radius: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: width(10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 60,
                                  radius: 20,
                                ),
                                SizedBox(width: width(10)),
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 40,
                                  radius: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: height(10)),
                            Row(
                              children: [
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 15,
                                  radius: 20,
                                ),
                                SizedBox(width: width(3)),
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 15,
                                  radius: 20,
                                ),
                                SizedBox(width: width(3)),
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 15,
                                  radius: 20,
                                ),
                                SizedBox(width: width(3)),
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 15,
                                  radius: 20,
                                ),
                                SizedBox(width: width(3)),
                                OneItemShimmer(
                                  itemHeight: 15,
                                  itemWidth: 15,
                                  radius: 20,
                                ),
                                SizedBox(width: width(3)),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        OneItemShimmer(
                          itemHeight: 30,
                          itemWidth: 80,
                          radius: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: height(20)),
                    OneItemShimmer(itemHeight: 12, itemWidth: 340, radius: 20),
                    SizedBox(height: height(4)),
                    OneItemShimmer(itemHeight: 12, itemWidth: 340, radius: 20),
                    SizedBox(height: height(4)),
                    OneItemShimmer(itemHeight: 12, itemWidth: 340, radius: 20),
                    SizedBox(height: height(4)),
                    OneItemShimmer(itemHeight: 12, itemWidth: 340, radius: 20),
                    SizedBox(height: height(15)),
                    OneItemShimmer(itemHeight: 100, itemWidth: 340, radius: 20),
                    SizedBox(height: height(15)),

                    OneItemShimmer(itemHeight: 1.5, itemWidth: 350),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
