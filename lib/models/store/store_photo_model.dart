// To parse this JSON data, do
//
//     final storePhotoModel = storePhotoModelFromJson(jsonString);

import 'dart:convert';

StorePhotoModel storePhotoModelFromJson(String str) => StorePhotoModel.fromJson(json.decode(str));

String storePhotoModelToJson(StorePhotoModel data) => json.encode(data.toJson());

class StorePhotoModel {
  final List<Photo>? images;

  StorePhotoModel({
    this.images,
  });

  factory StorePhotoModel.fromJson(Map<String, dynamic> json) => StorePhotoModel(
    images: json["images"] == null ? [] : List<Photo>.from(json["images"]!.map((x) => Photo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class Photo {
  final String? id;
  final String? url;

  Photo({
    this.id,
    this.url,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}
