import 'package:flutter/material.dart';

import '../../../core/screen_util.dart';

class TitleAndSeeMore extends StatelessWidget {
  final String title;
  const TitleAndSeeMore({super.key, required this.onSeeMore, required this.title});

  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: width(20)),
      child: Row(
        children: [
          Text(
           title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onSeeMore,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "المزيد",

                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 30,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
