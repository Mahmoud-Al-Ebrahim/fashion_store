import 'package:flutter/material.dart';

import '../../one_item_shimmer.dart';

class CountryFavCardShimmer extends StatelessWidget {
  const CountryFavCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: OneItemShimmer(
        itemHeight: 120,
        itemWidth: 380,
        borderWidth: 1.2,
        radius: 25,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OneItemShimmer(itemHeight: 40, itemWidth: 40, radius: 25),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OneItemShimmer(
                        itemHeight: 15,
                        itemWidth: 100,
                        radius: 25,
                      ),
                      SizedBox(height: 10),
                      Row(
                        spacing: 3,
                        children: [
                          OneItemShimmer(
                            itemHeight: 10,
                            itemWidth: 10,
                            radius: 25,
                          ),
                          OneItemShimmer(
                            itemHeight: 10,
                            itemWidth: 10,
                            radius: 25,
                          ),
                          OneItemShimmer(
                            itemHeight: 10,
                            itemWidth: 10,
                            radius: 25,
                          ),
                          OneItemShimmer(
                            itemHeight: 10,
                            itemWidth: 10,
                            radius: 25,
                          ),
                          OneItemShimmer(
                            itemHeight: 10,
                            itemWidth: 10,
                            radius: 25,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      OneItemShimmer(
                        itemHeight: 10,
                        itemWidth: 100,
                        radius: 25,
                      ),
                      SizedBox(height: 10),
                      OneItemShimmer(
                        itemHeight: 10,
                        itemWidth: 100,
                        radius: 25,
                      ),
                      SizedBox(height: 10),
                      OneItemShimmer(
                        itemHeight: 10,
                        itemWidth: 100,
                        radius: 25,
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  OneItemShimmer(itemHeight: 25, itemWidth: 25, radius: 25),
                  SizedBox(width: 10),

                  OneItemShimmer(itemHeight: 150, itemWidth: 100, radius: 25),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
