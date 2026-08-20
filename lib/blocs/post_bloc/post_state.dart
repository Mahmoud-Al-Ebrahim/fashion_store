part of 'post_bloc.dart';

enum PostTransactionStatus { init, loading, failure, success }

enum GetAllPostsStatus { init, loading, failure, success }

enum PostReactionStatus { init, loading, failure, success }

enum GetCommunityFeedStatus { init, loading, failure, success }

class PostState {
  final PostTransactionStatus postTransactionStatus;
  final GetAllPostsStatus getAllPostsStatus;
  final PostReactionStatus postReactionStatus;
  final GetCommunityFeedStatus getCommunityFeedStatus;

  final String errorMessage;

  /// Posts of a single store (store page / admin posts screen).
  final List<PostModel> posts;

  /// Merged feed across many stores (community page).
  final List<PostModel> communityFeed;

  PostState({
    this.postTransactionStatus = PostTransactionStatus.init,
    this.getAllPostsStatus = GetAllPostsStatus.init,
    this.postReactionStatus = PostReactionStatus.init,
    this.getCommunityFeedStatus = GetCommunityFeedStatus.init,
    this.errorMessage = '',
    this.posts = const [],
    this.communityFeed = const [],
  });

  PostState copyWith({
    PostTransactionStatus? postTransactionStatus,
    GetAllPostsStatus? getAllPostsStatus,
    PostReactionStatus? postReactionStatus,
    GetCommunityFeedStatus? getCommunityFeedStatus,
    String? errorMessage,
    List<PostModel>? posts,
    List<PostModel>? communityFeed,
  }) {
    return PostState(
      postTransactionStatus:
          postTransactionStatus ?? this.postTransactionStatus,
      getAllPostsStatus: getAllPostsStatus ?? this.getAllPostsStatus,
      postReactionStatus: postReactionStatus ?? this.postReactionStatus,
      getCommunityFeedStatus:
          getCommunityFeedStatus ?? this.getCommunityFeedStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      posts: posts ?? this.posts,
      communityFeed: communityFeed ?? this.communityFeed,
    );
  }
}
