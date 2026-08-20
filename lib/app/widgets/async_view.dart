import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/screen_util.dart';
import 'loading_indicator/fashion_loader.dart';
import 'nodata.dart';

/// Loading / error / empty / content switcher shared by every bloc-backed
/// list and detail screen.
class AsyncView extends StatelessWidget {
  final bool isLoading;
  final bool isFailure;
  final bool isEmpty;
  final String errorMessage;
  final String? emptyText;
  final double? emptyImageHeight;
  final VoidCallback? onRetry;
  final Widget child;

  const AsyncView({
    super.key,
    required this.isLoading,
    required this.isFailure,
    required this.isEmpty,
    required this.child,
    this.errorMessage = '',
    this.emptyText,
    this.emptyImageHeight,
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
                TextButton(
                  onPressed: onRetry,
                  child: Text(LK.commonRetry.tr()),
                ),
              ],
            ],
          ),
        ),
      );
    }
    if (isEmpty) {
      return NoData(
        heightt: height(250),
        imageHeight: emptyImageHeight,
        text: emptyText ?? LK.commonNoData.tr(),
      );
    }
    return child;
  }
}
