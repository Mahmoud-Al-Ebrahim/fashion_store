import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/screen_util.dart';

/// Circular store logo overlapping the top corner of a store card.
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
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          image: imageUrl.isEmpty
              ? null
              : DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
        ),
        child: imageUrl.isEmpty
            ? Icon(
                Icons.storefront,
                size: width(24),
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
    );
  }
}
