/// Response model for `GET Transaction/GetOrderDetailsByPayment/{transactionId}`
/// -> `data`.
///
/// Resolves the order a wallet transaction paid for, so the transaction
/// ledger can show *what* was bought rather than just an amount. Both the
/// Deposit and the matching Withdraw row of a purchase resolve to the same
/// order.
class PaymentOrderDetailsModel {
  final int orderId;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final List<PaymentOrderProductModel> products;

  PaymentOrderDetailsModel({
    required this.orderId,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.products,
  });

  String get customerName => '$userFirstName $userLastName'.trim();

  /// Sum of the line totals - the order's value as the payment recorded it.
  double get total => products.fold<double>(0, (sum, p) => sum + p.totalPrice);

  factory PaymentOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderDetailsModel(
      orderId: (json['orderId'] as num?)?.toInt() ?? 0,
      userId: json['userId']?.toString() ?? '',
      userFirstName: json['userFirstName']?.toString() ?? '',
      userLastName: json['userLastName']?.toString() ?? '',
      products: (json['products'] as List<dynamic>? ?? const [])
          .map(
            (e) => PaymentOrderProductModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

/// One line of the order behind a transaction.
class PaymentOrderProductModel {
  final int productId;
  final int storeId;
  final String storeName;
  final int quantity;
  final String size;
  final String color;
  final String colorHex;
  final double price;
  final String image;
  final double totalPrice;

  PaymentOrderProductModel({
    required this.productId,
    required this.storeId,
    required this.storeName,
    required this.quantity,
    required this.size,
    required this.color,
    required this.colorHex,
    required this.price,
    required this.image,
    required this.totalPrice,
  });

  factory PaymentOrderProductModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderProductModel(
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      storeId: (json['storeId'] as num?)?.toInt() ?? 0,
      storeName: json['storeName']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      size: json['size']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      colorHex: json['colorHex']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['image']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
    );
  }
}
