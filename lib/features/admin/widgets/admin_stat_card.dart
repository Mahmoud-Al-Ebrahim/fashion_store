import 'package:flutter/material.dart';

import '../../../core/screen_util.dart';

class AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const AdminStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tint = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: EdgeInsets.all(width(14)),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tint, size: 26),
          SizedBox(height: height(10)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              color: tint,
            ),
          ),
          SizedBox(height: height(2)),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: const Color(0xff7A7A7A)),
          ),
        ],
      ),
    );
  }
}
