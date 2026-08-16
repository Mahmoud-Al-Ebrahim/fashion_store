part of 'comment_bloc.dart';

enum GetProductCommentsStatus { init, loading, failure, success }

enum CommentTransactionStatus { init, loading, failure, success }

class CommentState {
  final GetProductCommentsStatus getProductCommentsStatus;
  final CommentTransactionStatus commentTransactionStatus;

  final String errorMessage;

  final List<CommentModel> comments;

  CommentState({
    this.getProductCommentsStatus = GetProductCommentsStatus.init,
    this.commentTransactionStatus = CommentTransactionStatus.init,
    this.errorMessage = '',
    this.comments = const [],
  });

  CommentState copyWith({
    GetProductCommentsStatus? getProductCommentsStatus,
    CommentTransactionStatus? commentTransactionStatus,
    String? errorMessage,
    List<CommentModel>? comments,
  }) {
    return CommentState(
      getProductCommentsStatus:
          getProductCommentsStatus ?? this.getProductCommentsStatus,
      commentTransactionStatus:
          commentTransactionStatus ?? this.commentTransactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      comments: comments ?? this.comments,
    );
  }
}
