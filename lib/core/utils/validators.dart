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

/// Letters (Latin or Arabic), spaces, apostrophes and hyphens only - no
/// digits or symbols.
final RegExp _nameRegex = RegExp(r"^[\p{L}\s'’-]+$", unicode: true);

/// Syrian mobile numbers. Accepts the local form `09XXXXXXXX` and the
/// international forms `+9639XXXXXXXX` / `009639XXXXXXXX`. The operator digit
/// after the leading 9 must be 3-9 (Syriatel/MTN ranges).
final RegExp _syrianPhoneRegex =
    RegExp(r'^(?:(?:\+|00)963|0)9[1-9]\d{7}$');

/// Shared form validators so every screen reports the same messages.

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return LK.authEmailRequired.tr();
  if (!emailRegex.hasMatch(value.trim())) return LK.authEmailInvalid.tr();
  return null;
}

String? validateName(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return LK.commonRequiredField.tr();
  if (trimmed.length < 3) return LK.authNameTooShort.tr();
  if (!_nameRegex.hasMatch(trimmed)) return LK.authNameLettersOnly.tr();
  return null;
}

/// Usernames may contain letters, digits, dots and underscores but must not
/// be purely numeric.
String? validateUsername(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return LK.commonRequiredField.tr();
  if (trimmed.length < 3) return LK.authNameTooShort.tr();
  if (!RegExp(r'^[\p{L}0-9._]+$', unicode: true).hasMatch(trimmed)) {
    return LK.authUsernameInvalid.tr();
  }
  return null;
}

String? validateSyrianPhone(String? value) {
  final trimmed = (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
  if (trimmed.isEmpty) return LK.commonRequiredField.tr();
  if (!_syrianPhoneRegex.hasMatch(trimmed)) return LK.authPhoneInvalidSy.tr();
  return null;
}

/// Normalizes any accepted Syrian format to the local `09XXXXXXXX` form the
/// backend stores.
String normalizeSyrianPhone(String value) {
  var trimmed = value.replaceAll(RegExp(r'[\s-]'), '');
  if (trimmed.startsWith('+963')) return '0${trimmed.substring(4)}';
  if (trimmed.startsWith('00963')) return '0${trimmed.substring(5)}';
  return trimmed;
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

String? validateRequired(String? value) =>
    (value == null || value.trim().isEmpty)
        ? LK.commonRequiredField.tr()
        : null;

/// Canonical UUID form, used for wallet identifiers.
final RegExp _uuidRegex = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);

String? validateWalletId(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return LK.commonRequiredField.tr();
  if (!_uuidRegex.hasMatch(trimmed)) return LK.paymentWalletIdInvalid.tr();
  return null;
}

/// A top-up amount: a real number strictly greater than zero.
///
/// Wallet operations here are credit-only, so negatives and zero are
/// rejected before the request is ever sent.
String? validatePositiveAmount(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return LK.commonRequiredField.tr();
  final parsed = double.tryParse(trimmed);
  if (parsed == null || parsed.isNaN || parsed.isInfinite) {
    return LK.paymentAmountInvalid.tr();
  }
  if (parsed <= 0) return LK.paymentAmountMustBePositive.tr();
  return null;
}
