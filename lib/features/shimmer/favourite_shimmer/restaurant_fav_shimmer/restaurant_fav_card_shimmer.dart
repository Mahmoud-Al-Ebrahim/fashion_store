import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import '../../one_item_shimmer.dart';

class StoreFavCardShimmer extends StatelessWidget {
  const StoreFavCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return   OneItemShimmer(
      itemHeight: 185,
      itemWidth: 180,
      borderWidth: 2,
      radius: 30,
      child: Column(
        children: [
          OneItemShimmer(
            itemHeight: 100,
            itemWidth: double.infinity,
            radius: 28,
          ),
          SizedBox(height: height(10)),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                OneItemShimmer(
                  itemHeight: 20,
                  itemWidth: 20,
                  radius: 50,
                ),
                SizedBox(width: width(5)),
                OneItemShimmer(
                  itemHeight: 15,
                  itemWidth: 70,
                  radius: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: height(10)),
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: Row(
              children: [
                OneItemShimmer(
                  itemHeight: 15,
                  itemWidth: 50,
                  radius: 20,
                ),
                Spacer(),
                OneItemShimmer(
                  itemHeight: 25,
                  itemWidth: 25,
                  radius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
