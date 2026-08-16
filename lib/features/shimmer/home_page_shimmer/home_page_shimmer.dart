import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';
import 'arabic_store/store_list_view.dart';
import 'product/product_list_view.dart';
import 'header_shimmer.dart';
import 'store/store_list_view.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[200]!,
      period: const Duration(milliseconds: 1500),
      child: SingleChildScrollView(
        child: Column(
          spacing: height(20),
          children: [
            OneItemShimmer(itemHeight: 120, itemWidth: 300, radius: 34),
            HeaderShimmer(),
            ProductListView(),
            HeaderShimmer(),
            ArabicStoreListView(),
            HeaderShimmer(),
            StoreShimmerListView()

          ],
        ),
      ),
    );
  }
}
