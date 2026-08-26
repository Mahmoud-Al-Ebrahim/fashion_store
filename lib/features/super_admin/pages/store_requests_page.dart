import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/admin_bloc/admin_bloc.dart';
import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../blocs/super_admin_bloc/super_admin_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/store/store_detail_model.dart';
import '../../admin/widgets/admin_status_badge.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/utils/whatsapp.dart';
import '../../admin/widgets/confirm_dialog.dart';
import 'store_request_details_page.dart';

/// Store applications awaiting a platform decision, filterable by status.
class StoreRequestsPage extends StatefulWidget {
  const StoreRequestsPage({super.key});

  @override
  State<StoreRequestsPage> createState() => _StoreRequestsPageState();
}

class _StoreRequestsPageState extends State<StoreRequestsPage> {
  static const _statuses = [
    'Pending',
    'Approved',
    'Rejected',
    'Cancelled',
    'Deleted',
  ];
  String _status = 'Pending';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<SuperAdminBloc>().add(
      GetAllStoreRequestsByFilterEvent(
        storeStatus: _status,
        pageNumber: 1,
        pageSize: 100,
      ),
    );
  }

  Future<void> _approve(StoreDetailModel request) async {
    final confirmed = await confirmDialog(
      context,
      title: LK.superadminApprove.tr(),
      message: '${LK.superadminApproveConfirm.tr()}\n${request.storeName}',
      confirmText: LK.superadminApprove.tr(),
      isDestructive: false,
    );
    if (!confirmed || !mounted) return;
    context.read<SuperAdminBloc>().add(
      ApproveStoreRequestEvent(requestId: request.id),
    );
  }

  Future<void> _reject(StoreDetailModel request) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LK.superadminReject.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${LK.superadminRejectConfirm.tr()}\n${request.storeName}'),
            SizedBox(height: height(12)),
            AuthTextField(
              controller: reasonController,
              hintText: LK.superadminRejectionReasonHint.tr(),
              maxLines: 3,
              validator: (_) => null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LK.commonCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              LK.superadminReject.tr(),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    context.read<SuperAdminBloc>().add(
      RejectStoreRequestEvent(
        requestId: request.id,
        rejectionReason: reasonController.text.trim().isEmpty
            ? null
            : reasonController.text.trim(),
      ),
    );
  }

  Future<void> _deleteStore(StoreDetailModel request) async {
    final confirmed = await confirmDialog(
      context,
      title: LK.commonDelete.tr(),
      message: request.storeName,
    );
    if (!confirmed || !mounted) return;
    context.read<AdminBloc>().add(DeleteStoreEvent(storeId: request.id));
  }

  /// The KYC documents attached to the application.
  void _showDocuments(StoreDetailModel request) {
    context.read<StoreRequestBloc>().add(
      GetStoreRequestFilesEvent(storeId: request.id),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<StoreRequestBloc>(),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          expand: false,
          builder: (_, scrollController) =>
              BlocBuilder<StoreRequestBloc, StoreRequestState>(
                builder: (context, state) {
                  final files = state.storeRequestFiles;
                  final urls = <String, String?>{
                    LK.sellerNationalIdFront.tr(): files?.nationalIdFrontImage,
                    LK.sellerNationalIdBack.tr(): files?.nationalIdBackImage,
                    LK.sellerLicense.tr(): files?.storeLicenseImage,
                  };
                  return ListView(
                    controller: scrollController,
                    padding: EdgeInsets.all(width(20)),
                    children: [
                      Text(
                        LK.superadminDocuments.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: height(14)),
                      if (state.getStoreRequestFilesStatus ==
                          GetStoreRequestFilesStatus.loading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ...urls.entries.map(
                          (entry) => Padding(
                            padding: EdgeInsets.only(bottom: height(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.key),
                                SizedBox(height: height(6)),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: entry.value == null
                                      ? Container(
                                          height: height(140),
                                          color: const Color(0xFFEAEAF2),
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: ApiService.resolveUrl(
                                            entry.value,
                                          )!,
                                          height: height(180),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              Container(
                                                height: height(140),
                                                color: const Color(0xFFEAEAF2),
                                                child: const Icon(
                                                  Icons.broken_image_outlined,
                                                ),
                                              ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.superadminRequests.tr()),
      ),
      body: BlocListener<AdminBloc, AdminState>(
        listenWhen: (p, c) => p.deleteStoreStatus != c.deleteStoreStatus,
        listener: (context, state) {
          if (state.deleteStoreStatus == DeleteStoreStatus.success) {
            showMessage(LK.adminProductDeleted.tr(), hasError: false);
            _load();
          } else if (state.deleteStoreStatus == DeleteStoreStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: BlocConsumer<SuperAdminBloc, SuperAdminState>(
          listenWhen: (p, c) =>
              p.storeRequestDecisionStatus != c.storeRequestDecisionStatus,
          listener: (context, state) {
            if (state.storeRequestDecisionStatus ==
                StoreRequestDecisionStatus.success) {
              showMessage(
                // Approve and reject share one status, so the flag decides.
                state.lastDecisionWasApproval == false
                    ? LK.superadminRejectedDone.tr()
                    : LK.superadminApprovedDone.tr(),
                hasError: false,
              );
              _load();
            } else if (state.storeRequestDecisionStatus ==
                StoreRequestDecisionStatus.failure) {
              showMessage(state.errorMessage);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: height(50),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: width(16)),
                    itemCount: _statuses.length,
                    separatorBuilder: (_, __) => SizedBox(width: width(8)),
                    itemBuilder: (context, index) {
                      final status = _statuses[index];
                      final selected = status == _status;
                      return Center(
                        child: ChoiceChip(
                          label: Text(LK.statusKey(status).tr()),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => _status = status);
                            _load();
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: AsyncView(
                    isLoading:
                        state.getAllStoreRequestsByFilterStatus ==
                        GetAllStoreRequestsByFilterStatus.loading,
                    isFailure:
                        state.getAllStoreRequestsByFilterStatus ==
                        GetAllStoreRequestsByFilterStatus.failure,
                    isEmpty:
                        state.getAllStoreRequestsByFilterStatus ==
                            GetAllStoreRequestsByFilterStatus.success &&
                        state.storeRequests.isEmpty,
                    errorMessage: state.errorMessage,
                    emptyText: LK.superadminNoRequests.tr(),
                    onRetry: _load,
                    child: RefreshIndicator(
                      onRefresh: () async => _load(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(width(16)),
                        itemCount: state.storeRequests.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: height(12)),
                        itemBuilder: (context, index) {
                          final request = state.storeRequests[index];
                          return _RequestCard(
                            request: request,
                            onDetails: () => context.pushPage(
                              StoreRequestDetailsPage(request: request),
                            ),
                            onApprove: () => _approve(request),
                            onReject: () => _reject(request),
                            onDocuments: () => _showDocuments(request),
                            onDelete: () => _deleteStore(request),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final StoreDetailModel request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onDocuments;
  final VoidCallback onDelete;
  final VoidCallback onDetails;

  const _RequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onDocuments,
    required this.onDelete,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final pending = request.storeStatus == 'Pending';
    return Container(
      padding: EdgeInsets.all(width(14)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD3D3E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFEAEAF2),
                backgroundImage: request.logo != null
                    ? CachedNetworkImageProvider(
                        ApiService.resolveUrl(request.logo)!,
                      )
                    : null,
                child: request.logo == null ? const Icon(Icons.store) : null,
              ),
              SizedBox(width: width(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.storeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      request.storeEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              AdminStatusBadge(status: request.storeStatus),
            ],
          ),
          SizedBox(height: height(10)),
          Text(
            request.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: height(6)),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14),
              SizedBox(width: width(4)),
              Expanded(
                child: Text(
                  request.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              // Tapping the phone opens WhatsApp with the store owner.
              if (request.storePhoneNumber.isNotEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () =>
                      openWhatsApp(context, phone: request.storePhoneNumber),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(4),
                      vertical: height(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat,
                          size: 14,
                          color: Color(0xFF25D366),
                        ),
                        SizedBox(width: width(4)),
                        Text(
                          request.storePhoneNumber,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: const Color(0xFF25D366),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: height(10)),
          Row(
            children: [
              TextButton.icon(
                onPressed: onDetails,
                icon: const Icon(Icons.info_outline, size: 18),
                label: Text(LK.superadminRequestDetails.tr() , style: TextStyle(fontSize: 12),),
              ),
              TextButton.icon(
                onPressed: onDocuments,
                icon: const Icon(Icons.description_outlined, size: 18),
                label: Text(LK.superadminViewDocuments.tr() , style: TextStyle(fontSize: 12),),
              ),
              const Spacer(),
              if (request.storeStatus == 'Approved')
                IconButton(
                  tooltip: LK.commonDelete.tr(),
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
            ],
          ),
          if (pending) ...[
            SizedBox(height: height(4)),
            Row(
              children: [
                Expanded(
                  child: AuthButton(
                    text: LK.superadminApprove.tr(),
                    heightButton: height(44),
                    widthButton: double.infinity,
                    onTap: onApprove,
                  ),
                ),
                SizedBox(width: width(10)),
                Expanded(
                  child: AuthButton(
                    text: LK.superadminReject.tr(),
                    color: Colors.red,
                    heightButton: height(44),
                    widthButton: double.infinity,
                    onTap: onReject,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
