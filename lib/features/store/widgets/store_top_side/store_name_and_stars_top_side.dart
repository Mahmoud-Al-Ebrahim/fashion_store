import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';

/// Store name + follower count. The star row was dropped because the backend
/// has no store-level rating (ratings live on products).
class StoreNameAndStarsTopSide extends StatelessWidget {
  final String storeName;
  final int followingNumber;

  const StoreNameAndStarsTopSide({
    super.key,
    required this.storeName,
    required this.followingNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          storeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: height(4)),
        Text(
          '$followingNumber ${LK.storeFollowers.tr()}',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
