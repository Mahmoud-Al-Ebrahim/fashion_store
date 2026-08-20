import 'package:fashion_store/features/home/widgets/store_card/store_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import '../../../../models/store/store_model.dart';

/// Horizontal carousel of stores.
class StoreListView extends StatelessWidget {
  final List<StoreModel> stores;

  const StoreListView({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(200),
      child: ListView.builder(
        clipBehavior: Clip.none,
        itemCount: stores.length,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == stores.length - 1 ? 0 : 15,
              right: index == 0 ? 8 : 0,
            ),
            child: StoreCard(recommendedStore: stores[index]),
          );
        },
      ),
    );
  }
}
