import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';

Color _statusColor(String status) {
  switch (status) {
    case 'Delivered':
    case 'Approved':
    case 'Paid':
      return Colors.green;
    case 'Cancelled':
    case 'Rejected':
      return Colors.red;
    case 'Deleted':
      return Colors.grey;
    case 'Processing':
    case 'Pending':
    default:
      return Colors.orange;
  }
}

/// Coloured pill showing an API status (`Processing`, `Paid`, `Pending`, ...)
/// translated into the current language.
class AdminStatusBadge extends StatelessWidget {
  final String status;

  const AdminStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final key = LK.statusKey(status);
    final translated = key.tr();
    // easy_localization returns the key itself when it has no entry.
    final label = translated == key ? status : translated;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width(10), vertical: height(4)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
