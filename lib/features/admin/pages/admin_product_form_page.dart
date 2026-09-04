import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/category_bloc/category_bloc.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/admin/product_dashboard_model.dart';
import '../../../core/constants/product_enums.dart';
import '../widgets/image_pick_box.dart';
import '../widgets/option_picker_field.dart';
import '../../../core/localization/translation_keys.dart';

/// Add/Edit product form. Pass [existingProduct] to edit - per the API, only
/// price/category/discount/image are editable on an existing product, so
/// name/description/season/gender/type are shown read-only in edit mode.
class AdminProductFormPage extends StatefulWidget {
  final ProductDashboardItemModel? existingProduct;

  const AdminProductFormPage({super.key, this.existingProduct});

  @override
  State<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends State<AdminProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;

  String? _gender;
  String? _season;
  String? _type;
  String? _occasion;
  int? _categoryId;
  String? _categoryLabel;
  File? _image;
  bool _hasDiscount = false;
  DateTime? _discountStart;
  DateTime? _discountEnd;

  bool get _isEdit => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(
      text: p == null ? '' : p.price.toString(),
    );
    _discountController = TextEditingController(
      text: p?.discountPercentage?.toString() ?? '',
    );
    _categoryId = p?.categoryId;
    _hasDiscount = p?.discountPercentage != null;
    _discountStart = p?.discountStartDate;
    _discountEnd = p?.discountEndDate;
    context.read<CategoryBloc>().add(GetAllCategoriesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await HelperFunctions.pickImage();
    if (file != null) setState(() => _image = File(file.path));
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _discountStart = picked;
      } else {
        _discountEnd = picked;
      }
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoryId == null) {
      showMessage(LK.adminCategoryRequired.tr());
      return;
    }
    if (!_isEdit) {
      if (_gender == null ||
          _season == null ||
          _type == null ||
          _occasion == null) {
        showMessage(LK.adminCompleteFields.tr());
        return;
      }
      if (_image == null) {
        showMessage(LK.adminImageRequired.tr());
        return;
      }
    }
    if (_hasDiscount && (_discountStart == null || _discountEnd == null)) {
      showMessage(LK.adminDiscountDatesRequired.tr());
      return;
    }

    final discountPercentage =
        _hasDiscount && _discountController.text.isNotEmpty
        ? double.tryParse(_discountController.text)
        : null;

    if (_isEdit) {
      context.read<ProductBloc>().add(
        UpdateProductEvent(
          productId: widget.existingProduct!.id,
          name: _nameController.text,
          desc: _descriptionController.text,
          price: double.tryParse(_priceController.text),
          categoryId: _categoryId,
          discountPercentage: discountPercentage,
          discountStartDate: _hasDiscount ? _discountStart : null,
          discountEndDate: _hasDiscount ? _discountEnd : null,
          image: _image,
        ),
      );
    } else {
      context.read<ProductBloc>().add(
        AddProductEvent(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.tryParse(_priceController.text) ?? 0,
          season: _season!,
          gender: _gender!,
          type: _type!,
          occasion: _occasion!,
          image: _image!,
          categoryId: _categoryId!,
          discountPercentage: discountPercentage,
          discountStartDate: _hasDiscount ? _discountStart : null,
          discountEndDate: _hasDiscount ? _discountEnd : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _isEdit ? LK.adminEditProduct.tr() : LK.adminAddProduct.tr(),
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listenWhen: (p, c) =>
            p.productTransactionStatus != c.productTransactionStatus,
        listener: (context, state) {
          if (state.productTransactionStatus ==
              ProductTransactionStatus.success) {
            showMessage(
              _isEdit ? LK.adminProductUpdated.tr() : LK.adminProductAdded.tr(),
              hasError: false,
            );
            Navigator.of(context).pop(true);
          } else if (state.productTransactionStatus ==
              ProductTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width(16)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ImagePickBox(
                  pickedFile: _image,
                  existingImageUrl: widget.existingProduct?.image,
                  label: LK.adminProductImage.tr(),
                  onTap: _pickImage,
                  boxHeight: height(180),
                ),
                SizedBox(height: height(16)),
                AuthTextField(
                  controller: _nameController,
                  labelText: LK.adminProductName.tr(),
                  hintText: LK.adminProductName.tr(),
                  // `Product/UpdateProduct` silently discards Name and
                  // Description - it answers 200 and changes nothing
                  // (verified against the server). The explanatory banner
                  // was dropped as requested, so the fields are disabled
                  // instead: without either, an owner would retype a name,
                  // be told it saved, and lose the edit.
                  validator: (v) {
                    // if (_isEdit) return null;
                    if (v == null || v.trim().isEmpty)
                      return LK.commonRequiredField.tr();
                    return null;
                  },
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _descriptionController,
                  labelText: LK.adminProductDescription.tr(),
                  hintText: LK.adminProductDescription.tr(),
                  maxLines: 4,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return LK.commonRequiredField.tr();
                    return null;
                  },
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _priceController,
                  labelText: LK.adminProductPrice.tr(),
                  hintText: LK.adminProductPrice.tr(),
                  // Digits and a decimal separator only - the value is
                  // parsed with double.tryParse before it is sent, and a
                  // stray letter used to fail validation after the fact.
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return LK.commonRequiredField.tr();
                    }
                    if (double.tryParse(v) == null) {
                      return LK.commonInvalidValue.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: height(10)),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    final options = state.categories
                        .map((c) => PickerOption(c.id.toString(), c.name))
                        .toList();
                    _categoryLabel ??= options
                        .where((o) => o.value == _categoryId?.toString())
                        .map((o) => o.label)
                        .firstOrNull;
                    return OptionPickerField(
                      hintText: LK.adminCategory.tr(),
                      options: options,
                      selectedValue: _categoryId?.toString(),
                      onSelected: (o) => setState(() {
                        _categoryId = int.parse(o.value);
                        _categoryLabel = o.label;
                      }),
                      validator: (_) => _categoryId == null
                          ? LK.adminCategoryRequired.tr()
                          : null,
                    );
                  },
                ),
                if (!_isEdit) ...[
                  SizedBox(height: height(10)),
                  OptionPickerField(
                    hintText: LK.adminGenderTarget.tr(),
                    options: genderOptions(),
                    selectedValue: _gender,
                    onSelected: (o) => setState(() => _gender = o.value),
                    validator: (_) =>
                        _gender == null ? LK.commonRequiredField.tr() : null,
                  ),
                  SizedBox(height: height(10)),
                  OptionPickerField(
                    hintText: LK.adminSeason.tr(),
                    options: seasonOptions(),
                    selectedValue: _season,
                    onSelected: (o) => setState(() => _season = o.value),
                    validator: (_) =>
                        _season == null ? LK.commonRequiredField.tr() : null,
                  ),
                  SizedBox(height: height(10)),
                  OptionPickerField(
                    hintText: LK.adminClothingType.tr(),
                    options: typeOptions(),
                    selectedValue: _type,
                    onSelected: (o) => setState(() => _type = o.value),
                    validator: (_) =>
                        _type == null ? LK.commonRequiredField.tr() : null,
                  ),
                  SizedBox(height: height(10)),
                  // `Occasion` is required by Product/AddProduct - without it
                  // the request is rejected. Like gender/season/type it is
                  // set once at creation: UpdateProduct takes no occasion.
                  OptionPickerField(
                    hintText: LK.adminOccasion.tr(),
                    options: occasionOptions(),
                    selectedValue: _occasion,
                    onSelected: (o) => setState(() => _occasion = o.value),
                    validator: (_) =>
                        _occasion == null ? LK.commonRequiredField.tr() : null,
                  ),
                ],
                SizedBox(height: height(10)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(LK.adminEnableDiscount.tr()),
                  value: _hasDiscount,
                  onChanged: (v) => setState(() => _hasDiscount = v),
                ),
                if (_hasDiscount) ...[
                  AuthTextField(
                    controller: _discountController,
                    labelText: LK.adminDiscountPercentage.tr(),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    hintText: LK.adminDiscountPercentage.tr(),
                    validator: (v) {
                      if (!_hasDiscount) return null;
                      if (v == null || v.isEmpty)
                        return LK.commonRequiredField.tr();
                      if (double.tryParse(v) == null)
                        return LK.commonInvalidValue.tr();
                      return null;
                    },
                  ),
                  SizedBox(height: height(10)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(true),
                          child: Text(
                            _discountStart == null
                                ? LK.adminStartDate.tr()
                                : '${_discountStart!.year}-${_discountStart!.month}-${_discountStart!.day}',
                          ),
                        ),
                      ),
                      SizedBox(width: width(10)),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(false),
                          child: Text(
                            _discountEnd == null
                                ? LK.adminEndDate.tr()
                                : '${_discountEnd!.year}-${_discountEnd!.month}-${_discountEnd!.day}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: height(24)),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    final loading =
                        state.productTransactionStatus ==
                        ProductTransactionStatus.loading;
                    return AuthButton(
                      text: loading ? LK.commonSaving.tr() : LK.commonSave.tr(),
                      onTap: loading ? null : _submit,
                      widthButton: double.infinity,
                      heightButton: height(56),
                    );
                  },
                ),
                SizedBox(height: height(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
