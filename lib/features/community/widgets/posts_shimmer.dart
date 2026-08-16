import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../shimmer/one_item_shimmer.dart';

class PostsShimmer extends StatelessWidget {
  const PostsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (builder, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Divider(indent: 20, endIndent: 20, color: Color(0xffC9E3D1)),
      ),
      itemBuilder: (builder, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[350]!,
            highlightColor: Colors.grey[200]!,
            period: const Duration(milliseconds: 1500),
            child: OneItemShimmer(
              itemHeight: 300,
              itemWidth: 1.sw - 50,
              radius: 20,
            ),
          ),
        );
      },
    );
  }
}
