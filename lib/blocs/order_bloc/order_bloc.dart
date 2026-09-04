import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/order/order_model.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState()) {
    on<GetAllOrdersEvent>(_onGetAllOrdersEvent);
    on<GetOrderItemsEvent>(_onGetOrderItemsEvent);
    on<CheckoutEvent>(_onCheckoutEvent);
    on<CancelOrderEvent>(_onCancelOrderEvent);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatusEvent);
    on<GetPaymentEvent>(_onGetPaymentEvent);
    on<ClearOrderEvent>((event, emit) => emit(OrderState()));
  }

  FutureOr<void> _onGetAllOrdersEvent(
    GetAllOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(getAllOrdersStatus: GetAllOrdersStatus.loading));
    await ApiService.getMethod(endPoint: 'Order/GetAllOrder')
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<OrderSummaryModel>>.fromJson(
                response.data,
                (json) => orderSummaryListFromJson(json),
              );
          emit(
            state.copyWith(
              getAllOrdersStatus: GetAllOrdersStatus.success,
              orders: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllOrdersStatus: GetAllOrdersStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllOrdersStatus: GetAllOrdersStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetOrderItemsEvent(
    GetOrderItemsEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(getOrderItemsStatus: GetOrderItemsStatus.loading));
    await ApiService.getMethod(endPoint: 'Order/GetOrderItems/${event.orderId}')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<OrderItemModel>>.fromJson(
            response.data,
            (json) => orderItemListFromJson(json),
          );
          emit(
            state.copyWith(
              getOrderItemsStatus: GetOrderItemsStatus.success,
              orderItems: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getOrderItemsStatus: GetOrderItemsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getOrderItemsStatus: GetOrderItemsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onCheckoutEvent(
    CheckoutEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(checkoutStatus: CheckoutStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Order/AddCheckout',
          body: {"address": event.address},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<CheckoutResultModel>.fromJson(
            response.data,
            (json) => CheckoutResultModel.fromJson(json),
          );
          add(GetAllOrdersEvent());
          emit(
            state.copyWith(
              checkoutStatus: CheckoutStatus.success,
              checkoutResult: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              checkoutStatus: CheckoutStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              checkoutStatus: CheckoutStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onCancelOrderEvent(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(cancelOrderStatus: CancelOrderStatus.loading));
    await ApiService.putMethod(
          endPoint: 'Order/CancelOrder',
          queryParameters: {"orderId": event.orderId.toString()},
          body: const {},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<CancelOrderResultModel>.fromJson(
            response.data,
            (json) => CancelOrderResultModel.fromJson(json),
          );
          add(GetAllOrdersEvent());
          emit(
            state.copyWith(
              cancelOrderStatus: CancelOrderStatus.success,
              cancelResult: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              cancelOrderStatus: CancelOrderStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              cancelOrderStatus: CancelOrderStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateOrderStatusEvent(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(updateOrderStatusStatus: UpdateOrderStatusStatus.loading),
    );
    await ApiService.putMethod(
          endPoint: 'Order/UpdateOrderStatus',
          queryParameters: {"orderId": event.orderId.toString()},
          body: {"status": event.status},
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllOrdersEvent());
          emit(
            state.copyWith(
              updateOrderStatusStatus: UpdateOrderStatusStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              updateOrderStatusStatus: UpdateOrderStatusStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              updateOrderStatusStatus: UpdateOrderStatusStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetPaymentEvent(
    GetPaymentEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(getPaymentStatus: GetPaymentStatus.loading));
    await ApiService.getMethod(
          endPoint: 'Payment/GetPayment',
          queryParameters: {"orderId": event.orderId.toString()},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<PaymentModel>.fromJson(
            response.data,
            (json) => PaymentModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getPaymentStatus: GetPaymentStatus.success,
              payment: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getPaymentStatus: GetPaymentStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getPaymentStatus: GetPaymentStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
