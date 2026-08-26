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
import '../../models/product/store_product_model.dart';
import '../../models/store/store_detail_model.dart';
import '../../models/store/store_model.dart';

part 'store_event.dart';

part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState()) {
    on<GetAllStoresEvent>(_onGetAllStoresEvent);
    on<GetStoreByAdminEvent>(_onGetStoreByAdminEvent);
    on<GetAllProductsByStoreEvent>(_onGetAllProductsByStoreEvent);
    on<UpdateStoreEvent>(_onUpdateStoreEvent);
    on<UpdateStoreImagesEvent>(_onUpdateStoreImagesEvent);
  }

  FutureOr<void> _onGetAllStoresEvent(
    GetAllStoresEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(state.copyWith(getAllStoresStatus: GetAllStoresStatus.loading));
    await ApiService.getMethod(endPoint: 'Store/GetAllStores')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<StoreModel>>.fromJson(
            response.data,
            (json) => storeListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllStoresStatus: GetAllStoresStatus.success,
              stores: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoresStatus: GetAllStoresStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoresStatus: GetAllStoresStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetStoreByAdminEvent(
    GetStoreByAdminEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(state.copyWith(getStoreByAdminStatus: GetStoreByAdminStatus.loading));
    await ApiService.getMethod(endPoint: 'Store/GetStoresByAdmin')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<StoreDetailModel>.fromJson(
            response.data,
            (json) => StoreDetailModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getStoreByAdminStatus: GetStoreByAdminStatus.success,
              myStore: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getStoreByAdminStatus: GetStoreByAdminStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getStoreByAdminStatus: GetStoreByAdminStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllProductsByStoreEvent(
    GetAllProductsByStoreEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllProductsByStoreStatus: GetAllProductsByStoreStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'Store/GetAllProductsByStore',
          queryParameters: {"storeId": event.storeId.toString()},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<StoreProductModel>>.fromJson(
                response.data,
                (json) => storeProductListFromJson(json),
              );
          emit(
            state.copyWith(
              getAllProductsByStoreStatus: GetAllProductsByStoreStatus.success,
              storeProducts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllProductsByStoreStatus: GetAllProductsByStoreStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllProductsByStoreStatus: GetAllProductsByStoreStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateStoreEvent(
    UpdateStoreEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(storeTransactionStatus: StoreTransactionStatus.loading),
    );
    final Map<String, dynamic> data = {"storeId": event.storeId};
    if (event.storeName != null) data['storeName'] = event.storeName;
    if (event.description != null) data['description'] = event.description;
    if (event.address != null) data['address'] = event.address;
    if (event.workingHoursStart != null) {
      data['workingHoursStart'] = event.workingHoursStart;
    }
    if (event.workingHoursEnd != null) {
      data['workingHoursEnd'] = event.workingHoursEnd;
    }
    if (event.phoneNumber != null) data['phoneNumber'] = event.phoneNumber;

    await ApiService.patchMethod(endPoint: 'Store/UpdateStore', body: data)
        .then((response) {
          log(response.data.toString());
          add(GetStoreByAdminEvent());
          emit(
            state.copyWith(
              storeTransactionStatus: StoreTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeTransactionStatus: StoreTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeTransactionStatus: StoreTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateStoreImagesEvent(
    UpdateStoreImagesEvent event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(storeTransactionStatus: StoreTransactionStatus.loading),
    );
    final Map<String, dynamic> form = {};
    if (event.featuredImage != null) {
      form['FeaturedImage'] = await _toMultipartFile(event.featuredImage!);
    }
    if (event.logo != null) {
      form['Logo'] = await _toMultipartFile(event.logo!);
    }
    await ApiService.putMethod(
          endPoint: 'Store/UpdateStoreImages',
          form: FormData.fromMap(form),
        )
        .then((response) {
          log(response.data.toString());
          add(GetStoreByAdminEvent());
          emit(
            state.copyWith(
              storeTransactionStatus: StoreTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeTransactionStatus: StoreTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeTransactionStatus: StoreTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
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
}
