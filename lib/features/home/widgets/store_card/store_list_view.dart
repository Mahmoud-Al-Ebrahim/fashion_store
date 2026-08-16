import 'package:fashion_store/features/home/widgets/store_card/store_card.dart';
import 'package:fashion_store/models/dummy/stories_posts_fake_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';

class StoreListView extends StatelessWidget {
  const StoreListView({super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(200),
      child: ListView.builder(
        clipBehavior: Clip.none,
        itemCount: storesInfo.length,
        physics: BouncingScrollPhysics(),
          scrollDirection:  Axis.horizontal,
          itemBuilder: (context,index){
        return Padding(
          padding:  EdgeInsets.only(left: index==10?0:15,right: index==0?8:0),
          child: StoreCard(recommendedStore: storesInfo[index],),
        );
      }),
    );
  }
}
