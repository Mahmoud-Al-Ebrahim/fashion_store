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
      productId: json['productId'] as int,
      imageUrl: json['imageUrl']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      season: json['season']?.toString() ?? '',
      occasion: json['occasion']?.toString(),
      type: json['type']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      ratingValue: (json['ratingValue'] as num?)?.toDouble() ?? 0,
    );
  }
}

List<SuggestedProductModel> suggestedProductListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => SuggestedProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
