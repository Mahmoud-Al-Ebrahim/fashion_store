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
      productSizeId: json['productSizeId'] as int,
      size: json['size']?.toString() ?? '',
      quantity: json['quantity'] as int?,
      isFoundProduct: json['isFoundProduct'] == true,
    );
  }
}

List<ProductSizeModel> productSizeListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
        .toList();
