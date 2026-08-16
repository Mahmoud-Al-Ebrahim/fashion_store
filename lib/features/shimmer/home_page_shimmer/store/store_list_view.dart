import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import 'store_shimmer_widget.dart';

class StoreShimmerListView extends StatelessWidget {
  const StoreShimmerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(180),
      child: ListView.builder(
        clipBehavior: Clip.none,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (builder, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: StoreShimmerWidget(),
          );
        },
      ),
    );
  }
}
