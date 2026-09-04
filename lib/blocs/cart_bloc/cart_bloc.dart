import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/cart/cart_item_model.dart';
import '../../models/common/api_response_model.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddToCartEvent>(_onAddToCartEvent);
    on<UpdateCartItemEvent>(_onUpdateCartItemEvent);
    on<DeleteCartItemsEvent>(_onDeleteCartItemsEvent);
    on<GetCartItemsEvent>(_onGetCartItemsEvent);
    on<ClearCartEvent>((event, emit) => emit(CartState()));
  }

  FutureOr<void> _onAddToCartEvent(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(addToCartStatus: AddToCartStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Cart/AddToCart',
          body: {
            "quantity": event.quantity,
            "productSizeId": event.productSizeId,
          },
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<AddToCartResultModel>.fromJson(
            response.data,
            (json) => AddToCartResultModel.fromJson(json),
          );
          add(GetCartItemsEvent());
          emit(
            state.copyWith(
              addToCartStatus: AddToCartStatus.success,
              lastAddedItem: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              addToCartStatus: AddToCartStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              addToCartStatus: AddToCartStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateCartItemEvent(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(updateCartItemStatus: UpdateCartItemStatus.loading));
    await ApiService.putMethod(
          endPoint: 'Cart/UpdateCartItem',
          queryParameters: {"cartItemId": event.cartItemId.toString()},
          body: {"quantity": event.quantity},
        )
        .then((response) {
          log(response.data.toString());
          add(GetCartItemsEvent());
          emit(
            state.copyWith(updateCartItemStatus: UpdateCartItemStatus.success),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              updateCartItemStatus: UpdateCartItemStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              updateCartItemStatus: UpdateCartItemStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeleteCartItemsEvent(
    DeleteCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(deleteCartItemsStatus: DeleteCartItemsStatus.loading));
    await ApiService.deleteMethod(
          endPoint: 'Cart/DeleteCartItem',
          body: {"cartItemIds": event.cartItemIds},
        )
        .then((response) {
          log(response.data.toString());
          add(GetCartItemsEvent());
          emit(
            state.copyWith(
              deleteCartItemsStatus: DeleteCartItemsStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              deleteCartItemsStatus: DeleteCartItemsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              deleteCartItemsStatus: DeleteCartItemsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetCartItemsEvent(
    GetCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(getCartItemsStatus: GetCartItemsStatus.loading));
    await ApiService.getMethod(endPoint: 'Cart/GetCartItems')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<CartSummaryModel>.fromJson(
            response.data,
            (json) => CartSummaryModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getCartItemsStatus: GetCartItemsStatus.success,
              cart: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          // A 404 here typically just means the cart is empty / not yet created.
          emit(
            state.copyWith(
              getCartItemsStatus: GetCartItemsStatus.failure,
              cart: CartSummaryModel(items: [], totalPrice: 0),
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getCartItemsStatus: GetCartItemsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
