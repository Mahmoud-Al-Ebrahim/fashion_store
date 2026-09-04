import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/screen_util.dart';

class ImageTopSide extends StatelessWidget {
  final double heightWidth;
  final String imageUrl; // بدل AssetImage نستخدم رابط الشبكة
  const ImageTopSide({
    super.key,
    required this.heightWidth,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(heightWidth),
      height: width(heightWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300], // ممكن تحط shimmer بدل اللون الرمادي
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
