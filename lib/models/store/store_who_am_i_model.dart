// To parse this JSON data, do
//
//     final storeWhoAmIModel = storeWhoAmIModelFromJson(jsonString);

import 'dart:convert';

StoreWhoAmIModel storeWhoAmIModelFromJson(String str) => StoreWhoAmIModel.fromJson(json.decode(str));

String storeWhoAmIModelToJson(StoreWhoAmIModel data) => json.encode(data.toJson());

class StoreWhoAmIModel {
  final String? id;
  final String? name;
  final String? description;
  final String? logoUrl;
  final String? mainImage;
  final String? workingHours;
  final Categories? country;
  final Categories? categories;

  StoreWhoAmIModel({
    this.id,
    this.name,
    this.description,
    this.logoUrl,
    this.mainImage,
    this.workingHours,
    this.country,
    this.categories,
  });

  StoreWhoAmIModel copyWith({
    final String? id,
    final String? name,
    final String? description,
    final String? logoUrl,
    final String? mainImage,
    final String? workingHours,
    final Categories? country,
    final Categories? categories,
  }){
    return StoreWhoAmIModel(
        id : id ?? this.id,
      name: name ?? this.name,
      description : description ?? this.description,
      logoUrl : logoUrl ?? this.logoUrl,
      mainImage: mainImage ?? this.mainImage,
      workingHours : workingHours ?? this.workingHours,
      country: country ?? this.country,
      categories : categories ?? this.categories,
    );
  }

  factory StoreWhoAmIModel.fromJson(Map<String, dynamic> json) => StoreWhoAmIModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    logoUrl: json["logoUrl"],
    mainImage: json["mainImage"],
    workingHours: json["workingHours"],
    country: json["country"] == null ? null : Categories.fromJson(json["country"]),
    categories: json["categories"] == null ? null : Categories.fromJson(json["categories"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "logoUrl": logoUrl,
    "mainImage": mainImage,
    "workingHours": workingHours,
    "country": country?.toJson(),
    "categories": categories?.toJson(),
  };
}

class Categories {
  final String? id;
  final String? name;
  final String? image;

  Categories({
    this.id,
    this.name,
    this.image,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    id: json["id"],
    name: json["name"],
    image: json["image"] ?? json['imageUrl'] ?? json['image_url'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}
