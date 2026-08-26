part of 'post_bloc.dart';

/// One media item to attach when creating a post via [AddPostEvent].
class PostMediaInput {
  final File file;
  final String mediaType; // enMediaType: Image | Video
  final int? durationSeconds; // required for Video

  PostMediaInput({
    required this.file,
    required this.mediaType,
    this.durationSeconds,
  });
}

@immutable
sealed class PostEvent {}

/// POST Post/Add (multipart/form-data, store owner)
class AddPostEvent extends PostEvent {
  final String content;
  final String visibility; // enPostVisibility: Public | Followers
  final List<PostMediaInput> media;

  AddPostEvent({
    required this.content,
    required this.visibility,
    this.media = const [],
  });
}

/// DELETE Post/Delete/{postId}
class DeletePostEvent extends PostEvent {
  final int postId;
  final int storeId;

  DeletePostEvent({required this.postId, required this.storeId});
}

/// GET Post/GetAll/{storeId}
class GetAllPostsEvent extends PostEvent {
  final int storeId;

  GetAllPostsEvent({required this.storeId});
}

/// Builds the community feed. The API exposes posts per store only, so this
/// fans out to `Post/GetAll/{storeId}` for each of [storeIds] and merges the
/// results newest-first client side.
class GetCommunityFeedEvent extends PostEvent {
  final List<int> storeIds;

  GetCommunityFeedEvent({required this.storeIds});
}

/// PUT Post/Update/{postId} (multipart/form-data, store owner)
class UpdatePostEvent extends PostEvent {
  final int postId;
  final int storeId;
  final String? content;
  final String? visibility;
  final List<File> newMedias;
  final List<int> deletedMediaIds;

  UpdatePostEvent({
    required this.postId,
    required this.storeId,
    this.content,
    this.visibility,
    this.newMedias = const [],
    this.deletedMediaIds = const [],
  });
}

/// POST PostReaction - toggles the caller's reaction on a post
class TogglePostReactionEvent extends PostEvent {
  final int postId;
  final String reactionType; // enReactionType: Like|Love|Haha|Wow|Sad|Angry
  final int storeId;

  TogglePostReactionEvent({
    required this.postId,
    required this.reactionType,
    required this.storeId,
  });
}
