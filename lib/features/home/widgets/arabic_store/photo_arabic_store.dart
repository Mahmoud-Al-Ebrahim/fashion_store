import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/screen_util.dart';
class PhotoArabicStore extends StatelessWidget {
  final String imageUrl;

  const PhotoArabicStore({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = true; //imageUrl.startsWith('http');

    if (isNetworkImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width(113),
          height: height(83),
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: width(113),
              height: height(83),
              color: Colors.grey.shade300,
            ),
          ),
          errorWidget: (context, url, error) {
        //    print('❌ Error loading image: $error');
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Image.asset(
                "assets/images/error.png", // 🔹 fallback image
                fit: BoxFit.cover,
                width: width(113),
                height: height(83),
              ),
            );
          },
        ),
      );
    }
    //
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     border: Border.all(
    //       color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
    //     ),
    //   ),
    //   child: Image.asset(
    //     imageUrl.isNotEmpty ? imageUrl : Assets.pngLogo2,
    //     fit: BoxFit.cover,
    //     width: width(113),
    //     height: height(83),
    //   ),
    // );
  }
}
