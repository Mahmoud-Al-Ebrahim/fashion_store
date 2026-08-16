part of 'order_bloc.dart';

enum GetAllOrdersStatus { init, loading, failure, success }

enum GetOrderItemsStatus { init, loading, failure, success }

enum CheckoutStatus { init, loading, failure, success }

enum CancelOrderStatus { init, loading, failure, success }

enum UpdateOrderStatusStatus { init, loading, failure, success }

enum GetPaymentStatus { init, loading, failure, success }

class OrderState {
  final GetAllOrdersStatus getAllOrdersStatus;
  final GetOrderItemsStatus getOrderItemsStatus;
  final CheckoutStatus checkoutStatus;
  final CancelOrderStatus cancelOrderStatus;
  final UpdateOrderStatusStatus updateOrderStatusStatus;
  final GetPaymentStatus getPaymentStatus;

  final String errorMessage;

  final List<OrderSummaryModel> orders;
  final List<OrderItemModel> orderItems;
  final CheckoutResultModel? checkoutResult;
  final CancelOrderResultModel? cancelResult;
  final PaymentModel? payment;

  OrderState({
    this.getAllOrdersStatus = GetAllOrdersStatus.init,
    this.getOrderItemsStatus = GetOrderItemsStatus.init,
    this.checkoutStatus = CheckoutStatus.init,
    this.cancelOrderStatus = CancelOrderStatus.init,
    this.updateOrderStatusStatus = UpdateOrderStatusStatus.init,
    this.getPaymentStatus = GetPaymentStatus.init,
    this.errorMessage = '',
    this.orders = const [],
    this.orderItems = const [],
    this.checkoutResult,
    this.cancelResult,
    this.payment,
  });

  OrderState copyWith({
    GetAllOrdersStatus? getAllOrdersStatus,
    GetOrderItemsStatus? getOrderItemsStatus,
    CheckoutStatus? checkoutStatus,
    CancelOrderStatus? cancelOrderStatus,
    UpdateOrderStatusStatus? updateOrderStatusStatus,
    GetPaymentStatus? getPaymentStatus,
    String? errorMessage,
    List<OrderSummaryModel>? orders,
    List<OrderItemModel>? orderItems,
    CheckoutResultModel? checkoutResult,
    CancelOrderResultModel? cancelResult,
    PaymentModel? payment,
  }) {
    return OrderState(
      getAllOrdersStatus: getAllOrdersStatus ?? this.getAllOrdersStatus,
      getOrderItemsStatus: getOrderItemsStatus ?? this.getOrderItemsStatus,
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      cancelOrderStatus: cancelOrderStatus ?? this.cancelOrderStatus,
      updateOrderStatusStatus:
          updateOrderStatusStatus ?? this.updateOrderStatusStatus,
      getPaymentStatus: getPaymentStatus ?? this.getPaymentStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      orders: orders ?? this.orders,
      orderItems: orderItems ?? this.orderItems,
      checkoutResult: checkoutResult ?? this.checkoutResult,
      cancelResult: cancelResult ?? this.cancelResult,
      payment: payment ?? this.payment,
    );
  }
}
