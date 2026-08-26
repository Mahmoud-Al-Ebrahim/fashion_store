import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/screen_util.dart';
import '../../../core/localization/translation_keys.dart';

String _formatDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Compact "from - to" date range selector with an apply button, used by the
/// dashboard analytics / sales-detail screens.
class DateRangeBar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;
  final VoidCallback onApply;

  const DateRangeBar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onApply,
  });

  /// Opens a picker constrained so the range can never invert.
  ///
  /// The two chips used to be independent, which let you set a start after
  /// the end - the API then answered with an empty period and the screen
  /// looked broken for no visible reason. Bounding each picker by the other
  /// date makes that unreachable instead of merely discouraged.
  Future<void> _pick(
    BuildContext context, {
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
    required bool isStart,
  }) async {
    final lastSelectable = DateTime.now().add(const Duration(days: 1));
    final firstDate = isStart ? DateTime(2020) : startDate;
    final lastDate = isStart
        // Never past the end of the range - or past today, whichever comes
        // first.
        ? (endDate.isBefore(lastSelectable) ? endDate : lastSelectable)
        : lastSelectable;

    // `initialDate` must sit inside the bounds or showDatePicker asserts.
    var safeInitial = initial;
    if (safeInitial.isBefore(firstDate)) safeInitial = firstDate;
    if (safeInitial.isAfter(lastDate)) safeInitial = lastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Expanded(
          child: _DateChip(
            label: _formatDate(startDate),
            onTap: () => _pick(
              context,
              initial: startDate,
              onPicked: onStartChanged,
              isStart: true,
            ),
          ),
        ),
        SizedBox(width: width(8)),
        // `arrow_forward` mirrors automatically under RTL, so "from -> to"
        // reads correctly in both Arabic and English.
        Icon(Icons.arrow_forward, size: 16, color: primary),
        SizedBox(width: width(8)),
        Expanded(
          child: _DateChip(
            label: _formatDate(endDate),
            onTap: () => _pick(
              context,
              initial: endDate,
              onPicked: onEndChanged,
              isStart: false,
            ),
          ),
        ),
        SizedBox(width: width(8)),
        IconButton(
          onPressed: onApply,
          icon: Icon(Icons.filter_alt, color: primary),
          tooltip: LK.commonApply.tr(),
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width(10),
          vertical: height(10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD3D3E4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 14),
            SizedBox(width: width(6)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
