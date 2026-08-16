import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/screen_util.dart';
import '../../shimmer/one_item_shimmer.dart';

class StoriesShimmer extends StatelessWidget {
  const StoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(140),
      child: ListView.builder(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (builder, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[350]!,
              highlightColor: Colors.grey[200]!,
              period: const Duration(milliseconds: 1500),
              child: OneItemShimmer(itemHeight: 112, itemWidth: 100 , radius: 20,)),
          );
        },
      ),
    );
  }
}
