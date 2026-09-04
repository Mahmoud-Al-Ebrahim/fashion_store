part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

/// GET Comment/GetAll?productId=&pageNumber=&pageSize=
class GetProductCommentsEvent extends CommentEvent {
  final int productId;
  final int pageNumber;
  final int pageSize;

  GetProductCommentsEvent({
    required this.productId,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

/// POST Comment/Add
class AddCommentEvent extends CommentEvent {
  final int productId;
  final String content;

  AddCommentEvent({required this.productId, required this.content});
}

/// DELETE Comment/Delete?commentId=
class DeleteCommentEvent extends CommentEvent {
  final int commentId;
  final int productId;

  DeleteCommentEvent({required this.commentId, required this.productId});
}

/// PUT Comment/Update
class UpdateCommentEvent extends CommentEvent {
  final int commentId;
  final String content;
  final int productId;

  UpdateCommentEvent({
    required this.commentId,
    required this.content,
    required this.productId,
  });
}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearCommentEvent extends CommentEvent {}
