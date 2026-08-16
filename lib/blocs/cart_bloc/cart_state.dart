part of 'cart_bloc.dart';

enum AddToCartStatus { init, loading, failure, success }

enum UpdateCartItemStatus { init, loading, failure, success }

enum DeleteCartItemsStatus { init, loading, failure, success }

enum GetCartItemsStatus { init, loading, failure, success }

class CartState {
  final AddToCartStatus addToCartStatus;
  final UpdateCartItemStatus updateCartItemStatus;
  final DeleteCartItemsStatus deleteCartItemsStatus;
  final GetCartItemsStatus getCartItemsStatus;

  final String errorMessage;

  final AddToCartResultModel? lastAddedItem;
  final CartSummaryModel? cart;

  CartState({
    this.addToCartStatus = AddToCartStatus.init,
    this.updateCartItemStatus = UpdateCartItemStatus.init,
    this.deleteCartItemsStatus = DeleteCartItemsStatus.init,
    this.getCartItemsStatus = GetCartItemsStatus.init,
    this.errorMessage = '',
    this.lastAddedItem,
    this.cart,
  });

  CartState copyWith({
    AddToCartStatus? addToCartStatus,
    UpdateCartItemStatus? updateCartItemStatus,
    DeleteCartItemsStatus? deleteCartItemsStatus,
    GetCartItemsStatus? getCartItemsStatus,
    String? errorMessage,
    AddToCartResultModel? lastAddedItem,
    CartSummaryModel? cart,
  }) {
    return CartState(
      addToCartStatus: addToCartStatus ?? this.addToCartStatus,
      updateCartItemStatus: updateCartItemStatus ?? this.updateCartItemStatus,
      deleteCartItemsStatus:
          deleteCartItemsStatus ?? this.deleteCartItemsStatus,
      getCartItemsStatus: getCartItemsStatus ?? this.getCartItemsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      lastAddedItem: lastAddedItem ?? this.lastAddedItem,
      cart: cart ?? this.cart,
    );
  }
}
