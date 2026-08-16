import 'package:flutter/material.dart';

import '../../core/screen_util.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  double? heightButton;
  double? widthButton;
  bool? isWhiteBackground;

  final Color? color;

  AuthButton({
    super.key,
    this.onTap,
    this.color,
    this.heightButton = 54,
    this.widthButton = 370,
    this.isWhiteBackground = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: heightButton ?? height(54),
        width: widthButton ?? width(370),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.22),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            width: 1.5,
            color:
                isWhiteBackground == true
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
          ),
          color:
          color ?? (isWhiteBackground == false
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color:
                  isWhiteBackground == true
                      ? Theme.of(context).colorScheme.shadow
                      : Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatelessWidget {
  final bool isFollowing;

  const FollowButton({super.key, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(90),
      height: width(30),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          isFollowing ? 'الغاء متابعة' : 'متابعة',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w300,
              fontSize: 11.7
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
