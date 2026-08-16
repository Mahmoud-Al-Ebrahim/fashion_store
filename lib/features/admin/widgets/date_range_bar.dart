import 'package:flutter/material.dart';

import '../../../core/screen_util.dart';

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

  Future<void> _pick(
    BuildContext context,
    DateTime initial,
    ValueChanged<DateTime> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
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
            onTap: () => _pick(context, startDate, onStartChanged),
          ),
        ),
        SizedBox(width: width(8)),
        Icon(Icons.arrow_back, size: 16, color: primary),
        SizedBox(width: width(8)),
        Expanded(
          child: _DateChip(
            label: _formatDate(endDate),
            onTap: () => _pick(context, endDate, onEndChanged),
          ),
        ),
        SizedBox(width: width(8)),
        IconButton(
          onPressed: onApply,
          icon: Icon(Icons.filter_alt, color: primary),
          tooltip: 'تطبيق',
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
        padding: EdgeInsets.symmetric(horizontal: width(10), vertical: height(10)),
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
