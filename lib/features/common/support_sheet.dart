import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/app_website.dart';
import '../../core/screen_util.dart';
import '../../core/utils/show_message.dart';

/// Where a user of any role reaches the people running the platform.
const String kSupportEmail = 'ayasally123456@gmail.com';
const String kSupportPhone = '+963980341716';

/// Shows the support contact card.
///
/// Every role gets to this from somewhere: the customer's drawer, the store
/// owner's and the super admin's "More" list, and a floating button on the
/// two screens that are a whole shell on their own (the payment desk, and a
/// store owner whose application is still under review).
Future<void> showSupportSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(width(20), 0, width(20), height(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.headset_mic_outlined,
                  color: Theme.of(sheetContext).colorScheme.primary,
                ),
                SizedBox(width: width(10)),
                Text(
                  LK.supportTitle.tr(),
                  style: Theme.of(sheetContext).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: height(6)),
            Text(
              LK.supportSubtitle.tr(),
              style: Theme.of(
                sheetContext,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
            SizedBox(height: height(18)),
            _SupportRow(
              icon: Icons.mail_outline,
              label: LK.supportEmail.tr(),
              value: kSupportEmail,
              uri: Uri(scheme: 'mailto', path: kSupportEmail),
            ),
            SizedBox(height: height(10)),
            _SupportRow(
              icon: Icons.phone_outlined,
              label: LK.supportPhone.tr(),
              value: kSupportPhone,
              uri: Uri(scheme: 'tel', path: kSupportPhone),
            ),
            SizedBox(height: height(10)),
            // Repeated from the drawer and the "More" lists on purpose: the
            // payment desk and a store owner awaiting approval have neither,
            // and reach this sheet through a floating button.
            _SupportRow(
              icon: Icons.language,
              label: LK.supportWebsite.tr(),
              value: kAppWebsite,
              uri: Uri.parse(kAppWebsite),
            ),
          ],
        ),
      ),
    ),
  );
}

/// One contact line: tap to hand off to the mail or dialler app, or use the
/// copy button.
///
/// Copying is not a fallback here, it is the point - a desktop or a device
/// with no mail client configured has nowhere to hand off to, and the user
/// still needs the address.
class _SupportRow extends StatelessWidget {
  const _SupportRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.uri,
  });

  final IconData icon;
  final String label;
  final String value;
  final Uri uri;

  Future<void> _open(BuildContext context) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (opened) return;
    } catch (_) {
      // Fall through to the notice below.
    }
    showMessage(LK.supportUnavailable.tr());
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: value));
    showMessage(LK.supportCopied.tr(), hasError: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _open(context),
      child: Container(
        padding: EdgeInsets.all(width(12)),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAF2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            SizedBox(width: width(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    // A phone number is read left to right in Arabic too.
                    textDirection: ui.TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: LK.walletCopy.tr(),
              icon: const Icon(Icons.copy, size: 18),
              onPressed: _copy,
            ),
          ],
        ),
      ),
    );
  }
}
