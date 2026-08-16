import 'package:flutter/material.dart';

import '../../../core/screen_util.dart';

const Map<String, String> kOrderStatusArabic = {
  'Processing': 'قيد التجهيز',
  'Delivered': 'تم التوصيل',
  'Cancelled': 'ملغي',
};

const Map<String, String> kStoreStatusArabic = {
  'Pending': 'قيد المراجعة',
  'Approved': 'مقبول',
  'Rejected': 'مرفوض',
  'Deleted': 'محذوف',
  'Cancelled': 'ملغي',
};

const Map<String, String> kComplaintStatusArabic = {'Pending': 'قيد المراجعة'};

Color _statusColor(String status) {
  switch (status) {
    case 'Delivered':
    case 'Approved':
    case 'Paid':
      return Colors.green;
    case 'Cancelled':
    case 'Rejected':
      return Colors.red;
    case 'Deleted':
      return Colors.grey;
    case 'Processing':
    case 'Pending':
    default:
      return Colors.orange;
  }
}

class AdminStatusBadge extends StatelessWidget {
  final String status;
  final Map<String, String>? labels;

  const AdminStatusBadge({super.key, required this.status, this.labels});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final label = labels?[status] ?? status;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width(10), vertical: height(4)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
