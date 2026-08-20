import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/widgets/loading_indicator/fashion_loader.dart';
import '../../../app/widgets/nodata.dart';
import '../../../core/screen_util.dart';
import '../../../core/localization/translation_keys.dart';

/// Generic loading/error/empty/content switcher for a bloc-backed list or
/// detail view. Callers convert their specific `XStatus` enum into the three
/// booleans below.
class AdminAsyncView extends StatelessWidget {
  final bool isLoading;
  final bool isFailure;
  final bool isEmpty;
  final String errorMessage;

  /// Defaults to the localized "no data" message when omitted.
  final String? emptyText;
  final VoidCallback? onRetry;
  final Widget child;

  const AdminAsyncView({
    super.key,
    required this.isLoading,
    required this.isFailure,
    required this.isEmpty,
    required this.child,
    this.errorMessage = '',
    this.emptyText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: FashionLoader());
    }
    if (isFailure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 42,
              ),
              SizedBox(height: height(10)),
              Text(
                errorMessage.isEmpty ? LK.commonErrorGeneric.tr() : errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (onRetry != null) ...[
                SizedBox(height: height(14)),
                TextButton(onPressed: onRetry, child: Text(LK.commonRetry.tr())),
              ],
            ],
          ),
        ),
      );
    }
    if (isEmpty) {
      return NoData(
        heightt: height(250),
        text: emptyText ?? LK.commonNoData.tr(),
      );
    }
    return child;
  }
}
