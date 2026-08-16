// To parse this JSON data, do
//
//     final followStoreModel = followStoreModelFromJson(jsonString);

import 'dart:convert';

FollowStoreModel followStoreModelFromJson(String str) => FollowStoreModel.fromJson(json.decode(str));

String followStoreModelToJson(FollowStoreModel data) => json.encode(data.toJson());

class FollowStoreModel {
  final bool? isFollowing;
  final String? message;

  FollowStoreModel({
    this.isFollowing,
    this.message,
  });

  factory FollowStoreModel.fromJson(Map<String, dynamic> json) => FollowStoreModel(
    isFollowing: json["isFollowing"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isFollowing": isFollowing,
    "message": message,
  };
}
