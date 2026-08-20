import 'package:easy_localization/easy_localization.dart';

import '../localization/translation_keys.dart';

const String _emailPattern =
    r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

final RegExp emailRegex = RegExp(_emailPattern);

/// Shared form validators so every auth screen reports the same messages.

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return LK.authEmailRequired.tr();
  if (!emailRegex.hasMatch(value.trim())) return LK.authEmailInvalid.tr();
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return LK.authPasswordRequired.tr();
  if (value.length < 8) return LK.authPasswordShort.tr();
  return null;
}

String? Function(String?) validateConfirmPassword(String Function() original) {
  return (String? value) {
    if (value == null || value.isEmpty) return LK.authPasswordRequired.tr();
    if (value != original()) return LK.authPasswordMismatch.tr();
    return null;
  };
}
