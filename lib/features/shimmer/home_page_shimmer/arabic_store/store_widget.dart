import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/screen_util.dart';
import '../../one_item_shimmer.dart';

class ArabicStoreShimmerWidget extends StatelessWidget {
  const ArabicStoreShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[200]!,
      period: const Duration(milliseconds: 1500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneItemShimmer(itemHeight: 84, itemWidth: 113, radius: 34),
          SizedBox(height: height(6),),
          Row(
            spacing: 10,
            children: [
              OneItemShimmer(itemHeight: 20, itemWidth: 20,radius: 50,),
              OneItemShimmer(itemHeight: 15, itemWidth: 60,radius: 20,),
            ],
          ),
        ],
      ),
    );
  }
}
