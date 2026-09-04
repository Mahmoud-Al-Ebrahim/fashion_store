import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/screen_util.dart';
import '../../../shop/pages/image_viewer_page.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  const ProductImage({super.key, required this.imageUrl});

  /// Shared with the full-screen viewer so the image flies into place.
  String get _heroTag => 'product-image-$imageUrl';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          // Opens full screen with pinch-to-zoom: the fabric and stitching
          // detail that decides a clothing purchase is invisible at this
          // size.
          onTap: imageUrl.isEmpty
              ? null
              : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ImageViewerPage(imageUrl: imageUrl, heroTag: _heroTag),
                  ),
                ),
          child: Hero(
            tag: _heroTag,
            child: SizedBox(
              width: double.infinity,
              height: height(500),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    height: height(500),
                    color: Colors.grey.shade300,
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: width(18),
                      bottom: height(20),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/error.png",
                        fit: BoxFit.cover,
                        width: width(250),
                        height: height(300),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Container(color: Theme.of(context).colorScheme.onPrimary),
      ],
    );
  }
}
