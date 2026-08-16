import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/store/store_products_model.dart';
import 'des_product_scrooll.dart';
import 'product_name.dart';
import 'more_detail_about_product.dart';

class ProductColumnLayer extends StatefulWidget {
  final Store store;
  final Product product;

  const ProductColumnLayer({
    super.key,
    required this.store,
    required this.product,
  });

  @override
  State<ProductColumnLayer> createState() => _ProductColumnLayerState();
}

class _ProductColumnLayerState extends State<ProductColumnLayer> {
  final ScrollController _scrollController = ScrollController();
  String? selectedSize;
  Color? selectedColor;

  // @override
  // void didUpdateWidget(covariant ProductColumnLayer oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.showIngredients && !oldWidget.showIngredients) {
  //     // بس ينفتح المكونات → اعمل Scroll لتحت
  //     Future.delayed(const Duration(milliseconds: 200), () {
  //       if (_scrollController.hasClients) {
  //         _scrollController.animateTo(
  //           _scrollController.position.maxScrollExtent,
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeInOut,
  //         );
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    selectedSize = widget.product.sizes.firstOrNull;
    selectedColor = widget.product.colors.firstOrNull;
    super.initState();
  }

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
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height(20)),
              ProductName(
                showIngredients: false,
                productName: widget.store.name ?? "___",
              ),
              SizedBox(height: height(15)),
              ContentProductScrollable(
                title: widget.store.description ?? "___",
                heightScroll: 95,
              ),
              SizedBox(height: height(30)),
              MoreDetailAboutProduct(
                product: widget.product,
                store: widget.store,
              ),
              SizedBox(height: height(30)),
              _buildSizeSelector(),

              const SizedBox(height: 24),

              _buildColorSelector(),

              const SizedBox(height: 24),
              // if (!widget.showIngredients) ...[
              //   Align(
              //     alignment: Alignment.topRight,
              //     child: Text(
              //       "المكونات",
              //       style: Theme.of(context).textTheme.labelLarge!.copyWith(
              //         color: Theme.of(context).colorScheme.onSurface,
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ),
              //   ),
              //   SizedBox(height: height(15)),
              //   const IngredientsProduct(),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Size",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.product.sizes.map((size) {
            final isSelected = selectedSize == size;

            return ChoiceChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedSize = size;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Color",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.product.colors.map((color) {
            final isSelected = selectedColor == color;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
