/// Item of `GET Category/GetAll` -> `data`, and response model for
/// `POST Category/Add` -> `data`.
class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }
}

List<CategoryModel> categoryListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
    .toList();
