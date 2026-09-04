import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/store/store_detail_model.dart';
import '../../shop/pages/image_viewer_page.dart';
import '../widgets/image_pick_box.dart';
import '../../../core/localization/translation_keys.dart';

class AdminStoreProfilePage extends StatefulWidget {
  const AdminStoreProfilePage({super.key});

  @override
  State<AdminStoreProfilePage> createState() => _AdminStoreProfilePageState();
}

class _AdminStoreProfilePageState extends State<AdminStoreProfilePage> {
  /// Set once the documents have been requested for this store, so the
  /// fetch is not repeated on every rebuild.
  int? _filesRequestedFor;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  TimeOfDay? _start;
  TimeOfDay? _end;
  File? _newLogo;
  File? _newFeaturedImage;
  bool _initialized = false;

  void _fillFrom(StoreDetailModel store) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = store.storeName;
    _descriptionController.text = store.description;
    _addressController.text = store.address;
    _phoneController.text = store.storePhoneNumber;
    _start = _parseTime(store.workingHoursStart);
    _end = _parseTime(store.workingHoursEnd);
  }

  TimeOfDay? _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _start : _end) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => isStart ? _start = picked : _end = picked);
    }
  }

  void _saveInfo(int storeId) {
    context.read<StoreBloc>().add(
      UpdateStoreEvent(
        storeId: storeId,
        storeName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        workingHoursStart: _start != null ? _formatTime(_start!) : null,
        workingHoursEnd: _end != null ? _formatTime(_end!) : null,
      ),
    );
  }

  void _saveImages() {
    if (_newLogo == null && _newFeaturedImage == null) {
      showMessage(LK.adminPickImageFirst.tr());
      return;
    }
    context.read<StoreBloc>().add(
      UpdateStoreImagesEvent(featuredImage: _newFeaturedImage, logo: _newLogo),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.adminStoreProfile.tr()),
      ),
      body: BlocConsumer<StoreBloc, StoreState>(
        listenWhen: (p, c) =>
            p.storeTransactionStatus != c.storeTransactionStatus,
        listener: (context, state) {
          if (state.storeTransactionStatus == StoreTransactionStatus.success) {
            showMessage(LK.adminSavedSuccessfully.tr(), hasError: false);
            setState(() {
              _newLogo = null;
              _newFeaturedImage = null;
            });
          } else if (state.storeTransactionStatus ==
              StoreTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final store = state.myStore;
          if (store == null) {
            return const Center(child: CircularProgressIndicator());
          }
          _fillFrom(store);
          // The ID and licence images live on the original store request.
          if (_filesRequestedFor != store.id) {
            _filesRequestedFor = store.id;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<StoreRequestBloc>().add(
                GetStoreRequestFilesEvent(storeId: store.id),
              );
            });
          }
          final loading =
              state.storeTransactionStatus == StoreTransactionStatus.loading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(width(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ImagePickBox(
                        pickedFile: _newLogo,
                        existingImageUrl: ApiService.resolveUrl(store.logo),
                        label: LK.sellerLogo.tr(),
                        boxHeight: height(110),
                        onTap: () async {
                          final file = await HelperFunctions.pickImage();
                          if (file != null)
                            setState(() => _newLogo = File(file.path));
                        },
                      ),
                    ),
                    SizedBox(width: width(12)),
                    Expanded(
                      child: ImagePickBox(
                        pickedFile: _newFeaturedImage,
                        existingImageUrl: ApiService.resolveUrl(
                          store.featuredImage,
                        ),
                        label: LK.sellerFeaturedImage.tr(),
                        boxHeight: height(110),
                        onTap: () async {
                          final file = await HelperFunctions.pickImage();
                          if (file != null) {
                            setState(() => _newFeaturedImage = File(file.path));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(10)),
                AuthButton(
                  text: LK.adminSaveImages.tr(),
                  onTap: loading ? null : _saveImages,
                  widthButton: double.infinity,
                  heightButton: height(46),
                ),
                SizedBox(height: height(20)),

                // ----- fixed at creation, not editable here -----
                _ReadOnlyBlock(store: store),
                SizedBox(height: height(20)),

                // ----- the documents submitted with the request -----
                _DocumentsBlock(storeId: store.id),
                SizedBox(height: height(20)),

                Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: width(6)),
                    Text(
                      LK.storeProfileEditableNote.tr(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _nameController,
                  labelText: LK.sellerStoreName.tr(),
                  hintText: LK.sellerStoreName.tr(),
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _descriptionController,
                  labelText: LK.sellerDescription.tr(),
                  hintText: LK.sellerDescription.tr(),
                  maxLines: 3,
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _addressController,
                  labelText: LK.storeAddress.tr(),
                  hintText: LK.sellerAddress.tr(),
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _phoneController,
                  labelText: LK.authPhone.tr(),
                  hintText: LK.sellerPhone.tr(),
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(true),
                        child: Text(
                          _start == null
                              ? LK.sellerWorkingHoursStart.tr()
                              : '${LK.sellerWorkingHoursStart.tr()}: '
                                    '${_start!.format(context)}',
                        ),
                      ),
                    ),
                    SizedBox(width: width(10)),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(false),
                        child: Text(
                          _end == null
                              ? LK.sellerWorkingHoursEnd.tr()
                              : '${LK.sellerWorkingHoursEnd.tr()}: '
                                    '${_end!.format(context)}',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(20)),
                AuthButton(
                  text: loading
                      ? LK.commonSaving.tr()
                      : LK.adminSaveStoreInfo.tr(),
                  onTap: loading ? null : () => _saveInfo(store.id),
                  widthButton: double.infinity,
                  heightButton: height(54),
                ),
                SizedBox(height: height(20)),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Store facts that were fixed when the account was created.
///
/// The update endpoint does not accept these, so they are shown as plain
/// text with a note rather than as disabled inputs that look editable.
class _ReadOnlyBlock extends StatelessWidget {
  const _ReadOnlyBlock({required this.store});

  final StoreDetailModel store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(width(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade600),
              SizedBox(width: width(6)),
              Expanded(
                child: Text(
                  LK.storeProfileReadonlyNote.tr(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height(10)),
          _Fact(label: LK.authEmail.tr(), value: store.storeEmail),
          _Fact(label: LK.ordersStatus.tr(), value: store.storeStatus),
          _Fact(
            label: LK.superadminSubmittedAt.tr(),
            value: _day(store.createdAt),
          ),
        ],
      ),
    );
  }
}

/// National ID (both sides) and the trade licence, from
/// `StoreRequest/GetFilesByStore/{storeId}`. Read-only: replacing them means
/// filing a new request, so there is nothing to edit here.
class _DocumentsBlock extends StatelessWidget {
  const _DocumentsBlock({required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LK.storeProfileDocuments.tr(),
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: height(10)),
        BlocBuilder<StoreRequestBloc, StoreRequestState>(
          buildWhen: (p, c) =>
              p.storeRequestFiles != c.storeRequestFiles ||
              p.getStoreRequestFilesStatus != c.getStoreRequestFilesStatus,
          builder: (context, state) {
            if (state.getStoreRequestFilesStatus ==
                GetStoreRequestFilesStatus.loading) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: height(16)),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            final files = state.storeRequestFiles;
            final entries = <String, String?>{
              LK.sellerNationalIdFront.tr(): files?.nationalIdFrontImage,
              LK.sellerNationalIdBack.tr(): files?.nationalIdBackImage,
              LK.sellerLicense.tr(): files?.storeLicenseImage,
            }..removeWhere((_, url) => (url ?? '').isEmpty);

            if (entries.isEmpty) {
              return Text(
                LK.storeProfileNoDocuments.tr(),
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
              );
            }
            return Column(
              children: entries.entries
                  .map((e) => _Document(label: e.key, url: e.value!))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _Document extends StatelessWidget {
  const _Document({required this.label, required this.url});

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    final resolved = ApiService.resolveUrl(url) ?? '';
    return Padding(
      padding: EdgeInsets.only(bottom: height(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: height(6)),
          GestureDetector(
            // An ID card and a trade licence are documents - the numbers and
            // small print on them are unreadable at strip height, so tapping
            // opens the same zoomable viewer the product photos use.
            onTap: resolved.isEmpty
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImageViewerPage(
                        imageUrl: resolved,
                        heroTag: 'store-document-$resolved',
                      ),
                    ),
                  ),
            child: Hero(
              tag: 'store-document-$resolved',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: resolved,
                  height: height(160),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: height(160),
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height(3)),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
          SizedBox(width: width(10)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

String _day(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
