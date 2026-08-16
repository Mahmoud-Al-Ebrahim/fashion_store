import 'package:flutter/material.dart';

import '../../../../../../core/screen_util.dart';

class ChooseCategoryProductsCard extends StatelessWidget {
  final String title;
  final bool isSelected;

  const ChooseCategoryProductsCard({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(100),
      height: height(38),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:  Theme.of(context).colorScheme.primary ,width: 0.5        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}