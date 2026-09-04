import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../blocs/admin_bloc/admin_bloc.dart';
import '../../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/admin/product_dashboard_model.dart';
import '../../../models/clothing_item/clothing_item_model.dart';
import '../../../core/constants/product_enums.dart';
import '../../shop/pages/image_viewer_page.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/image_pick_box.dart';
import 'admin_product_form_page.dart';
import '../../../core/localization/translation_keys.dart';

class AdminProductDetailPage extends StatefulWidget {
  final ProductDashboardItemModel product;

  const AdminProductDetailPage({super.key, required this.product});

  @override
  State<AdminProductDetailPage> createState() => _AdminProductDetailPageState();
}

class _AdminProductDetailPageState extends State<AdminProductDetailPage> {
  late ProductDashboardItemModel _product;

  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    context.read<ClothingItemBloc>().add(
      GetAllClothingItemsEvent(productId: _product.id),
    );
  }

  void _refreshAll() {
    context.read<AdminBloc>().add(
      GetProductDashboardEvent(pageNumber: 1, pageSize: 100),
    );
    context.read<ClothingItemBloc>().add(
      GetAllClothingItemsEvent(productId: _product.id),
    );
  }

  int? _quantityFor(String color, int productSizeId) {
    for (final c in _product.colors) {
      if (c.color != color) continue;
      for (final s in c.sizes) {
        if (s.productSizeId == productSizeId) return s.quantity;
      }
    }
    return null;
  }

  String? _hexFor(String color) {
    for (final c in _product.colors) {
      if (c.color == color) return c.colorHexCode;
    }
    return null;
  }

  Color _parseHex(String? hex) {
    if (hex == null) return Colors.grey;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }

  Future<void> _addColor() async {
    String? selectedName;
    String? selectedHex;
    File? image;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: width(20),
                right: width(20),
                top: height(20),
                bottom:
                    MediaQuery.of(sheetContext).viewInsets.bottom + height(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LK.adminAddColor.tr(),
                    style: Theme.of(sheetContext).textTheme.titleMedium,
                  ),
                  SizedBox(height: height(14)),
                  Wrap(
                    spacing: width(10),
                    runSpacing: height(10),
                    children: kColorSwatches.map((swatch) {
                      final selected = selectedName == swatch.apiName;
                      return GestureDetector(
                        onTap: () => setSheetState(() {
                          selectedName = swatch.apiName;
                          selectedHex = swatch.hex;
                        }),
                        child: Column(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: _parseHex(swatch.hex),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? Theme.of(
                                          sheetContext,
                                        ).colorScheme.primary
                                      : Colors.black26,
                                  width: selected ? 3 : 1,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              swatch.label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: height(16)),
                  ImagePickBox(
                    pickedFile: image,
                    label: LK.adminColorImage.tr(),
                    boxHeight: height(120),
                    onTap: () async {
                      final file = await HelperFunctions.pickImage();
                      if (file != null)
                        setSheetState(() => image = File(file.path));
                    },
                  ),
                  SizedBox(height: height(18)),
                  AuthButton(
                    text: LK.commonAdd.tr(),
                    widthButton: double.infinity,
                    heightButton: height(50),
                    onTap: () {
                      if (selectedName == null || selectedHex == null) {
                        showMessage(LK.adminSelectColorFirst.tr());
                        return;
                      }
                      if (image == null) {
                        showMessage(LK.adminImageRequired.tr());
                        return;
                      }
                      Navigator.of(sheetContext).pop();
                      context.read<ClothingItemBloc>().add(
                        AddColorForProductEvent(
                          productId: _product.id,
                          color: selectedName!,
                          colorHexCode: selectedHex!,
                          image: image!,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addSizes(int productColorId) async {
    final Map<String, TextEditingController> controllers = {};
    final Set<String> selected = {};
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height(16)),
                      Text(
                        LK.adminAddSizes.tr(),
                        style: Theme.of(sheetContext).textTheme.titleMedium,
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: allSizeOptions().map((option) {
                            final checked = selected.contains(option.value);
                            controllers.putIfAbsent(
                              option.value,
                              () => TextEditingController(),
                            );
                            return Row(
                              children: [
                                Checkbox(
                                  value: checked,
                                  onChanged: (v) => setSheetState(() {
                                    if (v == true) {
                                      selected.add(option.value);
                                    } else {
                                      selected.remove(option.value);
                                    }
                                  }),
                                ),
                                SizedBox(
                                  width: width(40),
                                  child: Text(option.label),
                                ),
                                if (checked)
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[option.value],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: LK.adminQuantityLabel.tr(),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      AuthButton(
                        text: LK.adminSaveSizes.tr(),
                        widthButton: double.infinity,
                        heightButton: height(50),
                        onTap: () {
                          if (selected.isEmpty) {
                            showMessage(LK.adminSizeRequired.tr());
                            return;
                          }
                          final sizes = selected.map((size) {
                            final qty =
                                int.tryParse(controllers[size]!.text) ?? 0;
                            return (size: size, quantity: qty);
                          }).toList();
                          Navigator.of(sheetContext).pop();
                          context.read<ClothingItemBloc>().add(
                            AddSizesForProductEvent(
                              productColorId: productColorId,
                              sizes: sizes,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: height(16)),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Removes one size from a colour, e.g. dropping Shoe41 from White while
  /// leaving Shoe40 and Shoe42 in place. The colour itself is untouched.
  Future<void> _deleteSize(dynamic size) async {
    final confirmed = await confirmDialog(
      context,
      title: LK.adminDeleteSize.tr(),
      message:
          '${LK.adminDeleteSizeConfirm.tr()}\n'
          '${sizeLabel(size.size as String)}',
    );
    if (!confirmed || !mounted) return;
    context.read<ClothingItemBloc>().add(
      DeleteProductSizeEvent(productSizeId: size.productSizeId as int),
    );
  }

  Future<void> _editSizeQuantity(int productSizeId, int currentQty) async {
    final controller = TextEditingController(text: currentQty.toString());
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LK.adminEditQuantity.tr()),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: LK.adminQuantityLabel.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(LK.commonCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(LK.commonSave.tr()),
          ),
        ],
      ),
    );
    if (result == true) {
      final qty = int.tryParse(controller.text) ?? currentQty;
      context.read<ClothingItemBloc>().add(
        UpdateProductSizeEvent(productSizeId: productSizeId, quantity: qty),
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
          _product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await context.pushPage(
                AdminProductFormPage(existingProduct: _product),
              );
              _refreshAll();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final confirmed = await confirmDialog(
                context,
                title: LK.commonDelete.tr(),
                message:
                    '${LK.adminDeleteProductConfirm.tr()}\n${_product.name}',
              );
              if (!confirmed || !context.mounted) return;
              setState(() => _deleting = true);
              context.read<ProductBloc>().add(
                DeleteProductEvent(productId: _product.id),
              );
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) =>
                p.productTransactionStatus != c.productTransactionStatus,
            listener: (context, state) {
              if (state.productTransactionStatus ==
                  ProductTransactionStatus.success) {
                if (_deleting) {
                  _deleting = false;
                  showMessage(LK.adminProductDeleted.tr(), hasError: false);
                  Navigator.of(context).pop(true);
                }
              } else if (state.productTransactionStatus ==
                  ProductTransactionStatus.failure) {
                showMessage(state.errorMessage);
              }
            },
          ),
          BlocListener<ClothingItemBloc, ClothingItemState>(
            listenWhen: (p, c) =>
                p.clothingItemTransactionStatus !=
                c.clothingItemTransactionStatus,
            listener: (context, state) {
              if (state.clothingItemTransactionStatus ==
                  ClothingItemTransactionStatus.success) {
                showMessage(LK.adminSavedSuccessfully.tr(), hasError: false);
                _refreshAll();
              } else if (state.clothingItemTransactionStatus ==
                  ClothingItemTransactionStatus.failure) {
                showMessage(state.errorMessage);
              }
            },
          ),
          BlocListener<AdminBloc, AdminState>(
            listenWhen: (p, c) => p.productDashboard != c.productDashboard,
            listener: (context, state) {
              final updated = state.productDashboard?.products.where(
                (p) => p.id == _product.id,
              );
              if (updated != null && updated.isNotEmpty) {
                setState(() => _product = updated.first);
              }
            },
          ),
        ],
        child: ListView(
          padding: EdgeInsets.all(width(16)),
          children: [
            GestureDetector(
              // Same full-screen zoom the customer gets - an owner checking
              // a photo they uploaded needs to see it at size too.
              onTap: _product.image.isEmpty
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ImageViewerPage(
                          imageUrl: _product.image,
                          heroTag: 'admin-product-${_product.id}',
                        ),
                      ),
                    ),
              child: Hero(
                tag: 'admin-product-${_product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: _product.image,
                    height: height(180),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: height(12)),
            Text(
              _product.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: height(12)),
            Wrap(
              spacing: width(10),
              runSpacing: height(10),
              children: [
                _infoChip(
                  LK.productPrice.tr(),
                  _product.priceAfterDiscount.toStringAsFixed(0),
                ),
                _infoChip(LK.adminTotalStock.tr(), '${_product.totalStock}'),
                _infoChip(LK.adminSalesCount.tr(), '${_product.soldCount}'),
                _infoChip(
                  LK.productRating.tr(),
                  _product.ratingValue.toStringAsFixed(1),
                ),
              ],
            ),
            SizedBox(height: height(20)),

            // ----- stock, broken down the way it is actually sold -----
            _StockBreakdown(product: _product),

            SizedBox(height: height(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LK.adminColorsSizes.tr(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addColor,
                  icon: const Icon(Icons.add),
                  label: Text(LK.adminNewColor.tr()),
                ),
              ],
            ),
            BlocBuilder<ClothingItemBloc, ClothingItemState>(
              builder: (context, state) {
                if (state.getAllClothingItemsStatus ==
                    GetAllClothingItemsStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.clothingItems.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: height(16)),
                    child: Text(LK.adminNoColorsYet.tr()),
                  );
                }
                return Column(
                  children: state.clothingItems
                      .map((item) => _colorCard(context, item))
                      .toList(),
                );
              },
            ),
            SizedBox(height: height(30)),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width(12), vertical: height(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAF2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _colorCard(BuildContext context, ClothingItemModel item) {
    return Container(
      margin: EdgeInsets.only(top: height(12)),
      padding: EdgeInsets.all(width(12)),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD3D3E4)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final file = await HelperFunctions.pickImage();
                  if (file == null || !context.mounted) return;
                  context.read<ClothingItemBloc>().add(
                    UpdateProductColorDetailsEvent(
                      clothingItemId: item.id,
                      color: item.color,
                      image: File(file.path),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: item.image,
                        width: width(50),
                        height: width(50),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: width(10)),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _parseHex(_hexFor(item.color)),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black26),
                ),
              ),
              SizedBox(width: width(6)),
              Text(item.color, style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () async {
                  final confirmed = await confirmDialog(
                    context,
                    title: LK.adminDeleteColor.tr(),
                    message:
                        '${LK.adminDeleteColorConfirm.tr()}\n${localizedColorName(item.color)}',
                  );
                  if (!confirmed || !context.mounted) return;
                  context.read<ClothingItemBloc>().add(
                    DeleteProductColorEvent(productColorId: item.id),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: height(8)),
          Wrap(
            spacing: width(8),
            runSpacing: height(8),
            children: [
              ...item.productSizes.map((size) {
                final qty = _quantityFor(item.color, size.productSizeId);
                // Removing a size used to be long-press only, which nobody
                // could discover. The chip now carries a visible delete
                // affordance; tapping the label still edits the quantity,
                // and long-press keeps working for anyone used to it.
                return Container(
                  padding: EdgeInsets.only(
                    left: width(10),
                    right: width(4),
                    top: height(2),
                    bottom: height(2),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            _editSizeQuantity(size.productSizeId, qty ?? 0),
                        onLongPress: () => _deleteSize(size),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: height(4)),
                          child: Text(
                            qty != null ? '${size.size} ($qty)' : size.size,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: width(2)),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _deleteSize(size),
                        child: Padding(
                          padding: EdgeInsets.all(width(4)),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              ActionChip(
                avatar: const Icon(Icons.add, size: 14),
                label: Text(
                  LK.exploreSize.tr(),
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () => _addSizes(item.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Read-only stock summary: how many units exist for every colour/size
/// combination, plus the product total.
///
/// The editable chips further down the page are for *changing* quantities;
/// this block exists so the owner can see the whole picture at a glance,
/// including which combinations have run out.
class _StockBreakdown extends StatelessWidget {
  const _StockBreakdown({required this.product});

  final ProductDashboardItemModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (product.colors.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(width(12)),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          LK.adminStockNone.tr(),
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(width(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: width(6)),
              Expanded(
                child: Text(
                  LK.adminStockBreakdown.tr(),
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${LK.adminStockTotal.tr()}: ${product.totalStock}',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: height(10)),
          ...product.colors.map((colour) {
            final colourTotal = colour.sizes.fold<int>(
              0,
              (sum, size) => sum + size.quantity,
            );
            return Padding(
              padding: EdgeInsets.only(bottom: height(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: width(14),
                        height: width(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _hex(colour.colorHexCode),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      SizedBox(width: width(6)),
                      Expanded(
                        child: Text(
                          localizedColorName(colour.color),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '$colourTotal',
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colourTotal == 0
                              ? Colors.red
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(6)),
                  if (colour.sizes.isEmpty)
                    Text(
                      LK.adminStockNone.tr(),
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    )
                  else
                    Wrap(
                      spacing: width(6),
                      runSpacing: height(6),
                      children: colour.sizes
                          .map((size) => _SizeStockChip(size: size))
                          .toList(),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static Color _hex(String value) {
    var v = value.replaceAll('#', '').trim();
    if (v.length == 6) v = 'FF$v';
    return Color(int.tryParse(v, radix: 16) ?? 0xFF9E9E9E);
  }
}

/// One size chip: label, count, and a colour cue for empty/low stock.
class _SizeStockChip extends StatelessWidget {
  const _SizeStockChip({required this.size});

  final ProductDashboardSizeModel size;

  /// Anything at or below this is flagged, matching the dashboard's own
  /// low-inventory alerts.
  static const int lowThreshold = 3;

  @override
  Widget build(BuildContext context) {
    final out = size.quantity <= 0;
    final low = !out && size.quantity <= lowThreshold;
    final colour = out
        ? Colors.red
        : low
        ? Colors.orange.shade800
        : Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width(10), vertical: height(6)),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colour.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sizeLabel(size.size),
            style: TextStyle(fontSize: 12, color: colour),
          ),
          SizedBox(width: width(5)),
          Text(
            out ? LK.adminStockOut.tr() : '${size.quantity}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colour,
            ),
          ),
          if (low) ...[
            SizedBox(width: width(4)),
            Text(
              '(${LK.adminStockLow.tr()})',
              style: TextStyle(fontSize: 10, color: colour),
            ),
          ],
        ],
      ),
    );
  }
}
