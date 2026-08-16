import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/rating/rating_model.dart';

part 'rating_event.dart';

part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc() : super(RatingState()) {
    on<AddRatingEvent>(_onAddRatingEvent);
    on<GetProductRatingByUserEvent>(_onGetProductRatingByUserEvent);
  }

  FutureOr<void> _onAddRatingEvent(
    AddRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(addRatingStatus: AddRatingStatus.loading));
    await ApiService.postMethod(
      endPoint: 'Rating/AddRating',
      body: {"productId": event.productId, "ratingValue": event.ratingValue},
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<RatingModel>.fromJson(
        response.data,
        (json) => RatingModel.fromJson(json),
      );
      emit(
        state.copyWith(
          addRatingStatus: AddRatingStatus.success,
          rating: apiResponse.data,
          userRating: apiResponse.data?.ratingValue ?? event.ratingValue,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addRatingStatus: AddRatingStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          addRatingStatus: AddRatingStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetProductRatingByUserEvent(
    GetProductRatingByUserEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(
      state.copyWith(
        getProductRatingByUserStatus: GetProductRatingByUserStatus.loading,
      ),
    );
    await ApiService.getMethod(
      endPoint: 'Rating/GetProductRatingByUser',
      queryParameters: {"productId": event.productId.toString()},
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<int>.fromJson(response.data);
      emit(
        state.copyWith(
          getProductRatingByUserStatus: GetProductRatingByUserStatus.success,
          userRating: apiResponse.data ?? 0,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductRatingByUserStatus: GetProductRatingByUserStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductRatingByUserStatus: GetProductRatingByUserStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }
}
