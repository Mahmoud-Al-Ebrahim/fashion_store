import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductName extends StatelessWidget {
  final String productName;
  final bool showIngredients;

  const ProductName({
    super.key,
    required this.showIngredients,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          productName,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        Spacer(),
        showIngredients
            ? SvgPicture.asset(
                "assets/svg/Up.svg",
                color: Theme.of(context).colorScheme.onSurface,
              )
            : SvgPicture.asset(
                "assets/svg/Down.svg",
                color: Theme.of(context).colorScheme.onSurface,
              ),
      ],
    );
  }
}
