import '../../core/utils/json_parse.dart';

/// Product card shape returned by `GET Store/GetAllProductsByStore`.
class StoreProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final double rating;
  final double? discountPercentage;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final double priceAfterDiscount;
  final String image;

  StoreProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.rating,
    this.discountPercentage,
    this.discountStartDate,
    this.discountEndDate,
    required this.priceAfterDiscount,
    required this.image,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    return StoreProductModel(
      id: asInt(json['id']),
      name: asString(json['name']),
      description: asString(json['description']),
      price: asDouble(json['price']),
      categoryId: asInt(json['categoryId']),
      rating: asDouble(json['rating']),
      discountPercentage: asDoubleOrNull(json['discountPercentage']),
      discountStartDate: asDateOrNull(json['discountStartDate']),
      discountEndDate: asDateOrNull(json['discountEndDate']),
      priceAfterDiscount: asDouble(json['priceAfterDiscount']),
      image: asString(json['image']),
    );
  }
}

List<StoreProductModel> storeProductListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => StoreProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
