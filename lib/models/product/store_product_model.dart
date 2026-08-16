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
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as int,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      discountStartDate: json['discountStartDate'] == null
          ? null
          : DateTime.parse(json['discountStartDate'].toString()),
      discountEndDate: json['discountEndDate'] == null
          ? null
          : DateTime.parse(json['discountEndDate'].toString()),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      image: json['image']?.toString() ?? '',
    );
  }
}

List<StoreProductModel> storeProductListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => StoreProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
