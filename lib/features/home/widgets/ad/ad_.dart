import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';

class Ad extends StatelessWidget {
  const Ad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(120),
      width: width(380),
      margin: EdgeInsets.only(left: width(20)),
      decoration: BoxDecoration(
        color: Color(0xFF2E3144),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.22),
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
