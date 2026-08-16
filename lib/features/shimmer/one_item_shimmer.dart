import 'package:flutter/material.dart';

import '../../core/screen_util.dart';



class OneItemShimmer extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final double? radius; // اختيارية
  final double borderWidth; // اختيارية (افتراضيًا 0)
  final Widget? child;

  const OneItemShimmer({
    super.key,
    required this.itemHeight,
    required this.itemWidth,
    this.radius, // لم يعد مطلوبًا
    this.borderWidth = 0, // افتراضيًا بدون حدود
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(itemHeight),
      width: width(itemWidth),
      decoration: BoxDecoration(
        color: borderWidth ==0 ? Colors.white : null, // لا نضع اللون إلا عند وجود radius
        borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
        border: borderWidth > 0 ? Border.all(color: Colors.white, width: borderWidth) : null, // يتم التعيين فقط عند وجود عرض للحدود
      ),
      child: child ?? const SizedBox(),
    );
  }
}
