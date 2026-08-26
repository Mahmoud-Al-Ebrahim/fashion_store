import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../../core/screen_util.dart';
import '../../../models/complaint/complaint_model.dart';
import '../widgets/admin_async_view.dart';
import '../../shop/pages/complaint_chat_page.dart';
import '../../../core/extensions/build_context.dart';
import '../../../app/widgets/button.dart';
import '../widgets/admin_status_badge.dart';
import '../../../core/localization/translation_keys.dart';

class AdminComplaintDetailPage extends StatefulWidget {
  final StoreComplaintModel complaint;

  const AdminComplaintDetailPage({super.key, required this.complaint});

  @override
  State<AdminComplaintDetailPage> createState() => _AdminComplaintDetailPageState();
}

class _AdminComplaintDetailPageState extends State<AdminComplaintDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ComplaintBloc>().add(
      GetComplaintMessagesEvent(complaintId: widget.complaint.complaintId),
    );
    context.read<ComplaintBloc>().add(
      ReadComplaintMessagesEvent(complaintId: widget.complaint.complaintId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final complaint = widget.complaint;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(complaint.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(width(16)),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(complaint.customerFullName, style: Theme.of(context).textTheme.titleSmall),
              AdminStatusBadge(status: complaint.status),
            ],
          ),
          SizedBox(height: height(10)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(width(14)),
            decoration: BoxDecoration(
              color: const Color(0xFFEAEAF2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(complaint.description),
          ),
          SizedBox(height: height(20)),
          Text(
            LK.adminConversation.tr(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: height(8)),
          AuthButton(
            text: LK.chatOpenChat.tr(),
            widthButton: double.infinity,
            heightButton: height(52),
            onTap: () => context.pushPage(
              ComplaintChatPage(
                complaintId: complaint.complaintId,
                counterpartName: complaint.customerFullName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
