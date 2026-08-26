import '../../core/utils/json_parse.dart';

/// Item of `POST ClothingItem/GetSuggestByProductId` -> `data`.
class SuggestedProductModel {
  final int productId;
  final String imageUrl;
  final String name;
  final String color;
  final String gender; // enGender
  final String season; // enSeason
  final String? occasion;
  final String type; // enType
  final double price;
  final double priceAfterDiscount;
  final double ratingValue;

  SuggestedProductModel({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.color,
    required this.gender,
    required this.season,
    this.occasion,
    required this.type,
    required this.price,
    required this.priceAfterDiscount,
    required this.ratingValue,
  });

  factory SuggestedProductModel.fromJson(Map<String, dynamic> json) {
    return SuggestedProductModel(
      productId: asInt(json['productId']),
      imageUrl: asString(json['imageUrl']),
      name: asString(json['name']),
      color: asString(json['color']),
      gender: asString(json['gender']),
      season: asString(json['season']),
      occasion: asStringOrNull(json['occasion']),
      type: asString(json['type']),
      price: asDouble(json['price']),
      priceAfterDiscount: asDouble(json['priceAfterDiscount']),
      ratingValue: asDouble(json['ratingValue']),
    );
  }
}

List<SuggestedProductModel> suggestedProductListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => SuggestedProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
