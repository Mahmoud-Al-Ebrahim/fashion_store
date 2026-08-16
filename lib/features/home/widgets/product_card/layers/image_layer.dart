import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageLayer extends StatelessWidget {
  final String imageUrl;
  const ImageLayer({super.key, required this.imageUrl});



  @override
  Widget build(BuildContext context) {
 //   print(imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) {
           //   print('❌ Image load error for $url: $error');
              return const Icon(Icons.error, color: Colors.red);
            },
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(43, 47, 63, 0.65),
                    Color.fromRGBO(43, 47, 63, 0.35),
                    Color.fromRGBO(43, 47, 63, 0.0),
                  ],
                  stops: [0.0, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
