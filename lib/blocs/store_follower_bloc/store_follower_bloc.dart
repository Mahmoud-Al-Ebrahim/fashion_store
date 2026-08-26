import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/product/product_catalog_model.dart';
import '../../models/store/store_follow_model.dart';
import '../../models/store/store_model.dart';

part 'store_follower_event.dart';

part 'store_follower_state.dart';

class StoreFollowerBloc extends Bloc<StoreFollowerEvent, StoreFollowerState> {
  StoreFollowerBloc() : super(StoreFollowerState()) {
    on<ToggleStoreFollowEvent>(_onToggleStoreFollowEvent);
    on<GetProductsByFollowerStoresEvent>(_onGetProductsByFollowerStoresEvent);
    on<GetStoreFollowersCountEvent>(_onGetStoreFollowersCountEvent);
    on<GetFollowedStoresEvent>(_onGetFollowedStoresEvent);
  }

  FutureOr<void> _onToggleStoreFollowEvent(
    ToggleStoreFollowEvent event,
    Emitter<StoreFollowerState> emit,
  ) async {
    emit(
      state.copyWith(toggleStoreFollowStatus: ToggleStoreFollowStatus.loading),
    );
    await ApiService.putMethod(
          endPoint: 'StoreFollower/StoreFollow',
          body: {"storeId": event.storeId},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<StoreFollowModel>.fromJson(
            response.data,
            (json) => StoreFollowModel.fromJson(json),
          );
          add(GetStoreFollowersCountEvent(storeId: event.storeId));
          // Keep the "stores I follow" list in sync with the toggle.
          add(GetFollowedStoresEvent());
          emit(
            state.copyWith(
              toggleStoreFollowStatus: ToggleStoreFollowStatus.success,
              storeFollow: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              toggleStoreFollowStatus: ToggleStoreFollowStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              toggleStoreFollowStatus: ToggleStoreFollowStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetProductsByFollowerStoresEvent(
    GetProductsByFollowerStoresEvent event,
    Emitter<StoreFollowerState> emit,
  ) async {
    emit(
      state.copyWith(
        getProductsByFollowerStoresStatus:
            GetProductsByFollowerStoresStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'StoreFollower/GetProductsByFollowerStores',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<ProductCatalogModel>>.fromJson(
                response.data,
                (json) => productCatalogListFromJson(json),
              );
          emit(
            state.copyWith(
              getProductsByFollowerStoresStatus:
                  GetProductsByFollowerStoresStatus.success,
              followedStoresProducts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getProductsByFollowerStoresStatus:
                  GetProductsByFollowerStoresStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getProductsByFollowerStoresStatus:
                  GetProductsByFollowerStoresStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetStoreFollowersCountEvent(
    GetStoreFollowersCountEvent event,
    Emitter<StoreFollowerState> emit,
  ) async {
    emit(
      state.copyWith(
        getStoreFollowersCountStatus: GetStoreFollowersCountStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'StoreFollower/GetStoreFollowersCount',
          queryParameters: {"storeId": event.storeId.toString()},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<int>.fromJson(response.data);
          emit(
            state.copyWith(
              getStoreFollowersCountStatus:
                  GetStoreFollowersCountStatus.success,
              followersCount: apiResponse.data ?? 0,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getStoreFollowersCountStatus:
                  GetStoreFollowersCountStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getStoreFollowersCountStatus:
                  GetStoreFollowersCountStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetFollowedStoresEvent(
    GetFollowedStoresEvent event,
    Emitter<StoreFollowerState> emit,
  ) async {
    emit(
      state.copyWith(getFollowedStoresStatus: GetFollowedStoresStatus.loading),
    );
    await ApiService.getMethod(endPoint: 'StoreFollower/GetStoreFollowByUser')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<StoreModel>>.fromJson(
            response.data,
            (json) => storeListFromJson(json),
          );
          emit(
            state.copyWith(
              getFollowedStoresStatus: GetFollowedStoresStatus.success,
              followedStores: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getFollowedStoresStatus: GetFollowedStoresStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getFollowedStoresStatus: GetFollowedStoresStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
