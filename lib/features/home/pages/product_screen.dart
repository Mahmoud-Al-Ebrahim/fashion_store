import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/cart_bloc/cart_bloc.dart';
import '../../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/clothing_item/clothing_item_model.dart';
import '../../../models/clothing_item/product_size_model.dart';
import '../../../models/product/product_ref.dart';
import '../widgets/product/add_to_card_card.dart';
import '../widgets/product/column_layer.dart';
import '../widgets/product/product_image.dart';
import '../widgets/product/return_icon.dart';

/// Product details - the original expanding-sheet layout, wired to
/// `ClothingItemBloc` (colours/sizes) and `CartBloc` (add to cart).
///
/// Selecting a colour swaps the hero image to that colour's photo and
/// reloads the size chips underneath.
class ProductScreen extends StatefulWidget {
  final ProductRef product;

  static String name = "product-screen";
  static String path = "/product-screen";

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isExpanded = false;
  ClothingItemModel? _selectedColor;
  ProductSizeModel? _selectedSize;

  @override
  void initState() {
    super.initState();
    context.read<ClothingItemBloc>().add(
      GetAllClothingItemsEvent(productId: widget.product.id),
    );
  }

  /// The hero image follows the selected colour, falling back to the
  /// product's own cover image before colours have loaded.
  String get _heroImage =>
      _selectedColor?.image.isNotEmpty == true
          ? _selectedColor!.image
          : widget.product.imageUrl;

  double get _unitPrice => widget.product.priceAfterDiscount;

  void _onColorChanged(ClothingItemModel item) {
    setState(() {
      _selectedColor = item;
      // Sizes belong to a colour, so the previous pick no longer applies.
      _selectedSize = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ClothingItemBloc, ClothingItemState>(
            listenWhen: (p, c) => p.clothingItems != c.clothingItems,
            listener: (context, state) {
              if (state.clothingItems.isNotEmpty && _selectedColor == null) {
                setState(() => _selectedColor = state.clothingItems.first);
              }
            },
          ),
          BlocListener<CartBloc, CartState>(
            listenWhen: (p, c) => p.addToCartStatus != c.addToCartStatus,
            listener: (context, state) {
              if (state.addToCartStatus == AddToCartStatus.success) {
                showMessage(LK.productAddedToCart.tr(), hasError: false);
              } else if (state.addToCartStatus == AddToCartStatus.failure) {
                showMessage(state.errorMessage);
              }
            },
          ),
        ],
        child: BlocBuilder<ClothingItemBloc, ClothingItemState>(
          builder: (context, state) {
            return Stack(
              children: [
                ProductImage(
                  imageUrl: ApiService.resolveUrl(_heroImage) ?? '',
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  top: isExpanded ? height(150) : height(390),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ProductColumnLayer(
                    onToggleExpanded: () =>
                        setState(() => isExpanded = !isExpanded),
                      product: widget.product,
                      clothingItems: state.clothingItems,
                      selectedColor: _selectedColor,
                      selectedSize: _selectedSize,
                      onColorChanged: _onColorChanged,
                    onSizeChanged: (size) =>
                        setState(() => _selectedSize = size),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isExpanded ? 0 : 1,
                    curve: Curves.easeOut,
                    child: IgnorePointer(
                      ignoring: isExpanded,
                      child: AddToCardCard(
                        unitPrice: _unitPrice,
                        selectedProductSizeId: _selectedSize?.productSizeId,
                      ),
                    ),
                  ),
                ),
                const ReturnIcon(),
              ],
            );
          },
        ),
      ),
    );
  }
}
