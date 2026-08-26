import '../../core/utils/json_parse.dart';

/// Response model for `POST Rating/AddRating` -> `data`.
class RatingModel {
  final String userId;
  final int productId;
  final int ratingValue;
  final DateTime createdAt;

  RatingModel({
    required this.userId,
    required this.productId,
    required this.ratingValue,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      userId: asString(json['userId']),
      productId: asInt(json['productId']),
      ratingValue: asInt(json['ratingValue']),
      createdAt: asDate(json['createdAt']),
    );
  }
}
