import 'product_size_model.dart';

/// Item of `GET ClothingItem/GetAll/{productId}` -> `data` - a product color
/// variant ("clothing item") together with its available sizes.
class ClothingItemModel {
  final int id;
  final String color;
  final String image;
  final List<ProductSizeModel> productSizes;

  ClothingItemModel({
    required this.id,
    required this.color,
    required this.image,
    required this.productSizes,
  });

  factory ClothingItemModel.fromJson(Map<String, dynamic> json) {
    return ClothingItemModel(
      id: json['id'] as int,
      color: json['color']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      productSizes: productSizeListFromJson(json['productSizes'] ?? []),
    );
  }
}

List<ClothingItemModel> clothingItemListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => ClothingItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

/// Response model for `GET ClothingItem/Get/{clothingItemId}` -> `data`.
class ClothingItemBasicModel {
  final int id;
  final String color;
  final String image;

  ClothingItemBasicModel({
    required this.id,
    required this.color,
    required this.image,
  });

  factory ClothingItemBasicModel.fromJson(Map<String, dynamic> json) {
    return ClothingItemBasicModel(
      id: json['id'] as int,
      color: json['color']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
