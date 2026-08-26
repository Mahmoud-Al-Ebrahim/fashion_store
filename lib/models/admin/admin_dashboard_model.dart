import '../../core/utils/json_parse.dart';

/// Response model for `GET Admin/GetDashboardSummary` -> `data`.
class AdminDashboardSummaryModel {
  final int productsCount;
  final int followersCount;
  final int postsCount;
  final int totalReactions;

  AdminDashboardSummaryModel({
    required this.productsCount,
    required this.followersCount,
    required this.postsCount,
    required this.totalReactions,
  });

  factory AdminDashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardSummaryModel(
      productsCount: json['productsCount'] as int,
      followersCount: json['followersCount'] as int,
      postsCount: json['postsCount'] as int,
      totalReactions: json['totalReactions'] as int,
    );
  }
}

/// Response model for `GET Admin/GetDashboardAnalytics` -> `data`.
class AdminDashboardAnalyticsModel {
  final int ordersCount;
  final double totalSales;
  final int customersCount;

  AdminDashboardAnalyticsModel({
    required this.ordersCount,
    required this.totalSales,
    required this.customersCount,
  });

  factory AdminDashboardAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardAnalyticsModel(
      ordersCount: json['ordersCount'] as int,
      totalSales: (json['totalSales'] as num).toDouble(),
      customersCount: json['customersCount'] as int,
    );
  }
}

/// Item of `GET Admin/GetOrdersDetail` -> `data` - per (product, size, color)
/// sales breakdown within the requested date range.
class AdminOrderDetailStatModel {
  final int productId;
  final int numberOfSales;
  final double price;
  final int remainingQuantity;
  final String size;
  final String color;
  final String colorHexCode;

  /// Product image. The endpoint does not send one yet - the backend is
  /// adding it - so several plausible key names are accepted and the UI
  /// falls back to a placeholder while it is still absent.
  final String image;

  AdminOrderDetailStatModel({
    required this.productId,
    required this.numberOfSales,
    required this.price,
    required this.remainingQuantity,
    required this.size,
    required this.color,
    required this.colorHexCode,
    this.image = '',
  });

  factory AdminOrderDetailStatModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderDetailStatModel(
      productId: asInt(json['productId']),
      numberOfSales: asInt(json['numberOfSales']),
      price: asDouble(json['price']),
      remainingQuantity: asInt(json['remainingQuantity']),
      size: asString(json['size']),
      color: asString(json['color']),
      colorHexCode: asString(json['colorHexCode']),
      image: asString(
        json['image'] ?? json['productImage'] ?? json['imageUrl'],
      ),
    );
  }
}

List<AdminOrderDetailStatModel> adminOrderDetailListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map(
          (e) => AdminOrderDetailStatModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();

/// Item of `GET Admin/GetProductInventoryAlert` -> `data` - a (product,
/// color, size) combination that is low on stock.
class InventoryAlertModel {
  final int id;
  final int productId;
  final String color;
  final String size;
  final int quantity;
  final String colorHexCode;

  InventoryAlertModel({
    required this.id,
    required this.productId,
    required this.color,
    required this.size,
    required this.quantity,
    required this.colorHexCode,
  });

  factory InventoryAlertModel.fromJson(Map<String, dynamic> json) {
    return InventoryAlertModel(
      id: json['id'] as int,
      productId: json['productId'] as int,
      color: json['color']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: json['quantity'] as int,
      colorHexCode: json['colorHexCode']?.toString() ?? '',
    );
  }
}

List<InventoryAlertModel> inventoryAlertListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => InventoryAlertModel.fromJson(e as Map<String, dynamic>))
        .toList();
