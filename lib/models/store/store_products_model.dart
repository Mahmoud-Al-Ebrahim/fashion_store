// To parse this JSON data, do
//
//     final storeProductsModel = storeProductsModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ui';

import '../posts_response_model.dart';

StoreProductsModel storeProductsModelFromJson(String str) =>
    StoreProductsModel.fromJson(json.decode(str));

String storeProductsModelToJson(StoreProductsModel data) =>
    json.encode(data.toJson());

class StoreProductsModel {
  final List<Product>? products;

  StoreProductsModel({this.products});

  StoreProductsModel copyWith({List<Product>? products}) {
    return StoreProductsModel(products: products ?? this.products);
  }

  factory StoreProductsModel.fromJson(Map<String, dynamic> json) =>
      StoreProductsModel(
        products: json["products"] == null
            ? []
            : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final String? preparationTime;
  final Store? store;
  final Category? category;
  final bool? isLiked;

  final List<String> sizes;
  final List<Color> colors;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.preparationTime,
    this.store,
    this.category,

    this.isLiked,
    required this.sizes,
    required this.colors,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? preparationTime,
    Store? store,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? sizes,
    List<Color>? colors,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    imageUrl: imageUrl ?? this.imageUrl,
    preparationTime: preparationTime ?? this.preparationTime,
    store: store ?? this.store,
    category: category ?? this.category,
    sizes: sizes ?? this.sizes,
    colors: colors ?? this.colors,
  );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: (json["price"] as num?)?.toDouble(),
    imageUrl: json["image"],
    preparationTime: json["duration"],
    store: json["store"] == null
        ? null
        : Store.fromJson(json["store"]),
    category: json["category"] == null
        ? null
        : Category.fromJson(json["category"]),
    isLiked: json["isLiked"],
    sizes: json["sizes"] ?? [],
    colors: json["colors"] == null
        ? []
        : List.from(
            json["colors"].map((item) => Color(int.parse("0x$item"))).toList(),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "image": imageUrl,
    "duration": preparationTime,
    "store": store?.toJson(),
    "category": category?.toJson(),
    "isLiked": isLiked,
    "sizes": sizes,
    "colors": colors.map((item) => item.toString()).toList(),
  };
}

class Category {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;

  Category({this.id, this.name, this.description, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image_url": imageUrl,
  };
}
