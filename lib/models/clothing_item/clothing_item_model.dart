import '../../core/utils/api_service.dart';
import '../../core/utils/json_parse.dart';
import 'product_size_model.dart';

/// Item of `GET ClothingItem/GetAll/{productId}` -> `data` - a product color
/// variant ("clothing item") together with its available sizes.
class ClothingItemModel {
  final int id;
  final String color;

  /// Swatch colour as the API stores it, e.g. `#FFFFFF`.
  ///
  /// Before this was returned the UI had to guess from the colour *name*,
  /// and any name outside the known list fell back to showing its first
  /// letter in a grey circle.
  final String? colorHexCode;
  final String image;
  final List<ProductSizeModel> productSizes;

  ClothingItemModel({
    required this.id,
    required this.color,
    this.colorHexCode,
    required this.image,
    required this.productSizes,
  });

  factory ClothingItemModel.fromJson(Map<String, dynamic> json) {
    return ClothingItemModel(
      id: asInt(json['id']),
      color: asString(json['color']),
      colorHexCode: asStringOrNull(json['colorHexCode']),
      image: ApiService.resolveUrl(asString(json['image'])) ?? '',
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
      id: asInt(json['id']),
      color: asString(json['color']),
      image: ApiService.resolveUrl(asString(json['image'])) ?? '',
    );
  }
}
