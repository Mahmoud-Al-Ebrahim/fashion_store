import 'package:flutter/material.dart';

import '../../../core/constants/product_enums.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/color_utils.dart';
import '../../../models/clothing_item/clothing_item_model.dart';

/// Horizontal row of colour swatches for a product. Selecting one tells the
/// details page to swap the hero image and reload the size list.
///
/// `ClothingItem/GetAll` doesn't return a hex code, so the swatch colour is
/// resolved from the colour name via [hexForColorName]; unknown colours fall
/// back to a neutral chip showing the colour name as text.
class ColorSelector extends StatelessWidget {
  final List<ClothingItemModel> items;
  final int? selectedClothingItemId;
  final ValueChanged<ClothingItemModel> onSelected;

  const ColorSelector({
    super.key,
    required this.items,
    required this.selectedClothingItemId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: height(74),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: width(12)),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.id == selectedClothingItemId;
          final hex = hexForColorName(item.color);
          final swatchColor = parseHexColor(hex, fallback: const Color(0xFFEAEAF2));
          final label = localizedColorName(item.color);

          return GestureDetector(
            onTap: () => onSelected(item),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: width(40),
                  height: width(40),
                  decoration: BoxDecoration(
                    color: swatchColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? primary : Colors.black26,
                      width: selected ? 3 : 1,
                    ),
                  ),
                  // Unknown colour names have no swatch colour - show an
                  // initial so the option is still distinguishable.
                  child: hex == null
                      ? Center(
                          child: Text(
                            label.isNotEmpty ? label.characters.first : '?',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(height: height(4)),
                SizedBox(
                  width: width(52),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected ? primary : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
