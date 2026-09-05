import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerCard extends StatelessWidget {
  /// Path to an SVG in `assets/svg`. Null when [iconData] is used instead.
  final String? icon;

  /// A Material icon, for rows that have no bespoke asset - reusing one of
  /// the existing SVGs would put the same glyph on two different rows.
  final IconData? iconData;
  final String title;
  final VoidCallback onTap;
  final bool showArrow; // ✅ إضافة

  const DrawerCard({
    super.key,
    this.icon,
    this.iconData,
    required this.title,
    required this.onTap,
    this.showArrow = true, // ✅ القيمة الافتراضية
  }) : assert(icon != null || iconData != null, 'give the row an icon');

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;

    return ListTile(
      leading: GestureDetector(
        onTap: onTap,
        child: icon != null
            ? SvgPicture.asset(icon!, width: 20, height: 20, color: color)
            : Icon(iconData, size: 22, color: color),
      ),
      title: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: showArrow
          ? IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: color,
                size: 15,
              ),
            )
          : null, // ✅ ما يعرض السهم إذا false
    );
  }
}
