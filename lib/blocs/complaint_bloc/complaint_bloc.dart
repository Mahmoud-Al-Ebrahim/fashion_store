import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/complaint/complaint_model.dart';
import '../../models/complaint/message_model.dart';

part 'complaint_event.dart';

part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  ComplaintBloc() : super(ComplaintState()) {
    on<AddComplaintEvent>(_onAddComplaintEvent);
    on<GetAllComplaintsEvent>(_onGetAllComplaintsEvent);
    on<GetAllComplaintsByUserEvent>(_onGetAllComplaintsByUserEvent);
    on<GetComplaintMessagesEvent>(_onGetComplaintMessagesEvent);
    on<ReadComplaintMessagesEvent>(_onReadComplaintMessagesEvent);
  }

  FutureOr<void> _onAddComplaintEvent(
    AddComplaintEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(state.copyWith(addComplaintStatus: AddComplaintStatus.loading));
    final Map<String, dynamic> body = {
      "storeId": event.storeId,
      "title": event.title,
    };
    if (event.description != null) body['description'] = event.description;
    await ApiService.postMethod(endPoint: 'Complaint/AddComplaint', body: body)
        .then((response) {
      log(response.data.toString());
      add(GetAllComplaintsByUserEvent());
      emit(state.copyWith(addComplaintStatus: AddComplaintStatus.success));
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addComplaintStatus: AddComplaintStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          addComplaintStatus: AddComplaintStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetAllComplaintsEvent(
    GetAllComplaintsEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(
      state.copyWith(getAllComplaintsStatus: GetAllComplaintsStatus.loading),
    );
    await ApiService.getMethod(endPoint: 'Complaint/GetAllComplaints').then((
      response,
    ) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<StoreComplaintModel>>.fromJson(
        response.data,
        (json) => storeComplaintListFromJson(json),
      );
      emit(
        state.copyWith(
          getAllComplaintsStatus: GetAllComplaintsStatus.success,
          storeComplaints: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllComplaintsStatus: GetAllComplaintsStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllComplaintsStatus: GetAllComplaintsStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetAllComplaintsByUserEvent(
    GetAllComplaintsByUserEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllComplaintsByUserStatus: GetAllComplaintsByUserStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Complaint/GetAllComplaintsByUser')
        .then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<UserComplaintModel>>.fromJson(
        response.data,
        (json) => userComplaintListFromJson(json),
      );
      emit(
        state.copyWith(
          getAllComplaintsByUserStatus: GetAllComplaintsByUserStatus.success,
          userComplaints: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllComplaintsByUserStatus: GetAllComplaintsByUserStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllComplaintsByUserStatus: GetAllComplaintsByUserStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetComplaintMessagesEvent(
    GetComplaintMessagesEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(
      state.copyWith(
        getComplaintMessagesStatus: GetComplaintMessagesStatus.loading,
      ),
    );
    await ApiService.getMethod(
      endPoint: 'Message/GetMessagesByComplaintId/${event.complaintId}',
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<MessageModel>>.fromJson(
        response.data,
        (json) => messageListFromJson(json),
      );
      emit(
        state.copyWith(
          getComplaintMessagesStatus: GetComplaintMessagesStatus.success,
          messages: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getComplaintMessagesStatus: GetComplaintMessagesStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getComplaintMessagesStatus: GetComplaintMessagesStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onReadComplaintMessagesEvent(
    ReadComplaintMessagesEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(
      state.copyWith(
        readComplaintMessagesStatus: ReadComplaintMessagesStatus.loading,
      ),
    );
    await ApiService.putMethod(
      endPoint: 'Message/ReadMessage',
      body: {"complaintId": event.complaintId},
    ).then((response) {
      log(response.data.toString());
      add(GetComplaintMessagesEvent(complaintId: event.complaintId));
      emit(
        state.copyWith(
          readComplaintMessagesStatus: ReadComplaintMessagesStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          readComplaintMessagesStatus: ReadComplaintMessagesStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          readComplaintMessagesStatus: ReadComplaintMessagesStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }
}
