import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/category/category_model.dart';
import '../../models/category/store_category_model.dart';
import '../../models/common/api_response_model.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState()) {
    on<GetAllCategoriesEvent>(_onGetAllCategoriesEvent);
    on<AddCategoryEvent>(_onAddCategoryEvent);
    on<DeleteCategoryEvent>(_onDeleteCategoryEvent);
    on<GetAllStoreCategoryByAdminEvent>(_onGetAllStoreCategoryByAdminEvent);
    on<AddStoreCategoryEvent>(_onAddStoreCategoryEvent);
    on<DeleteStoreCategoryEvent>(_onDeleteStoreCategoryEvent);
    on<ClearCategoryEvent>((event, emit) => emit(CategoryState()));
  }

  FutureOr<void> _onGetAllCategoriesEvent(
    GetAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(getAllCategoriesStatus: GetAllCategoriesStatus.loading),
    );
    await ApiService.getMethod(endPoint: 'Category/GetAll')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<CategoryModel>>.fromJson(
            response.data,
            (json) => categoryListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllCategoriesStatus: GetAllCategoriesStatus.success,
              categories: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllCategoriesStatus: GetAllCategoriesStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllCategoriesStatus: GetAllCategoriesStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onAddCategoryEvent(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        categoryTransactionStatus: CategoryTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(
          endPoint: 'Category/Add',
          body: {"name": event.name},
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllCategoriesEvent());
          emit(
            state.copyWith(
              categoryTransactionStatus: CategoryTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              categoryTransactionStatus: CategoryTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              categoryTransactionStatus: CategoryTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeleteCategoryEvent(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        categoryTransactionStatus: CategoryTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(
          endPoint: 'Category/Delete/${event.categoryId}',
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllCategoriesEvent());
          emit(
            state.copyWith(
              categoryTransactionStatus: CategoryTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              categoryTransactionStatus: CategoryTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              categoryTransactionStatus: CategoryTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllStoreCategoryByAdminEvent(
    GetAllStoreCategoryByAdminEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllStoreCategoryStatus: GetAllStoreCategoryStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'StoreCategory/GetAllStoreCategoryByAdmin',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<StoreCategoryModel>>.fromJson(
                response.data,
                (json) => storeCategoryListFromJson(json),
              );
          emit(
            state.copyWith(
              getAllStoreCategoryStatus: GetAllStoreCategoryStatus.success,
              storeCategories: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoreCategoryStatus: GetAllStoreCategoryStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllStoreCategoryStatus: GetAllStoreCategoryStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onAddStoreCategoryEvent(
    AddStoreCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        storeCategoryTransactionStatus: StoreCategoryTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(
          endPoint: 'StoreCategory/Add',
          body: {"categoryId": event.categoryId},
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllStoreCategoryByAdminEvent());
          emit(
            state.copyWith(
              storeCategoryTransactionStatus:
                  StoreCategoryTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeCategoryTransactionStatus:
                  StoreCategoryTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeCategoryTransactionStatus:
                  StoreCategoryTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeleteStoreCategoryEvent(
    DeleteStoreCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        storeCategoryTransactionStatus: StoreCategoryTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(
          endPoint: 'StoreCategory/Delete/${event.storeCategoryId}',
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllStoreCategoryByAdminEvent());
          emit(
            state.copyWith(
              storeCategoryTransactionStatus:
                  StoreCategoryTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              storeCategoryTransactionStatus:
                  StoreCategoryTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              storeCategoryTransactionStatus:
                  StoreCategoryTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
