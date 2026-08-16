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
      commentId: json['commentId'] as int,
      productId: json['productId'] as int?,
      userId: json['userId']?.toString() ?? '',
      userFullName: json['userFullName']?.toString() ?? '',
      userImage: json['userImage']?.toString(),
      text: json['text']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'].toString()),
    );
  }
}

List<CommentModel> commentListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
    .toList();
