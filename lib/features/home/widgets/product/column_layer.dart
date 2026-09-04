import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../../../blocs/product_bloc/product_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/clothing_item/clothing_item_model.dart';
import '../../../../models/clothing_item/product_size_model.dart';
import '../../../../models/product/product_ref.dart';
import '../../../shop/widgets/color_selector.dart';
import '../../../shop/widgets/product_reviews_section.dart';
import '../../../shop/widgets/suggested_products_section.dart';
import '../../../shop/widgets/size_selector.dart';
import 'des_product_scrooll.dart';
import 'more_detail_about_product.dart';
import 'product_name.dart';
import 'product_store_block.dart';

/// The sliding detail sheet (rounded-44 top corners) - original layout, now
/// fed by `ClothingItemBloc` instead of hard-coded sizes/colours.
///
/// Picking a colour bubbles up through [onColorChanged] so the hero image
/// behind the sheet swaps to that colour's photo.
class ProductColumnLayer extends StatelessWidget {
  final ProductRef product;
  final List<ClothingItemModel> clothingItems;
  final ClothingItemModel? selectedColor;
  final ProductSizeModel? selectedSize;
  final ValueChanged<ClothingItemModel> onColorChanged;
  final ValueChanged<ProductSizeModel> onSizeChanged;

  /// Expands/collapses the sheet. Bound to the grab handle only - tapping
  /// anywhere on the sheet would swallow taps meant for the stars, size
  /// chips and the comment field.
  final VoidCallback onToggleExpanded;

  const ProductColumnLayer({
    super.key,
    required this.product,
    required this.clothingItems,
    required this.selectedColor,
    required this.selectedSize,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(44),
          topRight: Radius.circular(44),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(20),
          vertical: height(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle - the only tap target that toggles the sheet.
              GestureDetector(
                onTap: onToggleExpanded,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Container(
                    width: width(48),
                    height: height(5),
                    margin: EdgeInsets.only(bottom: height(12)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              ProductName(showIngredients: false, productName: product.name),
              SizedBox(height: height(15)),
              // The description either travelled with the product (store
              // screen, dashboard) or was fetched by `ProductScreen` for the
              // catalog paths that omit it.
              BlocBuilder<ProductBloc, ProductState>(
                buildWhen: (p, c) =>
                    p.productDescriptions != c.productDescriptions,
                builder: (context, state) {
                  final description =
                      (product.description ?? '').trim().isNotEmpty
                      ? product.description!.trim()
                      : (state.productDescriptions[product.id] ?? '');
                  if (description.isEmpty) return const SizedBox.shrink();
                  return ContentProductScrollable(
                    title: description,
                    heightScroll: 95,
                  );
                },
              ),
              SizedBox(height: height(30)),
              MoreDetailAboutProduct(product: product),
              SizedBox(height: height(16)),
              // Who sells it, and what that store says about itself.
              ProductStoreBlock(product: product),
              SizedBox(height: height(30)),

              // ----- colours -----
              BlocBuilder<ClothingItemBloc, ClothingItemState>(
                builder: (context, state) {
                  final loading =
                      state.getAllClothingItemsStatus ==
                      GetAllClothingItemsStatus.loading;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LK.productColors.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: height(12)),
                      if (loading)
                        const Center(child: CircularProgressIndicator())
                      else if (clothingItems.isEmpty)
                        Text(
                          LK.productNoColors.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      else
                        ColorSelector(
                          items: clothingItems,
                          selectedClothingItemId: selectedColor?.id,
                          onSelected: onColorChanged,
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: height(24)),

              // ----- sizes for the selected colour -----
              if (clothingItems.isNotEmpty) ...[
                Text(
                  LK.productSizes.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height(12)),
                SizeSelector(
                  sizes: selectedColor?.productSizes ?? const [],
                  selectedProductSizeId: selectedSize?.productSizeId,
                  onSelected: onSizeChanged,
                ),
              ],

              SizedBox(height: height(30)),
              const Divider(),
              SizedBox(height: height(10)),

              // ----- rating + comments (open to every role) -----
              ProductReviewsSection(productId: product.id),

              SizedBox(height: height(24)),

              // ----- similar products -----
              SuggestedProductsSection(productId: product.id),

              SizedBox(height: height(140)),
            ],
          ),
        ),
      ),
    );
  }
}
