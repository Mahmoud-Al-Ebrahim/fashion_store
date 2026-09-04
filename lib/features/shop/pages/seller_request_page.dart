import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/show_message.dart';
import '../../admin/pages/store_pending_page.dart';
import '../../admin/widgets/image_pick_box.dart';

/// "Open your own store" - submits `StoreRequest/Add` for SuperAdmin review.
/// Location was intentionally dropped from this flow; the API only needs a
/// text address.
class SellerRequestPage extends StatefulWidget {
  const SellerRequestPage({super.key});

  @override
  State<SellerRequestPage> createState() => _SellerRequestPageState();
}

class _SellerRequestPageState extends State<SellerRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  TimeOfDay? _start;
  TimeOfDay? _end;
  File? _logo;
  File? _featured;
  File? _idFront;
  File? _idBack;
  File? _license;

  @override
  void initState() {
    super.initState();
    context.read<StoreRequestBloc>().add(GetAllStoreRequestsByUserEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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

  Future<void> _pick(ValueChanged<File> assign) async {
    final file = await HelperFunctions.pickImage();
    if (file != null) setState(() => assign(File(file.path)));
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_logo == null ||
        _featured == null ||
        _idFront == null ||
        _idBack == null ||
        _license == null) {
      showMessage(LK.sellerImagesRequired.tr());
      return;
    }
    if (_start == null || _end == null) {
      showMessage(LK.commonRequiredField.tr());
      return;
    }
    context.read<StoreRequestBloc>().add(
      AddStoreRequestEvent(
        storeName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        featuredImage: _featured!,
        logo: _logo!,
        workingHoursStart: _formatTime(_start!),
        workingHoursEnd: _formatTime(_end!),
        phoneNumber: normalizeSyrianPhone(_phoneController.text),
        email: _emailController.text.trim(),
        nationalIdFrontImage: _idFront!,
        nationalIdBackImage: _idBack!,
        storeLicense: _license!,
      ),
    );
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty)
      ? LK.commonRequiredField.tr()
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.sellerRequestTitle.tr()),
      ),
      body: BlocConsumer<StoreRequestBloc, StoreRequestState>(
        listenWhen: (p, c) =>
            p.storeRequestTransactionStatus != c.storeRequestTransactionStatus,
        listener: (context, state) {
          if (state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.success) {
            showMessage(LK.sellerSubmitted.tr(), hasError: false);
            // The request now sits with the platform admin - take the user
            // to the waiting screen rather than dropping them back on the
            // form they just submitted.
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const StorePendingPage()),
            );
          } else if (state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final loading =
              state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.loading;
          return SingleChildScrollView(
            padding: EdgeInsets.all(width(16)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ImagePickBox(
                          pickedFile: _logo,
                          label: LK.sellerLogo.tr(),
                          boxHeight: height(110),
                          onTap: () => _pick((f) => _logo = f),
                        ),
                      ),
                      SizedBox(width: width(12)),
                      Expanded(
                        child: ImagePickBox(
                          pickedFile: _featured,
                          label: LK.sellerFeaturedImage.tr(),
                          boxHeight: height(110),
                          onTap: () => _pick((f) => _featured = f),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(14)),
                  AuthTextField(
                    controller: _nameController,
                    hintText: LK.sellerStoreName.tr(),
                    validator: _required,
                  ),
                  SizedBox(height: height(10)),
                  AuthTextField(
                    controller: _descriptionController,
                    hintText: LK.sellerDescription.tr(),
                    maxLines: 3,
                    validator: _required,
                  ),
                  SizedBox(height: height(10)),
                  AuthTextField(
                    controller: _addressController,
                    hintText: LK.sellerAddress.tr(),
                    validator: _required,
                  ),
                  SizedBox(height: height(10)),
                  AuthTextField(
                    controller: _phoneController,
                    hintText: LK.sellerPhone.tr(),
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: validateSyrianPhone,
                  ),
                  SizedBox(height: height(10)),
                  AuthTextField(
                    controller: _emailController,
                    hintText: LK.sellerEmail.tr(),
                    validator: validateEmail,
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
                                : _start!.format(context),
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
                                : _end!.format(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(16)),
                  Row(
                    children: [
                      Expanded(
                        child: ImagePickBox(
                          pickedFile: _idFront,
                          label: LK.sellerNationalIdFront.tr(),
                          boxHeight: height(100),
                          onTap: () => _pick((f) => _idFront = f),
                        ),
                      ),
                      SizedBox(width: width(12)),
                      Expanded(
                        child: ImagePickBox(
                          pickedFile: _idBack,
                          label: LK.sellerNationalIdBack.tr(),
                          boxHeight: height(100),
                          onTap: () => _pick((f) => _idBack = f),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(12)),
                  ImagePickBox(
                    pickedFile: _license,
                    label: LK.sellerLicense.tr(),
                    boxHeight: height(110),
                    onTap: () => _pick((f) => _license = f),
                  ),
                  SizedBox(height: height(22)),
                  AuthButton(
                    text: loading ? LK.commonSaving.tr() : LK.sellerSubmit.tr(),
                    onTap: loading ? null : _submit,
                    widthButton: double.infinity,
                    heightButton: height(54),
                  ),
                  SizedBox(height: height(20)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
