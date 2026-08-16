import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/comment/comment_model.dart';
import '../../models/common/api_response_model.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentState()) {
    on<GetProductCommentsEvent>(_onGetProductCommentsEvent);
    on<AddCommentEvent>(_onAddCommentEvent);
    on<DeleteCommentEvent>(_onDeleteCommentEvent);
    on<UpdateCommentEvent>(_onUpdateCommentEvent);
  }

  FutureOr<void> _onGetProductCommentsEvent(
    GetProductCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(
      state.copyWith(
        getProductCommentsStatus: GetProductCommentsStatus.loading,
      ),
    );
    await ApiService.getMethod(
      endPoint: 'Comment/GetAll',
      queryParameters: {
        "productId": event.productId.toString(),
        "pageNumber": event.pageNumber.toString(),
        "pageSize": event.pageSize.toString(),
      },
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<CommentModel>>.fromJson(
        response.data,
        (json) => commentListFromJson(json),
      );
      emit(
        state.copyWith(
          getProductCommentsStatus: GetProductCommentsStatus.success,
          comments: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductCommentsStatus: GetProductCommentsStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductCommentsStatus: GetProductCommentsStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddCommentEvent(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(
      state.copyWith(
        commentTransactionStatus: CommentTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(
      endPoint: 'Comment/Add',
      body: {"content": event.content, "productId": event.productId},
    ).then((response) {
      log(response.data.toString());
      add(GetProductCommentsEvent(productId: event.productId));
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onDeleteCommentEvent(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(
      state.copyWith(
        commentTransactionStatus: CommentTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(
      endPoint: 'Comment/Delete',
      queryParameters: {"commentId": event.commentId.toString()},
    ).then((response) {
      log(response.data.toString());
      add(GetProductCommentsEvent(productId: event.productId));
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onUpdateCommentEvent(
    UpdateCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(
      state.copyWith(
        commentTransactionStatus: CommentTransactionStatus.loading,
      ),
    );
    await ApiService.putMethod(
      endPoint: 'Comment/Update',
      body: {"commentId": event.commentId, "content": event.content},
    ).then((response) {
      log(response.data.toString());
      add(GetProductCommentsEvent(productId: event.productId));
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          commentTransactionStatus: CommentTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }
}
