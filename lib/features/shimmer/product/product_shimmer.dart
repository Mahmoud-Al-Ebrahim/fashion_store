import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/screen_util.dart';
import '../one_item_shimmer.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[350]!,
          highlightColor: Colors.grey[200]!,
          period: const Duration(milliseconds: 1500),
          child: OneItemShimmer(
            itemHeight: 400,
            itemWidth: double.infinity,
            radius: 50,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[350]!,
          highlightColor: Colors.grey[200]!,
          period: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OneItemShimmer(itemHeight: 30, itemWidth: 150, radius: 50),
                SizedBox(height: height(30)),
                OneItemShimmer(itemHeight: 15, itemWidth: 330, radius: 50),
                SizedBox(height: height(5)),
                OneItemShimmer(itemHeight: 15, itemWidth: 330, radius: 50),
                SizedBox(height: height(5)),
                OneItemShimmer(itemHeight: 15, itemWidth: 330, radius: 50),
                SizedBox(height: height(5)),
                OneItemShimmer(itemHeight: 15, itemWidth: 330, radius: 50),
                SizedBox(height: height(5)),
                OneItemShimmer(itemHeight: 15, itemWidth: 330, radius: 50),
                SizedBox(height: height(5)),
                OneItemShimmer(itemHeight: 15, itemWidth: 330, radius: 50),
                SizedBox(height: height(30)),
                OneItemShimmer(
                  itemHeight: 50,
                  itemWidth: 330,
                  radius: 20,
                  borderWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        OneItemShimmer(
                          itemHeight: 20,
                          itemWidth: 20,
                          radius: 20,
                        ),
                        SizedBox(width: width(5)),
                        OneItemShimmer(
                          itemHeight: 15,
                          itemWidth: 55,
                          radius: 20,
                        ),
                        SizedBox(width: width(20)),
                        OneItemShimmer(
                          itemHeight: 20,
                          itemWidth: 20,
                          radius: 20,
                        ),
                        SizedBox(width: width(5)),
                        OneItemShimmer(
                          itemHeight: 15,
                          itemWidth: 55,
                          radius: 20,
                        ),
                        SizedBox(width: width(20)),

                        OneItemShimmer(
                          itemHeight: 20,
                          itemWidth: 20,
                          radius: 20,
                        ),
                        SizedBox(width: width(5)),
                        OneItemShimmer(
                          itemHeight: 15,
                          itemWidth: 55,
                          radius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height(30),),
                OneItemShimmer(itemHeight: 150, itemWidth: double.infinity, radius: 10,
                  borderWidth: 2,
                  child: Column(
                  children: [
                    SizedBox(height: height(30),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          OneItemShimmer(itemHeight: 20, itemWidth: 20,radius: 20,),
                          SizedBox(width: width(5),),
                          OneItemShimmer(itemHeight: 15, itemWidth: 55,radius: 20,),
                          SizedBox(width: width(5),),
                          OneItemShimmer(itemHeight: 20, itemWidth: 20,radius: 20,),
                          SizedBox(width: width(5),),
                          Spacer(),
                          OneItemShimmer(itemHeight: 15, itemWidth: 100,radius: 20,),
                        ],
                      ),
                    ),
                    SizedBox(height: height(30),),

                    OneItemShimmer(itemHeight: 30, itemWidth: 320, radius: 20,),
                  ],
                ),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
