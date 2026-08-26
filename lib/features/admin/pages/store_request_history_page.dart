import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../widgets/admin_async_view.dart';
import '../widgets/admin_status_badge.dart';

/// The applicant's own store requests, filterable by status via
/// `StoreRequest/GetFilterRequestStoreByUser`.
///
/// An account accumulates records over time - a cancelled attempt, a
/// rejection, then an approval - and the status card on the pending screen
/// only ever reflects the newest one. This is where the rest of them live.
///
/// Note the restore on exit: the filter endpoint writes into the same
/// `storeRequests` list the pending screen reads to decide which request is
/// "latest". Leaving a filter applied would make that screen describe the
/// wrong request, so the unfiltered list is re-fetched on the way out.
class StoreRequestHistoryPage extends StatefulWidget {
  const StoreRequestHistoryPage({super.key});

  @override
  State<StoreRequestHistoryPage> createState() =>
      _StoreRequestHistoryPageState();
}

class _StoreRequestHistoryPageState extends State<StoreRequestHistoryPage> {
  /// null = no filter, use the unfiltered endpoint.
  String? _status;

  static const _statuses = ['Pending', 'Approved', 'Rejected', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final bloc = context.read<StoreRequestBloc>();
    final status = _status;
    if (status == null) {
      bloc.add(GetAllStoreRequestsByUserEvent());
    } else {
      bloc.add(GetFilterStoreRequestsByUserEvent(storeStatus: status));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) return;
        // Hand the pending screen back the full list.
        context.read<StoreRequestBloc>().add(GetAllStoreRequestsByUserEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(LK.sellerMyRequests.tr()),
        ),
        body: Column(
          children: [
            SizedBox(
              height: height(52),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: width(12)),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(4)),
                    child: Center(
                      child: ChoiceChip(
                        label: Text(LK.commonAll.tr()),
                        selected: _status == null,
                        onSelected: (_) {
                          setState(() => _status = null);
                          _load();
                        },
                      ),
                    ),
                  ),
                  ..._statuses.map(
                    (status) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(4)),
                      child: Center(
                        child: ChoiceChip(
                          label: Text(LK.statusKey(status).tr()),
                          selected: _status == status,
                          onSelected: (_) {
                            setState(() => _status = status);
                            _load();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<StoreRequestBloc, StoreRequestState>(
                buildWhen: (p, c) =>
                    p.getAllStoreRequestsStatus !=
                        c.getAllStoreRequestsStatus ||
                    p.storeRequests != c.storeRequests,
                builder: (context, state) {
                  final status = state.getAllStoreRequestsStatus;
                  final requests = [...state.storeRequests]
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  return AdminAsyncView(
                    isLoading: status == GetAllStoreRequestsStatus.loading,
                    isFailure: status == GetAllStoreRequestsStatus.failure,
                    isEmpty:
                        status == GetAllStoreRequestsStatus.success &&
                        requests.isEmpty,
                    errorMessage: state.errorMessage,
                    emptyText: LK.commonNoData.tr(),
                    onRetry: _load,
                    child: RefreshIndicator(
                      onRefresh: () async => _load(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(width(16)),
                        itemCount: requests.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: height(10)),
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          return Container(
                            padding: EdgeInsets.all(width(14)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD3D3E4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        request.storeName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      ),
                                    ),
                                    AdminStatusBadge(
                                      status: request.storeStatus,
                                    ),
                                  ],
                                ),
                                SizedBox(height: height(6)),
                                Text(
                                  _formatDate(request.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                                if ((request.note ?? '').isNotEmpty) ...[
                                  SizedBox(height: height(6)),
                                  Text(
                                    request.note!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
