/// Nested size entry inside [ProductDashboardColorModel.sizes].
class ProductDashboardSizeModel {
  final int productSizeId;
  final String size;
  final int quantity;
  final bool isFoundProduct;

  ProductDashboardSizeModel({
    required this.productSizeId,
    required this.size,
    required this.quantity,
    required this.isFoundProduct,
  });

  factory ProductDashboardSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductDashboardSizeModel(
      productSizeId: json['productSizeId'] as int,
      size: json['size']?.toString() ?? '',
      quantity: json['quantity'] as int,
      isFoundProduct: json['isFoundProduct'] == true,
    );
  }
}

/// Nested color entry inside [ProductDashboardItemModel.colors].
class ProductDashboardColorModel {
  final String color;
  final String colorHexCode;
  final List<ProductDashboardSizeModel> sizes;

  ProductDashboardColorModel({
    required this.color,
    required this.colorHexCode,
    required this.sizes,
  });

  factory ProductDashboardColorModel.fromJson(Map<String, dynamic> json) {
    return ProductDashboardColorModel(
      color: json['color']?.toString() ?? '',
      colorHexCode: json['colorHexCode']?.toString() ?? '',
      sizes: (json['sizes'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                ProductDashboardSizeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

/// Item of `GET Admin/GetProductDashboard` -> `data.products` - a store
/// owner's product with full color/size/stock/sales breakdown.
class ProductDashboardItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final double ratingValue;
  final double? discountPercentage;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final double priceAfterDiscount;
  final String image;
  final List<ProductDashboardColorModel> colors;
  final int totalStock;
  final int soldCount;
  final double soldTotalPrice;

  ProductDashboardItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.ratingValue,
    this.discountPercentage,
    this.discountStartDate,
    this.discountEndDate,
    required this.priceAfterDiscount,
    required this.image,
    required this.colors,
    required this.totalStock,
    required this.soldCount,
    required this.soldTotalPrice,
  });

  factory ProductDashboardItemModel.fromJson(Map<String, dynamic> json) {
    return ProductDashboardItemModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as int,
      ratingValue: (json['ratingValue'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      discountStartDate: json['discountStartDate'] == null
          ? null
          : DateTime.parse(json['discountStartDate'].toString()),
      discountEndDate: json['discountEndDate'] == null
          ? null
          : DateTime.parse(json['discountEndDate'].toString()),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      image: json['image']?.toString() ?? '',
      colors: (json['colors'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                ProductDashboardColorModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalStock: json['totalStock'] as int,
      soldCount: json['soldCount'] as int,
      soldTotalPrice: (json['soldTotalPrice'] as num).toDouble(),
    );
  }
}

/// Response model for `GET Admin/GetProductDashboard` -> `data`.
class ProductDashboardResultModel {
  final List<ProductDashboardItemModel> products;
  final int totalProductsCount;

  ProductDashboardResultModel({
    required this.products,
    required this.totalProductsCount,
  });

  factory ProductDashboardResultModel.fromJson(Map<String, dynamic> json) {
    return ProductDashboardResultModel(
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                ProductDashboardItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalProductsCount: json['totalProductsCount'] as int,
    );
  }
}
