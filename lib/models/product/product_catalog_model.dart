import '../../core/utils/json_parse.dart';

/// Lightweight product card shape returned by catalog/browse-style endpoints:
/// `GET Product/GetSearch/{query}`, `GET Product/GetFilter`,
/// `GET Product/GetAllDiscountProduct`, `GET StoreFollower/GetProductsByFollowerStores`.
class ProductCatalogModel {
  final int id;
  final int storeId;
  final String name;
  final double price;
  final double? discountPercentage;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final double priceAfterDiscount;
  final String image;

  ProductCatalogModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.price,
    this.discountPercentage,
    this.discountStartDate,
    this.discountEndDate,
    required this.priceAfterDiscount,
    required this.image,
  });

  factory ProductCatalogModel.fromJson(Map<String, dynamic> json) {
    return ProductCatalogModel(
      id: asInt(json['id']),
      storeId: asInt(json['storeId']),
      name: asString(json['name']),
      price: asDouble(json['price']),
      discountPercentage: asDoubleOrNull(json['discountPercentage']),
      discountStartDate: asDateOrNull(json['discountStartDate']),
      discountEndDate: asDateOrNull(json['discountEndDate']),
      priceAfterDiscount: asDouble(json['priceAfterDiscount']),
      image: asString(json['image']),
    );
  }
}

List<ProductCatalogModel> productCatalogListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => ProductCatalogModel.fromJson(e as Map<String, dynamic>))
        .toList();
