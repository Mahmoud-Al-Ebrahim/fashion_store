import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:mime_type/mime_type.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/store/store_detail_model.dart';
import '../../models/store/store_request_files_model.dart';

part 'store_request_event.dart';

part 'store_request_state.dart';

class StoreRequestBloc extends Bloc<StoreRequestEvent, StoreRequestState> {
  StoreRequestBloc() : super(StoreRequestState()) {
    on<AddStoreRequestEvent>(_onAddStoreRequestEvent);
    on<CancelStoreRequestEvent>(_onCancelStoreRequestEvent);
    on<UpdateStoreRequestEvent>(_onUpdateStoreRequestEvent);
    on<GetStoreRequestFilesEvent>(_onGetStoreRequestFilesEvent);
    on<GetAllStoreRequestsByUserEvent>(_onGetAllStoreRequestsByUserEvent);
    on<GetFilterStoreRequestsByUserEvent>(_onGetFilterStoreRequestsByUserEvent);
    on<ClearStoreRequestEvent>((event, emit) => emit(StoreRequestState()));
  }

  Future<MultipartFile> _toMultipartFile(File file) async {
    final fileName = file.path.split('/').last;
    final mimeType = mime(fileName) ?? '';
    final parts = mimeType.split('/');
    return MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: parts.length == 2 ? MediaType(parts[0], parts[1]) : null,
    );
  }

  FutureOr<void> _onAddStoreRequestEvent(
    AddStoreRequestEvent event,
    Emitter<StoreRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        storeRequestTransactionStatus: StoreRequestTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(
          endPoint: 'StoreRequest/Add',
          form: FormData.fromMap({
            "StoreName": event.storeName,
            "Description": event.description,
            "Address": event.address,
            "FeaturedImage": await _toMultipartFile(event.featuredImage),
            "Logo": await _toMultipartFile(event.logo),
            "WorkingHoursStart": event.workingHoursStart,
            "WorkingHoursEnd": event.workingHoursEnd,
            "PhoneNumber": event.phoneNumber,
            "Email": event.email,
            "NationalIdFrontImage": await _toMultipartFile(
              event.nationalIdFrontImage,
            ),
            "NationalIdBackImage": await _toMultipartFile(
              event.nationalIdBackImage,
            ),
            "StoreLicense": await _toMultipartFile(event.storeLicense),
          }),
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllStoreRequestsByUserEvent());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onCancelStoreRequestEvent(
    CancelStoreRequestEvent event,
    Emitter<StoreRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        storeRequestTransactionStatus: StoreRequestTransactionStatus.loading,
      ),
    );
    await ApiService.putMethod(
          endPoint: 'StoreRequest/CancelRequest/${event.storeRequestId}/cancel',
          body: const {},
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllStoreRequestsByUserEvent());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateStoreRequestEvent(
    UpdateStoreRequestEvent event,
    Emitter<StoreRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        storeRequestTransactionStatus: StoreRequestTransactionStatus.loading,
      ),
    );
    final Map<String, dynamic> data = {};
    if (event.storeName != null) data['storeName'] = event.storeName;
    if (event.description != null) data['description'] = event.description;
    if (event.address != null) data['address'] = event.address;
    if (event.workingHoursStart != null) {
      data['workingHoursStart'] = event.workingHoursStart;
    }
    if (event.workingHoursEnd != null) {
      data['workingHoursEnd'] = event.workingHoursEnd;
    }
    await ApiService.putMethod(
          endPoint: 'StoreRequest/UpdateRequest/${event.storeId}/update',
          body: data,
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllStoreRequestsByUserEvent());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeRequestTransactionStatus:
                  StoreRequestTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetStoreRequestFilesEvent(
    GetStoreRequestFilesEvent event,
    Emitter<StoreRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        getStoreRequestFilesStatus: GetStoreRequestFilesStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'StoreRequest/GetFilesByStore/${event.storeId}',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<StoreRequestFilesModel>.fromJson(
            response.data,
            (json) => StoreRequestFilesModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getStoreRequestFilesStatus: GetStoreRequestFilesStatus.success,
              storeRequestFiles: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getStoreRequestFilesStatus: GetStoreRequestFilesStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getStoreRequestFilesStatus: GetStoreRequestFilesStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllStoreRequestsByUserEvent(
    GetAllStoreRequestsByUserEvent event,
    Emitter<StoreRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllStoreRequestsStatus: GetAllStoreRequestsStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'StoreRequest/GetAllRequestStoreByUser',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<StoreDetailModel>>.fromJson(
            response.data,
            (json) => storeDetailListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllStoreRequestsStatus: GetAllStoreRequestsStatus.success,
              storeRequests: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoreRequestsStatus: GetAllStoreRequestsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoreRequestsStatus: GetAllStoreRequestsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetFilterStoreRequestsByUserEvent(
    GetFilterStoreRequestsByUserEvent event,
    Emitter<StoreRequestState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllStoreRequestsStatus: GetAllStoreRequestsStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'StoreRequest/GetFilterRequestStoreByUser',
          queryParameters: {"storeStatus": event.storeStatus},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<StoreDetailModel>>.fromJson(
            response.data,
            (json) => storeDetailListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllStoreRequestsStatus: GetAllStoreRequestsStatus.success,
              storeRequests: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoreRequestsStatus: GetAllStoreRequestsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoreRequestsStatus: GetAllStoreRequestsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
