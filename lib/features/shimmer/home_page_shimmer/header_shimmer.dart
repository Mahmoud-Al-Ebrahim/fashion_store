import 'package:flutter/material.dart';

import '../one_item_shimmer.dart';

class HeaderShimmer extends StatelessWidget {
  const HeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OneItemShimmer(itemHeight: 15, itemWidth: 120, radius: 20),
        Spacer(),
        OneItemShimmer(itemHeight: 15, itemWidth: 60, radius: 20),
      ],
    );
  }
}
