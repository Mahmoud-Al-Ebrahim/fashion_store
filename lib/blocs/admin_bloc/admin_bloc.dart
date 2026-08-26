import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/admin/admin_dashboard_model.dart';
import '../../models/admin/product_dashboard_model.dart';
import '../../models/common/api_response_model.dart';
import '../../models/product/store_product_model.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminState()) {
    on<DeleteStoreEvent>(_onDeleteStoreEvent);
    on<GetOrdersDetailEvent>(_onGetOrdersDetailEvent);
    on<GetProductInventoryAlertEvent>(_onGetProductInventoryAlertEvent);
    on<GetAllDiscountProductByStoreEvent>(_onGetAllDiscountProductByStoreEvent);
    on<GetProductDashboardEvent>(_onGetProductDashboardEvent);
    on<GetDashboardAnalyticsEvent>(_onGetDashboardAnalyticsEvent);
    on<GetDashboardSummaryEvent>(_onGetDashboardSummaryEvent);
  }

  String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  FutureOr<void> _onDeleteStoreEvent(
    DeleteStoreEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(deleteStoreStatus: DeleteStoreStatus.loading));
    await ApiService.deleteMethod(endPoint: 'Admin/Delete/${event.storeId}')
        .then((response) {
          log(response.data.toString());
          emit(state.copyWith(deleteStoreStatus: DeleteStoreStatus.success));
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              deleteStoreStatus: DeleteStoreStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              deleteStoreStatus: DeleteStoreStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetOrdersDetailEvent(
    GetOrdersDetailEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(getOrdersDetailStatus: GetOrdersDetailStatus.loading));
    await ApiService.getMethod(
          endPoint: 'Admin/GetOrdersDetail',
          queryParameters: {
            "startDate": _dateOnly(event.startDate),
            "endDate": _dateOnly(event.endDate),
          },
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<AdminOrderDetailStatModel>>.fromJson(
                response.data,
                (json) => adminOrderDetailListFromJson(json),
              );
          emit(
            state.copyWith(
              getOrdersDetailStatus: GetOrdersDetailStatus.success,
              ordersDetail: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getOrdersDetailStatus: GetOrdersDetailStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getOrdersDetailStatus: GetOrdersDetailStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetProductInventoryAlertEvent(
    GetProductInventoryAlertEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getProductInventoryAlertStatus: GetProductInventoryAlertStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Admin/GetProductInventoryAlert')
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<InventoryAlertModel>>.fromJson(
                response.data,
                (json) => inventoryAlertListFromJson(json),
              );
          emit(
            state.copyWith(
              getProductInventoryAlertStatus:
                  GetProductInventoryAlertStatus.success,
              inventoryAlerts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getProductInventoryAlertStatus:
                  GetProductInventoryAlertStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getProductInventoryAlertStatus:
                  GetProductInventoryAlertStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllDiscountProductByStoreEvent(
    GetAllDiscountProductByStoreEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllDiscountProductByStoreStatus:
            GetAllDiscountProductByStoreStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Admin/GetAllDiscountProductByStore')
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<StoreProductModel>>.fromJson(
                response.data,
                (json) => storeProductListFromJson(json),
              );
          emit(
            state.copyWith(
              getAllDiscountProductByStoreStatus:
                  GetAllDiscountProductByStoreStatus.success,
              discountedStoreProducts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllDiscountProductByStoreStatus:
                  GetAllDiscountProductByStoreStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllDiscountProductByStoreStatus:
                  GetAllDiscountProductByStoreStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetProductDashboardEvent(
    GetProductDashboardEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getProductDashboardStatus: GetProductDashboardStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'Admin/GetProductDashboard',
          queryParameters: {
            "pageNumber": event.pageNumber.toString(),
            "pageSize": event.pageSize.toString(),
          },
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<ProductDashboardResultModel>.fromJson(
                response.data,
                (json) => ProductDashboardResultModel.fromJson(json),
              );
          emit(
            state.copyWith(
              getProductDashboardStatus: GetProductDashboardStatus.success,
              productDashboard: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getProductDashboardStatus: GetProductDashboardStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getProductDashboardStatus: GetProductDashboardStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetDashboardAnalyticsEvent(
    GetDashboardAnalyticsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getDashboardAnalyticsStatus: GetDashboardAnalyticsStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'Admin/GetDashboardAnalytics',
          queryParameters: {
            "fromDate": _dateOnly(event.fromDate),
            "endDate": _dateOnly(event.endDate),
          },
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<AdminDashboardAnalyticsModel>.fromJson(
                response.data,
                (json) => AdminDashboardAnalyticsModel.fromJson(json),
              );
          emit(
            state.copyWith(
              getDashboardAnalyticsStatus: GetDashboardAnalyticsStatus.success,
              dashboardAnalytics: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getDashboardAnalyticsStatus: GetDashboardAnalyticsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getDashboardAnalyticsStatus: GetDashboardAnalyticsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetDashboardSummaryEvent(
    GetDashboardSummaryEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state.copyWith(
        getDashboardSummaryStatus: GetDashboardSummaryStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Admin/GetDashboardSummary')
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<AdminDashboardSummaryModel>.fromJson(
                response.data,
                (json) => AdminDashboardSummaryModel.fromJson(json),
              );
          emit(
            state.copyWith(
              getDashboardSummaryStatus: GetDashboardSummaryStatus.success,
              dashboardSummary: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getDashboardSummaryStatus: GetDashboardSummaryStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getDashboardSummaryStatus: GetDashboardSummaryStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
