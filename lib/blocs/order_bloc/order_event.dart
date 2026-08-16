part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

/// GET Order/GetAllOrder
class GetAllOrdersEvent extends OrderEvent {}

/// GET Order/GetOrderItems/{orderId}
class GetOrderItemsEvent extends OrderEvent {
  final int orderId;

  GetOrderItemsEvent({required this.orderId});
}

/// POST Order/AddCheckout - checks out everything currently in the cart
class CheckoutEvent extends OrderEvent {
  final String address;

  CheckoutEvent({required this.address});
}

/// PUT Order/CancelOrder?orderId=
class CancelOrderEvent extends OrderEvent {
  final int orderId;

  CancelOrderEvent({required this.orderId});
}

/// PUT Order/UpdateOrderStatus?orderId= (store owner)
class UpdateOrderStatusEvent extends OrderEvent {
  final int orderId;
  final String status; // enOrderStatus: Processing|Cancelled|Delivered

  UpdateOrderStatusEvent({required this.orderId, required this.status});
}

/// GET Payment/GetPayment?orderId=
class GetPaymentEvent extends OrderEvent {
  final int orderId;

  GetPaymentEvent({required this.orderId});
}
