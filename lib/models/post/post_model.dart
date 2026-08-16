/// Nested media entry inside [PostModel.postMedias].
class PostMediaModel {
  final int postMediaId;
  final String mediaUrl;
  final String mediaType; // enMediaType: Image | Video
  final int? duration;

  PostMediaModel({
    required this.postMediaId,
    required this.mediaUrl,
    required this.mediaType,
    this.duration,
  });

  factory PostMediaModel.fromJson(Map<String, dynamic> json) {
    return PostMediaModel(
      postMediaId: json['postMediaId'] as int,
      mediaUrl: json['mediaUrl']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? '',
      duration: json['duration'] as int?,
    );
  }
}

/// Reaction-count breakdown entry inside [PostModel.postReactions].
class PostReactionSummaryModel {
  final int count;
  final String reactionType; // enReactionType

  PostReactionSummaryModel({required this.count, required this.reactionType});

  factory PostReactionSummaryModel.fromJson(Map<String, dynamic> json) {
    return PostReactionSummaryModel(
      count: json['count'] as int,
      reactionType: json['reactionType']?.toString() ?? '',
    );
  }
}

/// Item of `GET Post/GetAll/{storeId}` -> `data`, and response model for
/// `POST Post/Add` / `PUT Post/Update/{postId}` -> `data`.
class PostModel {
  final int id;
  final int storeId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String visibility; // enPostVisibility: Public | Followers
  final bool isDeleted;
  final List<PostMediaModel> postMedias;
  final String? myReaction; // enReactionType, or null if the caller hasn't reacted
  final List<PostReactionSummaryModel> postReactions;

  PostModel({
    required this.id,
    required this.storeId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.visibility,
    required this.isDeleted,
    required this.postMedias,
    this.myReaction,
    required this.postReactions,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      storeId: json['storeId'] as int,
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'].toString()),
      visibility: json['visibility']?.toString() ?? '',
      isDeleted: json['isDeleted'] == true,
      postMedias: (json['postMedias'] as List<dynamic>? ?? [])
          .map((e) => PostMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      myReaction: json['myReaction']?.toString(),
      postReactions: (json['postReactions'] as List<dynamic>? ?? [])
          .map(
            (e) => PostReactionSummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

List<PostModel> postListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
    .toList();

/// Response model for `POST PostReaction` -> `data` (toggles the caller's
/// reaction on a post; [isReacted] reflects the state *after* the toggle).
class PostReactionResultModel {
  final int id;
  final int reactionCount;
  final DateTime createdAt;
  final String reactionType;
  final bool isReacted;

  PostReactionResultModel({
    required this.id,
    required this.reactionCount,
    required this.createdAt,
    required this.reactionType,
    required this.isReacted,
  });

  factory PostReactionResultModel.fromJson(Map<String, dynamic> json) {
    return PostReactionResultModel(
      id: json['id'] as int,
      reactionCount: json['reactionCount'] as int,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      reactionType: json['reactionType']?.toString() ?? '',
      isReacted: json['isReacted'] == true,
    );
  }
}
