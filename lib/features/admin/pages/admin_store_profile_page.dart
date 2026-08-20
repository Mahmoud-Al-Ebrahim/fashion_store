import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/store/store_detail_model.dart';
import '../widgets/image_pick_box.dart';
import '../../../core/localization/translation_keys.dart';

class AdminStoreProfilePage extends StatefulWidget {
  const AdminStoreProfilePage({super.key});

  @override
  State<AdminStoreProfilePage> createState() => _AdminStoreProfilePageState();
}

class _AdminStoreProfilePageState extends State<AdminStoreProfilePage> {
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
        listenWhen: (p, c) => p.storeTransactionStatus != c.storeTransactionStatus,
        listener: (context, state) {
          if (state.storeTransactionStatus == StoreTransactionStatus.success) {
            showMessage(LK.adminSavedSuccessfully.tr(), hasError: false);
            setState(() {
              _newLogo = null;
              _newFeaturedImage = null;
            });
          } else if (state.storeTransactionStatus == StoreTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final store = state.myStore;
          if (store == null) {
            return const Center(child: CircularProgressIndicator());
          }
          _fillFrom(store);
          final loading = state.storeTransactionStatus == StoreTransactionStatus.loading;

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
                          if (file != null) setState(() => _newLogo = File(file.path));
                        },
                      ),
                    ),
                    SizedBox(width: width(12)),
                    Expanded(
                      child: ImagePickBox(
                        pickedFile: _newFeaturedImage,
                        existingImageUrl: ApiService.resolveUrl(store.featuredImage),
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
                AuthTextField(
                  controller: _nameController,
                  hintText: LK.sellerStoreName.tr(),
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _descriptionController,
                  hintText: LK.sellerDescription.tr(),
                  maxLines: 3,
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _addressController,
                  hintText: LK.sellerAddress.tr(),
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _phoneController,
                  hintText: LK.sellerPhone.tr(),
                  validator: (_) => null,
                ),
                SizedBox(height: height(10)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(true),
                        child: Text(_start == null ? LK.sellerWorkingHoursStart.tr() : _start!.format(context)),
                      ),
                    ),
                    SizedBox(width: width(10)),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickTime(false),
                        child: Text(_end == null ? LK.sellerWorkingHoursEnd.tr() : _end!.format(context)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(20)),
                AuthButton(
                  text: loading ? LK.commonSaving.tr() : LK.adminSaveStoreInfo.tr(),
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
