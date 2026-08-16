part of 'rating_bloc.dart';

enum AddRatingStatus { init, loading, failure, success }

enum GetProductRatingByUserStatus { init, loading, failure, success }

class RatingState {
  final AddRatingStatus addRatingStatus;
  final GetProductRatingByUserStatus getProductRatingByUserStatus;

  final String errorMessage;

  final RatingModel? rating;
  final int userRating;

  RatingState({
    this.addRatingStatus = AddRatingStatus.init,
    this.getProductRatingByUserStatus = GetProductRatingByUserStatus.init,
    this.errorMessage = '',
    this.rating,
    this.userRating = 0,
  });

  RatingState copyWith({
    AddRatingStatus? addRatingStatus,
    GetProductRatingByUserStatus? getProductRatingByUserStatus,
    String? errorMessage,
    RatingModel? rating,
    int? userRating,
  }) {
    return RatingState(
      addRatingStatus: addRatingStatus ?? this.addRatingStatus,
      getProductRatingByUserStatus:
          getProductRatingByUserStatus ?? this.getProductRatingByUserStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      rating: rating ?? this.rating,
      userRating: userRating ?? this.userRating,
    );
  }
}
