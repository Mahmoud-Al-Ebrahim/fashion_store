/// Item of `GET Order/GetAllOrder` -> `data`.
class OrderSummaryModel {
  final int id;
  final String address;
  final double totalPrice;
  final DateTime createdAt;
  final String status; // enOrderStatus: Processing|Cancelled|Delivered

  OrderSummaryModel({
    required this.id,
    required this.address,
    required this.totalPrice,
    required this.createdAt,
    required this.status,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      id: json['id'] as int,
      address: json['address']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      status: json['status']?.toString() ?? '',
    );
  }
}

List<OrderSummaryModel> orderSummaryListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => OrderSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();

/// The `order` object nested inside `POST Order/AddCheckout` and
/// `PUT Order/CancelOrder` responses.
class OrderDetailModel {
  final int id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String address;
  final double totalPrice;
  final DateTime createdAt;
  final String status;

  OrderDetailModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.totalPrice,
    required this.createdAt,
    required this.status,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'] as int,
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      status: json['status']?.toString() ?? '',
    );
  }
}

/// Item of `GET Order/GetOrderItems/{orderId}` -> `data`, and of the `items`
/// array inside `POST Order/AddCheckout` -> `data`.
class OrderItemModel {
  final int id;
  final int orderId;
  final String userId;
  final int productId;
  final int quantity;
  final String size;
  final String color;
  final String colorHex;
  final double price;
  final String image;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.size,
    required this.color,
    required this.colorHex,
    required this.price,
    required this.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      userId: json['userId']?.toString() ?? '',
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      size: json['size']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      colorHex: json['colorHex']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image']?.toString() ?? '',
    );
  }
}

List<OrderItemModel> orderItemListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

/// Response model for `POST Order/AddCheckout` -> `data`.
class CheckoutResultModel {
  final OrderDetailModel order;
  final List<OrderItemModel> items;
  final PaymentModel payment;

  CheckoutResultModel({
    required this.order,
    required this.items,
    required this.payment,
  });

  factory CheckoutResultModel.fromJson(Map<String, dynamic> json) {
    return CheckoutResultModel(
      order: OrderDetailModel.fromJson(json['order'] as Map<String, dynamic>),
      items: orderItemListFromJson(json['items'] ?? []),
      payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }
}

/// Response model for `PUT Order/CancelOrder` -> `data`.
class CancelOrderResultModel {
  final OrderDetailModel order;
  final PaymentModel payment;

  CancelOrderResultModel({required this.order, required this.payment});

  factory CancelOrderResultModel.fromJson(Map<String, dynamic> json) {
    return CancelOrderResultModel(
      order: OrderDetailModel.fromJson(json['order'] as Map<String, dynamic>),
      payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }
}

/// Response model for `GET Payment/GetPayment` -> `data`, also nested inside
/// checkout/cancel results.
class PaymentModel {
  final int id;
  final String walletId;
  final int orderId;
  final double amount;
  final DateTime date;
  final String status; // e.g. Paid | Cancelled

  PaymentModel({
    required this.id,
    required this.walletId,
    required this.orderId,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      walletId: json['walletId'].toString(),
      orderId: json['orderId'] as int,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'].toString()),
      status: json['status']?.toString() ?? '',
    );
  }
}
