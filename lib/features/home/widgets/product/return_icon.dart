import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../core/screen_util.dart';

class ReturnIcon extends StatelessWidget {
  const ReturnIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height(35),
      right: width(15),
      child: Container(
        width: width(44),
        height: height(44),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
