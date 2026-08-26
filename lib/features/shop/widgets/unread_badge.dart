import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';

/// Red pill showing how many messages in a complaint thread are still
/// unread, fed by the `numberOfUnReadMessage` field the complaint endpoints
/// return. Renders nothing when the thread is fully read, so callers can
/// drop it into a row unconditionally.
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count, this.showLabel = false});

  final int count;

  /// When true, renders "N unread" instead of the bare number - used where
  /// there is room for words rather than a tight circle.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    if (showLabel) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: width(10),
          vertical: height(4),
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          LK.complaintsUnreadCount.tr(args: ['$count']),
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    // Past 99 the circle would stretch out of shape.
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: BoxConstraints(minWidth: width(22)),
      height: width(22),
      padding: EdgeInsets.symmetric(horizontal: width(6)),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
