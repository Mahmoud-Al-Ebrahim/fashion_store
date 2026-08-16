// To parse this JSON data, do
//
//     final storeReviewModel = storeReviewModelFromJson(jsonString);

import 'dart:convert';

StoreReviewModel storeReviewModelFromJson(String str) => StoreReviewModel.fromJson(json.decode(str));

String storeReviewModelToJson(StoreReviewModel data) => json.encode(data.toJson());

class StoreReviewModel {
  final double? avgRating;
  final int? totalReviewers;
  final List<Review>? reviews;

  StoreReviewModel({
    this.avgRating,
    this.totalReviewers,
    this.reviews,
  });

  factory StoreReviewModel.fromJson(Map<String, dynamic> json) => StoreReviewModel(
    avgRating: json["avgRating"]?.toDouble(),
    totalReviewers: json["totalReviewers"],
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "avgRating": avgRating,
    "totalReviewers": totalReviewers,
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class Review {
  final String? id;
  final double? score;
  final String? comment;
  final User? user;
  final String ? image;
  final String ?timeAgo;

  Review({
    this.id,
    this.score,
    this.comment,
    this.user,
    this.timeAgo,
    this.image
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    score: json["score"] == null ? null : (json["score"] as num).toDouble(),
    comment: json["comment"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    image: json["image"],
    timeAgo: json["timeAgo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "score": score,
    "comment": comment,
    "user": user?.toJson(),
    "image": image,
    "timeAgo": timeAgo
  };
}

class User {
  final String? id;
  final String? name;
  final String? profilePicture;

  User({
    this.id,
    this.name,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile_picture": profilePicture,
  };
}
