import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';

/// Selectable card used on the "choose account type" screen.
class AccountKindItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountKindItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(width(14)),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? primary : const Color(0xFFD3D3E4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: primary),
            SizedBox(height: height(10)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? primary : null,
              ),
            ),
            SizedBox(height: height(4)),
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xff7A7A7A),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
