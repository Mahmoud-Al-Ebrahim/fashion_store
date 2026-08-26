import '../../core/utils/json_parse.dart';

/// Nested size entry inside [ClothingItemModel.productSizes], and item of
/// `GET ClothingItem/GetAllSizeByProductColor` -> `data`.
class ProductSizeModel {
  final int productSizeId;
  final String size; // enSize
  final int? quantity;
  final bool isFoundProduct;

  ProductSizeModel({
    required this.productSizeId,
    required this.size,
    this.quantity,
    required this.isFoundProduct,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      productSizeId: asInt(json['productSizeId']),
      size: asString(json['size']),
      quantity: json['quantity'] as int?,
      isFoundProduct: asBool(json['isFoundProduct']),
    );
  }
}

List<ProductSizeModel> productSizeListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
        .toList();
