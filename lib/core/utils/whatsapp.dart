import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/translation_keys.dart';
import 'package:easy_localization/easy_localization.dart';

/// Phone number of the top-up desk operator customers contact to credit
/// their wallet. Kept here so both the wallet screen and any future surface
/// use the same number.
const String kTopUpAgentWhatsApp = '+963993730296';

/// Opens a WhatsApp conversation with [phone].
///
/// WhatsApp's `wa.me` links need a bare international number: no `+`, no
/// spaces, no dashes, and no leading `00`. Local Syrian numbers (`09xxxxxxxx`)
/// are promoted to `9639xxxxxxxx`, which is what the store-request records and
/// user profiles usually hold.
String normalizeWhatsAppNumber(String phone) {
  var digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.startsWith('+')) digits = digits.substring(1);
  if (digits.startsWith('00')) digits = digits.substring(2);
  if (digits.startsWith('0')) digits = '963${digits.substring(1)}';
  return digits;
}

/// Launches WhatsApp for [phone], optionally pre-filling [message].
///
/// Returns false (and shows a snack bar when [context] is still mounted) if
/// no handler is available - e.g. WhatsApp isn't installed.
Future<bool> openWhatsApp(
  BuildContext context, {
  required String phone,
  String? message,
}) async {
  final number = normalizeWhatsAppNumber(phone);
  if (number.isEmpty) return false;

  final uri = Uri.https('wa.me', '/$number', {
    if (message != null && message.isNotEmpty) 'text': message,
  });

  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (ok) return true;
  } catch (_) {
    // Fall through to the failure notice below.
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LK.commonWhatsappUnavailable.tr())),
    );
  }
  return false;
}
