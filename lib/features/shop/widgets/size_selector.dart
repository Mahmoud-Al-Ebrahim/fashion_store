import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/product_enums.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../models/clothing_item/product_size_model.dart';

/// Size chips for the currently selected colour. Sizes the backend reports as
/// unavailable (`isFoundProduct == false`) render disabled.
class SizeSelector extends StatelessWidget {
  final List<ProductSizeModel> sizes;
  final int? selectedProductSizeId;
  final ValueChanged<ProductSizeModel> onSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedProductSizeId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: height(8)),
        child: Text(
          LK.productNoSizes.tr(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    final primary = Theme.of(context).colorScheme.primary;
    return Wrap(
      spacing: width(10),
      runSpacing: height(10),
      children: sizes.map((size) {
        final selected = size.productSizeId == selectedProductSizeId;
        final available = size.isFoundProduct;
        return GestureDetector(
          onTap: available ? () => onSelected(size) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: width(16),
              vertical: height(9),
            ),
            decoration: BoxDecoration(
              color: selected ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: available ? (selected ? primary : Colors.black26) : Colors.black12,
              ),
            ),
            child: Text(
              sizeLabel(size.size),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: !available
                    ? Colors.grey.shade400
                    : selected
                        ? Colors.white
                        : Colors.black87,
                decoration: available ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
