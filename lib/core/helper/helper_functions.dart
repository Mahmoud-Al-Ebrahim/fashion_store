import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class HelperFunctions {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<MultipartFile> prepareFileToUpload(File file) async {
    String fileName = file.path.split('/').last;
    String mimeType = mime(fileName) ?? '';
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];

    return MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: MediaType(mimee, type),
    );
  }

  static String formatDateTime(DateTime dt) {
    // Format hour/minute with AM/PM
    int hour = dt.hour;
    String ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12; // midnight or noon edge case
    String minute = dt.minute.toString().padLeft(2, '0');

    return "$hour:$minute $ampm";
  }

  static navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  static navigateToPageAndPopAll(BuildContext context, Widget page , [bool root = false]) {
    Navigator.of(context , rootNavigator: root).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static slidingNavigation(
    BuildContext context,
    Widget page, {
    int milliseconds = 300,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return page;
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), //// navigation from right
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }
}
