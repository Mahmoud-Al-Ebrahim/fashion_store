import 'package:flutter/material.dart';

/// Shows a simple yes/no confirmation dialog. Returns true if confirmed.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmText = 'حذف',
  String cancelText = 'إلغاء',
  bool isDestructive = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message != null ? Text(message) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmText,
            style: TextStyle(
              color: isDestructive ? Colors.red : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
