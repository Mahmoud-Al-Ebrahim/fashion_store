import 'package:flutter/material.dart';
import '../../../../../../core/screen_util.dart';

class ImageWhoAmI extends StatelessWidget {
  final String imageUrl; // رابط الصورة من النت

  const ImageWhoAmI({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: height(120),
        width: width(350),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: height(120),
            width: width(350),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            height: height(120),
            width: width(350),
            child: Center(
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
