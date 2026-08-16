// To parse this JSON data, do
//
//     final storeUpperModel = storeUpperModelFromJson(jsonString);

import 'dart:convert';

StoreUpperModel storeUpperModelFromJson(String str) => StoreUpperModel.fromJson(json.decode(str));

String storeUpperModelToJson(StoreUpperModel data) => json.encode(data.toJson());

class StoreUpperModel {
  final String? id;
  final String? name;
  final String? profileImage;
  final double? rating;
  final int? followersCount;
  final bool? isFollowed;
  final String? userId;

  StoreUpperModel({
    this.id,
    this.name,
    this.profileImage,
    this.rating,
    this.followersCount,
    this.isFollowed,
    this.userId,
  });

  factory StoreUpperModel.fromJson(Map<String, dynamic> json) => StoreUpperModel(
    id: json["storeId"],
    name: json["name"],
    profileImage: json["profileImage"],
    rating: json["rating"]?.toDouble(),
    followersCount: json["followersCount"],
    isFollowed: json["isFollowed"],
    userId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profileImage": profileImage,
    "rating": rating,
    "followersCount": followersCount,
    "isFollowed": isFollowed,
    "userId": userId,
  };
}
