import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_store/features/store/widgets/tab_bar/posts_tab/photo_and_reels/show_all_photo_or_reel_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/screen_util.dart';

class PhotoAndReelsCard extends StatelessWidget {
  final String imageUrl;
  final String ? videoUrl;
  const PhotoAndReelsCard({super.key, required this.imageUrl, this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        showDialog(
          context: context,
          builder: (_) => ShowAllPhotoOrReelWidget(url: videoUrl??imageUrl),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? "",
          height: height(220),
          width: width(140),
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: height(220),
              width: width(140),
              color: Colors.white,
            ),
          ),
          errorWidget:
              (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );;
  }
}
