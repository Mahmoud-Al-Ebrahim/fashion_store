import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/screen_util.dart';

class StoreCardFounderPhoto extends StatelessWidget {
  final String imageUrl;
  const StoreCardFounderPhoto({super.key, required this.imageUrl});



  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height(-10),
      right: width(-6),
      child: Container(
        width: width(55),
        height: width(55),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
