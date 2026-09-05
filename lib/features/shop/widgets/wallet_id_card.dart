import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';

/// Shows the wallet identifier with a copy button.
///
/// The top-up desk credits a wallet by id, so the holder needs to be able to
/// read and hand over this value.
class WalletIdCard extends StatelessWidget {
  final String? walletId;

  /// Line under the id. Defaults to the customer's wording, which is about
  /// handing the id to the payment desk. A store owner's wallet is credited
  /// by sales rather than topped up, so that screen passes its own line -
  /// see [LK.walletIdHintBalance].
  final String? hint;

  const WalletIdCard({super.key, required this.walletId, this.hint});

  @override
  Widget build(BuildContext context) {
    final id = walletId;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width(14)),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: width(6)),
              Text(
                LK.walletIdLabel.tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          SizedBox(height: height(8)),
          if (id == null || id.isEmpty)
            Text(
              LK.walletNone.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    id,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: LK.walletCopy.tr(),
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: id));
                    showMessage(LK.walletCopied.tr(), hasError: false);
                  },
                ),
              ],
            ),
            SizedBox(height: height(4)),
            Text(
              hint ?? LK.walletIdHint.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
