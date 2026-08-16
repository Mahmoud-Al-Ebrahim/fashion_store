import 'package:fashion_store/features/store/widgets/store_top_side/reviews_stars.dart';
import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';

class StoreNameAndStarsTopSide extends StatelessWidget {
  final String storeName;
  final int followingNumber;
  final bool isFollowing ;
  final double rating;
  const StoreNameAndStarsTopSide({super.key, required this.storeName, required this.followingNumber, required this.isFollowing, required this.rating, });

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              storeName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(width: width(6)),
            Text(
              "( $followingNumber منابع)",
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        SizedBox(height: height(6)),
        ReviewsStars(rating: rating,)

      ],
    )
    ;
  }
}
