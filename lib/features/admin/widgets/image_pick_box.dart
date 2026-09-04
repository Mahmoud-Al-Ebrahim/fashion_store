import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/screen_util.dart' as su;

/// Tappable bordered box used for picking/replacing an image - shows the
/// newly picked [pickedFile] if set, otherwise [existingImageUrl] (edit
/// mode), otherwise a placeholder label. Mirrors the sign-up flow's
/// image-pick convention.
class ImagePickBox extends StatelessWidget {
  final File? pickedFile;
  final String? existingImageUrl;
  final String label;
  final VoidCallback onTap;
  final double boxHeight;
  final double? boxWidth;
  final BorderRadius? borderRadius;

  const ImagePickBox({
    super.key,
    this.pickedFile,
    this.existingImageUrl,
    required this.label,
    required this.onTap,
    this.boxHeight = 140,
    this.boxWidth,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(14);
    Widget content;
    if (pickedFile != null) {
      content = ClipRRect(
        borderRadius: radius,
        child: Image.file(pickedFile!, fit: BoxFit.cover),
      );
    } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      content = ClipRRect(
        borderRadius: radius,
        child: CachedNetworkImage(
          imageUrl: existingImageUrl!,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              Icon(Icons.broken_image_outlined, color: Colors.grey.shade500),
        ),
      );
    } else {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.grey.shade600,
              size: 32,
            ),
            SizedBox(height: su.height(6)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: boxHeight,
        width: boxWidth,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: radius,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          ),
        ),
        child: content,
      ),
    );
  }
}
