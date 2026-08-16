import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool showArrow; // ✅ إضافة

  const DrawerCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true, // ✅ القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;

    return ListTile(
      leading: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          color: color,
        ),
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
