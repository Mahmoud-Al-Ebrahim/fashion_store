import 'package:fashion_store/features/shimmer/who_i_follow_shimmer/who_i_follow_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WhoIFollowShimmer extends StatelessWidget {
  const WhoIFollowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[200]!,
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (builder, index) {
          return WhoIFollowCardShimmer();
        },
      ),
    );
  }
}
