import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../core/constants/product_enums.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../admin/widgets/option_picker_field.dart';

/// Values collected by [ProductFilterSheet] and passed to
/// `ProductBloc.FilterProductsEvent`.
class ProductFilterValues {
  final double? minPrice;
  final double? maxPrice;
  final String? type;
  final String? color;
  final String? size;

  const ProductFilterValues({
    this.minPrice,
    this.maxPrice,
    this.type,
    this.color,
    this.size,
  });

  bool get isEmpty =>
      minPrice == null &&
      maxPrice == null &&
      type == null &&
      color == null &&
      size == null;
}

/// Bottom sheet exposing the filters `Product/GetFilter` supports.
class ProductFilterSheet extends StatefulWidget {
  final ProductFilterValues initial;

  const ProductFilterSheet({super.key, required this.initial});

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  String? _type;
  String? _color;
  String? _size;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.initial.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxController = TextEditingController(
      text: widget.initial.maxPrice?.toStringAsFixed(0) ?? '',
    );
    _type = widget.initial.type;
    _color = widget.initial.color;
    _size = widget.initial.size;
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: width(20),
        right: width(20),
        top: height(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + height(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LK.exploreFilters.tr(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: height(16)),
            Text(LK.explorePriceRange.tr()),
            SizedBox(height: height(8)),
            Row(
              children: [
                Expanded(
                  child: AuthTextField(
                    controller: _minController,
                    hintText: LK.exploreMinPrice.tr(),
                    validator: (_) => null,
                  ),
                ),
                SizedBox(width: width(10)),
                Expanded(
                  child: AuthTextField(
                    controller: _maxController,
                    hintText: LK.exploreMaxPrice.tr(),
                    validator: (_) => null,
                  ),
                ),
              ],
            ),
            SizedBox(height: height(10)),
            OptionPickerField(
              hintText: LK.exploreType.tr(),
              options: typeOptions(),
              selectedValue: _type,
              onSelected: (o) => setState(() => _type = o.value),
            ),
            SizedBox(height: height(10)),
            OptionPickerField(
              hintText: LK.exploreSize.tr(),
              options: allSizeOptions(),
              selectedValue: _size,
              onSelected: (o) => setState(() => _size = o.value),
            ),
            SizedBox(height: height(14)),
            Text(LK.exploreColor.tr()),
            SizedBox(height: height(8)),
            Wrap(
              spacing: width(10),
              runSpacing: height(10),
              children: kColorSwatches.map((swatch) {
                final selected = _color == swatch.apiName;
                return GestureDetector(
                  onTap: () => setState(
                    () => _color = selected ? null : swatch.apiName,
                  ),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: parseHexColor(swatch.hex),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black26,
                        width: selected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: height(22)),
            Row(
              children: [
                Expanded(
                  child: AuthButton(
                    text: LK.exploreClearFilters.tr(),
                    isWhiteBackground: true,
                    heightButton: height(50),
                    widthButton: double.infinity,
                    onTap: () => Navigator.of(context).pop(
                      const ProductFilterValues(),
                    ),
                  ),
                ),
                SizedBox(width: width(10)),
                Expanded(
                  child: AuthButton(
                    text: LK.exploreApplyFilters.tr(),
                    heightButton: height(50),
                    widthButton: double.infinity,
                    onTap: () => Navigator.of(context).pop(
                      ProductFilterValues(
                        minPrice: double.tryParse(_minController.text),
                        maxPrice: double.tryParse(_maxController.text),
                        type: _type,
                        color: _color,
                        size: _size,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
