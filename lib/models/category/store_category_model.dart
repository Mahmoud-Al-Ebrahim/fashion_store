/// Item of `GET StoreCategory/GetAllStoreCategoryByAdmin` -> `data`, and
/// response model for `POST StoreCategory/Add` -> `data`.
class StoreCategoryModel {
  final int id;
  final int storeId;
  final int categoryId;
  final DateTime createdAt;

  StoreCategoryModel({
    required this.id,
    required this.storeId,
    required this.categoryId,
    required this.createdAt,
  });

  factory StoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryModel(
      id: json['id'] as int,
      storeId: json['storeId'] as int,
      categoryId: json['categoryId'] as int,
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}

List<StoreCategoryModel> storeCategoryListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => StoreCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
