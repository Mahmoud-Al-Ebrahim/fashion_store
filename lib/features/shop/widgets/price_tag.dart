import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';

/// Formats a money amount without trailing ".00" noise.
String formatPrice(double value) {
  final rounded = value.roundToDouble();
  return (value == rounded ? rounded.toInt().toString() : value.toStringAsFixed(2));
}

/// Shows the effective price, with the original struck through when a
/// discount is active.
class PriceTag extends StatelessWidget {
  final double price;
  final double priceAfterDiscount;
  final bool hasDiscount;
  final double? fontSize;
  final Color? color;

  const PriceTag({
    super.key,
    required this.price,
    required this.priceAfterDiscount,
    required this.hasDiscount,
    this.fontSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primary = color ?? Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${formatPrice(priceAfterDiscount)} ${LK.commonCurrency.tr()}',
          style: TextStyle(
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        if (hasDiscount) ...[
          SizedBox(width: width(6)),
          Text(
            formatPrice(price),
            style: TextStyle(
              fontSize: (fontSize ?? 14) - 2,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}

/// Small "-25%" badge drawn over a product image.
class DiscountBadge extends StatelessWidget {
  final double percentage;

  const DiscountBadge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width(8), vertical: height(3)),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${formatPrice(percentage)}% ${LK.productDiscount.tr()}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
