part of 'rating_bloc.dart';

@immutable
sealed class RatingEvent {}

/// POST Rating/AddRating (also used to update the caller's existing rating)
class AddRatingEvent extends RatingEvent {
  final int productId;
  final int ratingValue;

  AddRatingEvent({required this.productId, required this.ratingValue});
}

/// GET Rating/GetProductRatingByUser?productId= - the caller's own rating (0 if none)
class GetProductRatingByUserEvent extends RatingEvent {
  final int productId;

  GetProductRatingByUserEvent({required this.productId});
}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearRatingEvent extends RatingEvent {}
