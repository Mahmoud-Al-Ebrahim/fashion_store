import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/admin/super_admin_order_model.dart';
import '../../models/category/store_category_model.dart';
import '../../models/common/api_response_model.dart';
import '../../models/store/store_detail_model.dart';
import '../../models/user/user_profile_model.dart';

part 'super_admin_event.dart';

part 'super_admin_state.dart';

class SuperAdminBloc extends Bloc<SuperAdminEvent, SuperAdminState> {
  SuperAdminBloc() : super(SuperAdminState()) {
    on<RevokeUserTokenEvent>(_onRevokeUserTokenEvent);
    on<UnbanUserEvent>(_onUnbanUserEvent);
    on<GetAllStoreCategoryEvent>(_onGetAllStoreCategoryEvent);
    on<AddRoleEvent>(_onAddRoleEvent);
    on<ApproveStoreRequestEvent>(_onApproveStoreRequestEvent);
    on<RejectStoreRequestEvent>(_onRejectStoreRequestEvent);
    on<GetAllStoreRequestsByFilterEvent>(
      _onGetAllStoreRequestsByFilterEvent,
    );
    on<GetActiveUsersEvent>(_onGetActiveUsersEvent);
    on<GetBannedUsersEvent>(_onGetBannedUsersEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);
    on<GetAllFilterOrdersEvent>(_onGetAllFilterOrdersEvent);
  }

  FutureOr<void> _onRevokeUserTokenEvent(
    RevokeUserTokenEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(
      state.copyWith(revokeUserTokenStatus: RevokeUserTokenStatus.loading),
    );
    await ApiService.postMethod(
      endPoint: 'SuperAdmin/RevokeToken/${event.userId}',
    ).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(revokeUserTokenStatus: RevokeUserTokenStatus.success),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          revokeUserTokenStatus: RevokeUserTokenStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          revokeUserTokenStatus: RevokeUserTokenStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onUnbanUserEvent(
    UnbanUserEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(state.copyWith(unbanUserStatus: UnbanUserStatus.loading));
    await ApiService.postMethod(
      endPoint: 'SuperAdmin/UnbanUser/${event.userId}',
    ).then((response) {
      log(response.data.toString());
      add(GetBannedUsersEvent());
      add(GetActiveUsersEvent());
      emit(state.copyWith(unbanUserStatus: UnbanUserStatus.success));
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          unbanUserStatus: UnbanUserStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          unbanUserStatus: UnbanUserStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetAllStoreCategoryEvent(
    GetAllStoreCategoryEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllStoreCategoryStatus: GetAllStoreCategoryStatus.loading,
      ),
    );
    await ApiService.getMethod(
      endPoint: 'SuperAdmin/GetAllStoreCategory/${event.storeId}',
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<StoreCategoryModel>>.fromJson(
        response.data,
        (json) => storeCategoryListFromJson(json),
      );
      emit(
        state.copyWith(
          getAllStoreCategoryStatus: GetAllStoreCategoryStatus.success,
          storeCategories: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllStoreCategoryStatus: GetAllStoreCategoryStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllStoreCategoryStatus: GetAllStoreCategoryStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddRoleEvent(
    AddRoleEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(state.copyWith(addRoleStatus: AddRoleStatus.loading));
    await ApiService.postMethod(
      endPoint: 'SuperAdmin/AddRole',
      body: {"userId": event.userId, "role": event.role},
    ).then((response) {
      log(response.data.toString());
      emit(state.copyWith(addRoleStatus: AddRoleStatus.success));
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addRoleStatus: AddRoleStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          addRoleStatus: AddRoleStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onApproveStoreRequestEvent(
    ApproveStoreRequestEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(
      state.copyWith(
        storeRequestDecisionStatus: StoreRequestDecisionStatus.loading,
      ),
    );
    await ApiService.patchMethod(
      endPoint: 'SuperAdmin/RequestApproved/${event.requestId}',
    ).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          storeRequestDecisionStatus: StoreRequestDecisionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          storeRequestDecisionStatus: StoreRequestDecisionStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          storeRequestDecisionStatus: StoreRequestDecisionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onRejectStoreRequestEvent(
    RejectStoreRequestEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(
      state.copyWith(
        storeRequestDecisionStatus: StoreRequestDecisionStatus.loading,
      ),
    );
    final Map<String, dynamic> body = {"requestId": event.requestId};
    if (event.rejectionReason != null) {
      body['rejectionReason'] = event.rejectionReason;
    }
    await ApiService.patchMethod(
      endPoint: 'SuperAdmin/RequestRejected',
      body: body,
    ).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          storeRequestDecisionStatus: StoreRequestDecisionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          storeRequestDecisionStatus: StoreRequestDecisionStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          storeRequestDecisionStatus: StoreRequestDecisionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetAllStoreRequestsByFilterEvent(
    GetAllStoreRequestsByFilterEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllStoreRequestsByFilterStatus:
            GetAllStoreRequestsByFilterStatus.loading,
      ),
    );
    await ApiService.getMethod(
      endPoint: 'SuperAdmin/GetAllRequestStoreByFilter',
      queryParameters: {
        "storeStatus": event.storeStatus,
        "pageNumber": event.pageNumber.toString(),
        "pageSize": event.pageSize.toString(),
      },
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<StoreDetailModel>>.fromJson(
        response.data,
        (json) => storeDetailListFromJson(json),
      );
      emit(
        state.copyWith(
          getAllStoreRequestsByFilterStatus:
              GetAllStoreRequestsByFilterStatus.success,
          storeRequests: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllStoreRequestsByFilterStatus:
              GetAllStoreRequestsByFilterStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllStoreRequestsByFilterStatus:
              GetAllStoreRequestsByFilterStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetActiveUsersEvent(
    GetActiveUsersEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(state.copyWith(getActiveUsersStatus: GetActiveUsersStatus.loading));
    await ApiService.getMethod(endPoint: 'SuperAdmin/ActiveUsers').then((
      response,
    ) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<UserProfileModel>>.fromJson(
        response.data,
        (json) => (json as List<dynamic>)
            .map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      emit(
        state.copyWith(
          getActiveUsersStatus: GetActiveUsersStatus.success,
          activeUsers: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getActiveUsersStatus: GetActiveUsersStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getActiveUsersStatus: GetActiveUsersStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetBannedUsersEvent(
    GetBannedUsersEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(state.copyWith(getBannedUsersStatus: GetBannedUsersStatus.loading));
    await ApiService.getMethod(endPoint: 'SuperAdmin/BannedUsers').then((
      response,
    ) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<UserProfileModel>>.fromJson(
        response.data,
        (json) => (json as List<dynamic>)
            .map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      emit(
        state.copyWith(
          getBannedUsersStatus: GetBannedUsersStatus.success,
          bannedUsers: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getBannedUsersStatus: GetBannedUsersStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getBannedUsersStatus: GetBannedUsersStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onDeleteUserEvent(
    DeleteUserEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(state.copyWith(deleteUserStatus: DeleteUserStatus.loading));
    await ApiService.deleteMethod(
      endPoint: 'SuperAdmin/DeleteUser',
      queryParameters: {"userId": event.userId},
    ).then((response) {
      log(response.data.toString());
      add(GetActiveUsersEvent());
      add(GetBannedUsersEvent());
      emit(state.copyWith(deleteUserStatus: DeleteUserStatus.success));
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          deleteUserStatus: DeleteUserStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          deleteUserStatus: DeleteUserStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetAllFilterOrdersEvent(
    GetAllFilterOrdersEvent event,
    Emitter<SuperAdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllFilterOrdersStatus: GetAllFilterOrdersStatus.loading,
      ),
    );
    await ApiService.getMethod(
      endPoint: 'SuperAdmin/GetAllFilterOrders',
      queryParameters: {
        "orderStatus": event.orderStatus,
        "pageNumber": event.pageNumber.toString(),
        "pageSize": event.pageSize.toString(),
      },
    ).then((response) {
      log(response.data.toString());
      final apiResponse = ApiResponseModel<List<SuperAdminOrderModel>>.fromJson(
        response.data,
        (json) => superAdminOrderListFromJson(json),
      );
      emit(
        state.copyWith(
          getAllFilterOrdersStatus: GetAllFilterOrdersStatus.success,
          orders: apiResponse.data ?? [],
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllFilterOrdersStatus: GetAllFilterOrdersStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllFilterOrdersStatus: GetAllFilterOrdersStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }
}
