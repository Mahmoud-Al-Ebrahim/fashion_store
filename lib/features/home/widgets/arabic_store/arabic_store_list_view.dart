import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/dummy/stories_posts_fake_data.dart';
import 'arabic_store_card.dart';

class ArabicStoreListView extends StatelessWidget {
  const ArabicStoreListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(120),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storesInfo.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: width(index == 9 ? 0 : 10)),
            child: ArabicStoreCard(arabicStore: storesInfo[index]),
          );
        },
      ),
    );
  }
}
