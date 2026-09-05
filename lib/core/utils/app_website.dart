import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/translation_keys.dart';
import 'show_message.dart';

/// The public web front end for this marketplace.
const String kAppWebsite = 'https://fashion-one-xi.vercel.app';

/// Opens [kAppWebsite] in the device browser.
///
/// `externalApplication` on purpose: this is a full site, not a snippet of
/// content, and an in-app web view would strand the user in a page with no
/// address bar and no way to sign in to it.
Future<void> openAppWebsite() async {
  try {
    final opened = await launchUrl(
      Uri.parse(kAppWebsite),
      mode: LaunchMode.externalApplication,
    );
    if (opened) return;
  } catch (_) {
    // Fall through to the notice below.
  }
  showMessage(LK.supportUnavailable.tr());
}
