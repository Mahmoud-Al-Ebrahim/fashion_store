import 'package:flutter/material.dart';

import '../../../../../../core/screen_util.dart';

class TextDescColumnWhoAmI extends StatelessWidget {
  final String text;
  final String desc;

  const TextDescColumnWhoAmI({
    super.key,
    required this.text,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              "$text : ",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: width(4)), // بدل height لأننا في Row
          Flexible(
            child: Text(
              "$desc",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // يمكن تغيير الرقم لعدد السطور المطلوب
            ),
          ),
        ],
      ),
    );
  }
}
