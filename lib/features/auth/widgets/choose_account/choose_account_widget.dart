import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountKindItem extends StatefulWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountKindItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AccountKindItem> createState() => _AccountKindItemState();
}

class _AccountKindItemState extends State<AccountKindItem> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return RepaintBoundary(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 2.4,
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary.withOpacity(0.40),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SvgPicture.asset(
            widget.icon,
            width: 60,
            height: 60,
          ),              const SizedBox(height: 8),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
