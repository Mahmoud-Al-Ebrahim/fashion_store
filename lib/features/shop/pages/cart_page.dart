import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/cart_bloc/cart_bloc.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import 'product_by_id_page.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/cart/cart_item_model.dart';
import '../../admin/widgets/confirm_dialog.dart';
import '../widgets/price_tag.dart';

/// Shopping cart + checkout. Quantity edits and removals hit the Cart
/// endpoints; "checkout" posts `Order/AddCheckout` with a delivery address.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.cartTitle.tr()),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listenWhen: (p, c) =>
                p.deleteCartItemsStatus != c.deleteCartItemsStatus,
            listener: (context, state) {
              if (state.deleteCartItemsStatus ==
                  DeleteCartItemsStatus.success) {
                showMessage(LK.cartItemRemoved.tr(), hasError: false);
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listenWhen: (p, c) => p.checkoutStatus != c.checkoutStatus,
            listener: (context, state) {
              if (state.checkoutStatus == CheckoutStatus.success) {
                showMessage(LK.cartOrderPlaced.tr(), hasError: false);
                context.read<CartBloc>().add(GetCartItemsEvent());
                Navigator.of(context).pop();
              } else if (state.checkoutStatus == CheckoutStatus.failure) {
                showMessage(state.errorMessage);
              }
            },
          ),
        ],
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final cart = state.cart;
            final items = cart?.items ?? const <CartItemModel>[];
            final loading =
                state.getCartItemsStatus == GetCartItemsStatus.loading;

            return AsyncView(
              isLoading: loading && cart == null,
              // A 404 from the cart endpoint just means "no cart yet".
              isFailure: false,
              isEmpty: !loading && items.isEmpty,
              emptyText: LK.cartEmpty.tr(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(width(16)),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => SizedBox(height: height(12)),
                      itemBuilder: (context, index) =>
                          _CartTile(item: items[index]),
                    ),
                  ),
                  _CheckoutBar(total: cart?.totalPrice ?? 0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItemModel item;

  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      // The line only knows the product id, so the details screen is
      // reached through the resolver.
      onTap: () => openProductById(context, item.productId),
      child: Container(
        padding: EdgeInsets.all(width(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD3D3E4)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: ApiService.resolveUrl(item.productImage) ?? '',
                width: width(70),
                height: width(70),
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: const Color(0xFFEAEAF2)),
                errorWidget: (_, __, ___) => Container(
                  color: const Color(0xFFEAEAF2),
                  child: const Icon(Icons.checkroom, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: width(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: parseHexColor(item.colorHexCode),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      SizedBox(width: width(6)),
                      Text(
                        '${localizedColorName(item.color)} • ${sizeLabel(item.size)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: height(6)),
                  PriceTag(
                    price: item.price,
                    priceAfterDiscount: item.priceAfterDiscount,
                    hasDiscount: item.priceAfterDiscount < item.price,
                  ),
                  SizedBox(height: height(6)),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: item.quantity <= 1
                            ? null
                            : () => context.read<CartBloc>().add(
                                UpdateCartItemEvent(
                                  cartItemId: item.cartItemId,
                                  quantity: item.quantity - 1,
                                ),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width(12)),
                        child: Text('${item.quantity}'),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () => context.read<CartBloc>().add(
                          UpdateCartItemEvent(
                            cartItemId: item.cartItemId,
                            quantity: item.quantity + 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final confirmed = await confirmDialog(
                            context,
                            title: LK.cartRemoveItem.tr(),
                            message: LK.cartRemoveConfirm.tr(),
                          );
                          if (!confirmed || !context.mounted) return;
                          context.read<CartBloc>().add(
                            DeleteCartItemsEvent(
                              cartItemIds: [item.cartItemId],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: onTap == null ? Colors.black12 : Colors.black26,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap == null ? Colors.black26 : null,
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatefulWidget {
  final double total;

  const _CheckoutBar({required this.total});

  @override
  State<_CheckoutBar> createState() => _CheckoutBarState();
}

class _CheckoutBarState extends State<_CheckoutBar> {
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _checkout() {
    if (_addressController.text.trim().isEmpty) {
      showMessage(LK.cartAddressRequired.tr());
      return;
    }
    context.read<OrderBloc>().add(
      CheckoutEvent(address: _addressController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width(16),
        vertical: height(14),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthTextField(
            controller: _addressController,
            hintText: LK.cartAddressHint.tr(),
            validator: (_) => null,
          ),
          SizedBox(height: height(12)),
          // Itemised so the customer can see exactly what they are paying
          // for. Delivery is free today, and saying so explicitly is worth
          // more than leaving it out - an unexplained gap between the item
          // prices and the total is what makes people abandon a cart.
          Container(
            padding: EdgeInsets.all(width(12)),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  LK.cartOrderSummary.tr(),
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: height(8)),
                _SummaryRow(
                  label: LK.cartSubtotal.tr(),
                  value:
                      '${formatPrice(widget.total)} ${LK.commonCurrency.tr()}',
                ),
                SizedBox(height: height(6)),
                _SummaryRow(
                  label: LK.cartDelivery.tr(),
                  value: LK.cartDeliveryFree.tr(),
                  valueColor: Colors.green,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height(8)),
                  child: const Divider(height: 1),
                ),
                _SummaryRow(
                  label: LK.cartTotal.tr(),
                  value:
                      '${formatPrice(widget.total)} ${LK.commonCurrency.tr()}',
                  emphasise: true,
                ),
              ],
            ),
          ),
          SizedBox(height: height(10)),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final loading = state.checkoutStatus == CheckoutStatus.loading;
              return AuthButton(
                text: loading ? LK.commonLoading.tr() : LK.cartCheckout.tr(),
                onTap: loading ? null : _checkout,
                widthButton: double.infinity,
                heightButton: height(52),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// One line of the cart summary.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasise
        ? theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? theme.colorScheme.primary,
          )
        : theme.textTheme.bodyMedium!.copyWith(color: valueColor);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: emphasise
              ? theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                )
              : theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
        ),
        Text(value, style: style),
      ],
    );
  }
}
