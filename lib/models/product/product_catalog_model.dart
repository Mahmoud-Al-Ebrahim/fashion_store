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
      id: json['id'] as int,
      storeId: json['storeId'] as int,
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
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

List<ProductCatalogModel> productCatalogListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => ProductCatalogModel.fromJson(e as Map<String, dynamic>))
        .toList();
