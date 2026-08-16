import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import 'store_widget.dart';

class ArabicStoreListView extends StatelessWidget {
  const ArabicStoreListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(120),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (builder, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ArabicStoreShimmerWidget(),
          );
        },
      ),
    );
  }
}
