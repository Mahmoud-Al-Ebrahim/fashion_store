import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/screen_util.dart';

class ImageWhoAmIForStoreDashboard extends StatefulWidget {
  final String imageUrl; // رابط الصورة من النت

  final ValueNotifier<File?> image;

  const ImageWhoAmIForStoreDashboard({super.key, required this.imageUrl, required this.image});

  @override
  State<ImageWhoAmIForStoreDashboard> createState() => _ImageWhoAmIForStoreDashboardState();
}

class _ImageWhoAmIForStoreDashboardState extends State<ImageWhoAmIForStoreDashboard> {

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      widget.image.value = File(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.image,
        builder: (context, fileImage, child) {
          return fileImage != null ? Image.file(
            fileImage,
            fit: BoxFit.cover,
            height: height(120),
            width: width(350),
          ) : Image.network(
            widget.imageUrl,
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
          );
        }
      ),
    );
  }
}
