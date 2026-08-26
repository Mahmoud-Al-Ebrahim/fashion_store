import '../../core/utils/json_parse.dart';

/// Item of `GET Comment/GetAll` -> `data`, and response model for
/// `POST Comment/Add` -> `data`.
class CommentModel {
  final int commentId;
  final int? productId; // only populated by the Add response
  final String userId;
  final String userFullName;
  final String? userImage;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentModel({
    required this.commentId,
    this.productId,
    required this.userId,
    required this.userFullName,
    this.userImage,
    required this.text,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: asInt(json['commentId']),
      productId: json['productId'] as int?,
      userId: asString(json['userId']),
      userFullName: asString(json['userFullName']),
      userImage: asStringOrNull(json['userImage']),
      text: asString(json['text']),
      createdAt: asDate(json['createdAt']),
      updatedAt: asDateOrNull(json['updatedAt']),
    );
  }
}

List<CommentModel> commentListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
    .toList();
