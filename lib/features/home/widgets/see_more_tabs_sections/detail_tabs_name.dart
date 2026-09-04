import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';

class SeeMoreTabBarsName extends StatelessWidget {
  const SeeMoreTabBarsName({super.key, required this.onTap, this.controller});

  final void Function(int index) onTap;

  /// Supplied by [SeeMoreBar] so the home page can open Explore straight
  /// onto the stores tab. Falls back to the ambient DefaultTabController
  /// when absent.
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
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
