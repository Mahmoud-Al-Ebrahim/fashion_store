import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';

class TabBarsName extends StatelessWidget {
  const TabBarsName({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: const Color(0xff666A7A),
      physics: const NeverScrollableScrollPhysics(),
      tabs: [
        Tab(text: LK.storeAbout.tr()),
        Tab(text: LK.storeProducts.tr()),
        Tab(text: LK.storePosts.tr()),
      ],
    );
  }
}
