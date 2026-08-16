import 'package:flutter/material.dart';
import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';

class WhoIFollowCardShimmer extends StatelessWidget {
  const WhoIFollowCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OneItemShimmer(itemHeight: 40, itemWidth: 40, radius: 40),
              SizedBox(width: width(10)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height(7)),
                  OneItemShimmer(itemHeight: 14, itemWidth: 160, radius: 15),
                  SizedBox(height: height(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 4,
                    children: [
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                      OneItemShimmer(itemHeight: 12, itemWidth: 12, radius: 20),
                    ],
                  ),
                ],
              ),
              Spacer(),
              OneItemShimmer(itemHeight: 30, itemWidth: 80, radius: 15),
            ],
          ),
          SizedBox(height: height(10),),
          OneItemShimmer(itemHeight: 1.2, itemWidth: 350)
        ],
      ),
    );
  }
}
