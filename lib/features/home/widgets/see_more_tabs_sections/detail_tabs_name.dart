import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';

class SeeMoreTabBarsName extends StatelessWidget {
  const SeeMoreTabBarsName({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: onTap,
      dividerColor: Colors.transparent,
      indicatorColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: const Color(0xff666A7A),
      tabs: [
        Tab(text: LK.storeProducts.tr()),
        Tab(text: LK.homeTitle.tr()),
      ],
    );
  }
}
