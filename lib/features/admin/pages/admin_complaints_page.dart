import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../widgets/admin_async_view.dart';
import '../../shop/widgets/unread_badge.dart';
import '../widgets/admin_status_badge.dart';
import 'admin_complaint_detail_page.dart';
import '../../../core/localization/translation_keys.dart';

class AdminComplaintsPage extends StatefulWidget {
  const AdminComplaintsPage({super.key});

  @override
  State<AdminComplaintsPage> createState() => _AdminComplaintsPageState();
}

class _AdminComplaintsPageState extends State<AdminComplaintsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<ComplaintBloc>().add(GetAllComplaintsEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.adminComplaints.tr()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _load(),
        child: BlocBuilder<ComplaintBloc, ComplaintState>(
          builder: (context, state) {
            // Newest conversation on top.
            // Most recently active first - see the note on the customer
            // list: unread threads bubble up, then newest.
            final sorted = [...state.storeComplaints]
              ..sort((a, b) {
                final unread = b.numberOfUnReadMessage.compareTo(
                  a.numberOfUnReadMessage,
                );
                if (unread != 0) return unread;
                return b.createdAt.compareTo(a.createdAt);
              });
            return AdminAsyncView(
              isLoading:
                  state.getAllComplaintsStatus ==
                  GetAllComplaintsStatus.loading,
              isFailure:
                  state.getAllComplaintsStatus ==
                  GetAllComplaintsStatus.failure,
              isEmpty:
                  state.getAllComplaintsStatus ==
                      GetAllComplaintsStatus.success &&
                  state.storeComplaints.isEmpty,
              errorMessage: state.errorMessage,
              emptyText: LK.adminNoComplaints.tr(),
              onRetry: _load,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                itemCount: sorted.length,
                separatorBuilder: (_, __) => SizedBox(height: height(10)),
                itemBuilder: (context, index) {
                  final complaint = sorted[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD3D3E4)),
                    ),
                    child: ListTile(
                      onTap: () => context.pushPage(
                        AdminComplaintDetailPage(complaint: complaint),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEAEAF2),
                        child: Text(
                          complaint.customerFullName.isNotEmpty
                              ? complaint.customerFullName[0]
                              : '?',
                        ),
                      ),
                      title: Text(complaint.title),
                      subtitle: Text(
                        complaint.customerFullName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Unread messages waiting in this thread.
                          UnreadBadge(count: complaint.numberOfUnReadMessage),
                          if (complaint.numberOfUnReadMessage > 0)
                            SizedBox(width: width(6)),
                          AdminStatusBadge(status: complaint.status),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
