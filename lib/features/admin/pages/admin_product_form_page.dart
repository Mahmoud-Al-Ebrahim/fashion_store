import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/category_bloc/category_bloc.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/admin/product_dashboard_model.dart';
import '../admin_enums.dart';
import '../widgets/image_pick_box.dart';
import '../widgets/option_picker_field.dart';

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
      showMessage('يرجى اختيار التصنيف');
      return;
    }
    if (!_isEdit) {
      if (_gender == null || _season == null || _type == null) {
        showMessage('يرجى إكمال كل الحقول');
        return;
      }
      if (_image == null) {
        showMessage('يرجى إضافة صورة للمنتج');
        return;
      }
    }
    if (_hasDiscount && (_discountStart == null || _discountEnd == null)) {
      showMessage('يرجى تحديد تاريخ بداية ونهاية الخصم');
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
        title: Text(_isEdit ? 'تعديل المنتج' : 'إضافة منتج'),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listenWhen: (p, c) => p.productTransactionStatus != c.productTransactionStatus,
        listener: (context, state) {
          if (state.productTransactionStatus == ProductTransactionStatus.success) {
            showMessage(_isEdit ? 'تم تحديث المنتج' : 'تمت إضافة المنتج', hasError: false);
            Navigator.of(context).pop(true);
          } else if (state.productTransactionStatus == ProductTransactionStatus.failure) {
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
                  label: 'إضافة صورة المنتج',
                  onTap: _pickImage,
                  boxHeight: height(180),
                ),
                SizedBox(height: height(16)),
                AuthTextField(
                  controller: _nameController,
                  hintText: 'اسم المنتج',
                  enabled: !_isEdit,
                  validator: (v) {
                    if (_isEdit) return null;
                    if (v == null || v.trim().isEmpty) return 'الاسم مطلوب';
                    return null;
                  },
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _descriptionController,
                  hintText: 'الوصف',
                  maxLines: 4,
                  enabled: !_isEdit,
                  validator: (v) {
                    if (_isEdit) return null;
                    if (v == null || v.trim().isEmpty) return 'الوصف مطلوب';
                    return null;
                  },
                ),
                SizedBox(height: height(10)),
                AuthTextField(
                  controller: _priceController,
                  hintText: 'السعر',
                  formatters: const [],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'السعر مطلوب';
                    if (double.tryParse(v) == null) return 'قيمة غير صالحة';
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
                      hintText: 'التصنيف',
                      options: options,
                      selectedValue: _categoryId?.toString(),
                      onSelected: (o) => setState(() {
                        _categoryId = int.parse(o.value);
                        _categoryLabel = o.label;
                      }),
                      validator: (_) => _categoryId == null ? 'التصنيف مطلوب' : null,
                    );
                  },
                ),
                if (!_isEdit) ...[
                  SizedBox(height: height(10)),
                  OptionPickerField(
                    hintText: 'الجنس المستهدف',
                    options: kGenderOptions,
                    selectedValue: _gender,
                    onSelected: (o) => setState(() => _gender = o.value),
                    validator: (_) => _gender == null ? 'الحقل مطلوب' : null,
                  ),
                  SizedBox(height: height(10)),
                  OptionPickerField(
                    hintText: 'الموسم',
                    options: kSeasonOptions,
                    selectedValue: _season,
                    onSelected: (o) => setState(() => _season = o.value),
                    validator: (_) => _season == null ? 'الحقل مطلوب' : null,
                  ),
                  SizedBox(height: height(10)),
                  OptionPickerField(
                    hintText: 'نوع القطعة',
                    options: kTypeOptions,
                    selectedValue: _type,
                    onSelected: (o) => setState(() => _type = o.value),
                    validator: (_) => _type == null ? 'الحقل مطلوب' : null,
                  ),
                ],
                SizedBox(height: height(10)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تفعيل خصم على المنتج'),
                  value: _hasDiscount,
                  onChanged: (v) => setState(() => _hasDiscount = v),
                ),
                if (_hasDiscount) ...[
                  AuthTextField(
                    controller: _discountController,
                    hintText: 'نسبة الخصم %',
                    validator: (v) {
                      if (!_hasDiscount) return null;
                      if (v == null || v.isEmpty) return 'نسبة الخصم مطلوبة';
                      if (double.tryParse(v) == null) return 'قيمة غير صالحة';
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
                                ? 'تاريخ البداية'
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
                                ? 'تاريخ النهاية'
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
                        state.productTransactionStatus == ProductTransactionStatus.loading;
                    return AuthButton(
                      text: loading ? '...جاري الحفظ' : 'حفظ',
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
