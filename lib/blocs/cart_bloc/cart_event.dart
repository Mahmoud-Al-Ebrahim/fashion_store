part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

/// POST Cart/AddToCart
class AddToCartEvent extends CartEvent {
  final int productSizeId;
  final int quantity;

  AddToCartEvent({required this.productSizeId, required this.quantity});
}

/// PUT Cart/UpdateCartItem?cartItemId=
class UpdateCartItemEvent extends CartEvent {
  final int cartItemId;
  final int quantity;

  UpdateCartItemEvent({required this.cartItemId, required this.quantity});
}

/// DELETE Cart/DeleteCartItem (bulk delete by ids)
class DeleteCartItemsEvent extends CartEvent {
  final List<int> cartItemIds;

  DeleteCartItemsEvent({required this.cartItemIds});
}

/// GET Cart/GetCartItems
class GetCartItemsEvent extends CartEvent {}
