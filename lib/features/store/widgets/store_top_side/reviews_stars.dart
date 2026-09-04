import 'package:flutter/material.dart';

class ReviewsStars extends StatelessWidget {
  final double? rating;
  const ReviewsStars({super.key, this.rating});

  @override
  Widget build(BuildContext context) {
    final displayRating = rating ?? 0;
    return Row(
      children: List.generate(5, (index) {
        IconData iconData;
        if (index + 1 <= displayRating) {
          // نجمة كاملة
          iconData = Icons.star;
        } else if (index < displayRating && index + 1 > displayRating) {
          // نصف نجمة
          iconData = Icons.star_half;
        } else {
          iconData = Icons.star_border;
        }
        return Padding(
          padding: EdgeInsets.only(right: index == 0 ? 0 : 2.0),
          child: Icon(iconData, color: Colors.amber, size: 12),
        );
      }),
    );
  }
}
