import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/screen_util.dart';

class PhotoOrReelsCard extends StatelessWidget {
  final String text;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PhotoOrReelsCard({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final orange = primary; // فيك تغير للون الأساسي تبعك

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: height(38),
        width: width(113),
        decoration: BoxDecoration(
          color: isSelected ? orange : Colors.transparent,
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                color: isSelected ? Colors.white : primary,
              ),
              SizedBox(width: width(12)),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected ? Colors.white : primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
