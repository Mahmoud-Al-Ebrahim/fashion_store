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
      userId: json['userId'].toString(),
      productId: json['productId'] as int,
      ratingValue: json['ratingValue'] as int,
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}
