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
