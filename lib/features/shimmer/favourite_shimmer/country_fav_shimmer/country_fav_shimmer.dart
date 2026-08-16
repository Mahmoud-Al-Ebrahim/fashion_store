import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/screen_util.dart';
import 'country_fav_card_shimmer.dart';

class CountryFavShimmer extends StatelessWidget {
  const CountryFavShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(660),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CountryFavCardShimmer(),
          );
        },
      ),
    );
    ;
  }
}
