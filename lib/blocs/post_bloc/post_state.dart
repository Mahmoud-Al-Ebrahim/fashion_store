part of 'post_bloc.dart';

enum PostTransactionStatus { init, loading, failure, success }

enum GetAllPostsStatus { init, loading, failure, success }

enum PostReactionStatus { init, loading, failure, success }

class PostState {
  final PostTransactionStatus postTransactionStatus;
  final GetAllPostsStatus getAllPostsStatus;
  final PostReactionStatus postReactionStatus;

  final String errorMessage;

  final List<PostModel> posts;

  PostState({
    this.postTransactionStatus = PostTransactionStatus.init,
    this.getAllPostsStatus = GetAllPostsStatus.init,
    this.postReactionStatus = PostReactionStatus.init,
    this.errorMessage = '',
    this.posts = const [],
  });

  PostState copyWith({
    PostTransactionStatus? postTransactionStatus,
    GetAllPostsStatus? getAllPostsStatus,
    PostReactionStatus? postReactionStatus,
    String? errorMessage,
    List<PostModel>? posts,
  }) {
    return PostState(
      postTransactionStatus:
          postTransactionStatus ?? this.postTransactionStatus,
      getAllPostsStatus: getAllPostsStatus ?? this.getAllPostsStatus,
      postReactionStatus: postReactionStatus ?? this.postReactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      posts: posts ?? this.posts,
    );
  }
}
