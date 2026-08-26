import 'dart:async';
import 'dart:convert';
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
import '../../models/clothing_item/clothing_item_model.dart';
import '../../models/clothing_item/product_size_model.dart';
import '../../models/clothing_item/suggested_product_model.dart';
import '../../models/common/api_response_model.dart';

part 'clothing_item_event.dart';

part 'clothing_item_state.dart';

class ClothingItemBloc extends Bloc<ClothingItemEvent, ClothingItemState> {
  ClothingItemBloc() : super(ClothingItemState()) {
    on<AddColorForProductEvent>(_onAddColorForProductEvent);
    on<AddSizesForProductEvent>(_onAddSizesForProductEvent);
    on<UpdateProductColorDetailsEvent>(_onUpdateProductColorDetailsEvent);
    on<GetAllClothingItemsEvent>(_onGetAllClothingItemsEvent);
    on<GetClothingItemEvent>(_onGetClothingItemEvent);
    on<GetAllSizesByProductColorEvent>(_onGetAllSizesByProductColorEvent);
    on<UpdateProductSizeEvent>(_onUpdateProductSizeEvent);
    on<GetSuggestedProductsEvent>(_onGetSuggestedProductsEvent);
    on<DeleteProductColorEvent>(_onDeleteProductColorEvent);
    on<DeleteProductSizeEvent>(_onDeleteProductSizeEvent);
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

  FutureOr<void> _onAddColorForProductEvent(
    AddColorForProductEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        clothingItemTransactionStatus: ClothingItemTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(
          endPoint: 'ClothingItem/AddColorforProduct',
          queryParameters: {"productId": event.productId.toString()},
          form: FormData.fromMap({
            "Color": event.color,
            "ColorHexCode": event.colorHexCode,
            "Image": await _toMultipartFile(event.image),
          }),
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllClothingItemsEvent(productId: event.productId));
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onAddSizesForProductEvent(
    AddSizesForProductEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        clothingItemTransactionStatus: ClothingItemTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(
          endPoint: 'ClothingItem/AddSizesforProduct',
          queryParameters: {"productColorId": event.productColorId.toString()},
          bodyAsString: jsonEncode(
            event.sizes
                .map((s) => {"size": s.size, "quantity": s.quantity})
                .toList(),
          ),
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateProductColorDetailsEvent(
    UpdateProductColorDetailsEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        clothingItemTransactionStatus: ClothingItemTransactionStatus.loading,
      ),
    );
    await ApiService.putMethod(
          endPoint: 'ClothingItem/UpdateDetailsforProduct',
          queryParameters: {
            "clothingItemId": event.clothingItemId.toString(),
            "Color": event.color,
          },
          form: FormData.fromMap({
            "Image": await _toMultipartFile(event.image),
          }),
        )
        .then((response) {
          log(response.data.toString());
          add(GetClothingItemEvent(clothingItemId: event.clothingItemId));
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllClothingItemsEvent(
    GetAllClothingItemsEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllClothingItemsStatus: GetAllClothingItemsStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'ClothingItem/GetAll/${event.productId}',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<ClothingItemModel>>.fromJson(
                response.data,
                (json) => clothingItemListFromJson(json),
              );
          emit(
            state.copyWith(
              getAllClothingItemsStatus: GetAllClothingItemsStatus.success,
              clothingItems: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllClothingItemsStatus: GetAllClothingItemsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllClothingItemsStatus: GetAllClothingItemsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetClothingItemEvent(
    GetClothingItemEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(state.copyWith(getClothingItemStatus: GetClothingItemStatus.loading));
    await ApiService.getMethod(
          endPoint: 'ClothingItem/Get/${event.clothingItemId}',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<ClothingItemBasicModel>.fromJson(
            response.data,
            (json) => ClothingItemBasicModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getClothingItemStatus: GetClothingItemStatus.success,
              clothingItem: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getClothingItemStatus: GetClothingItemStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getClothingItemStatus: GetClothingItemStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllSizesByProductColorEvent(
    GetAllSizesByProductColorEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllSizesByProductColorStatus:
            GetAllSizesByProductColorStatus.loading,
      ),
    );
    await ApiService.getMethod(
          endPoint: 'ClothingItem/GetAllSizeByProductColor',
          queryParameters: {
            "productId": event.productId.toString(),
            "color": event.color,
          },
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<ProductSizeModel>>.fromJson(
            response.data,
            (json) => productSizeListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllSizesByProductColorStatus:
                  GetAllSizesByProductColorStatus.success,
              sizesByColor: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllSizesByProductColorStatus:
                  GetAllSizesByProductColorStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllSizesByProductColorStatus:
                  GetAllSizesByProductColorStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateProductSizeEvent(
    UpdateProductSizeEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        clothingItemTransactionStatus: ClothingItemTransactionStatus.loading,
      ),
    );
    await ApiService.putMethod(
          endPoint: 'ClothingItem/UpdateSizeforProduct',
          queryParameters: {"productSizeId": event.productSizeId.toString()},
          body: {"quantity": event.quantity},
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetSuggestedProductsEvent(
    GetSuggestedProductsEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        getSuggestedProductsStatus: GetSuggestedProductsStatus.loading,
      ),
    );
    await ApiService.postMethod(
          endPoint: 'ClothingItem/GetSuggestByProductId',
          queryParameters: {"ProductId": event.productId.toString()},
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<SuggestedProductModel>>.fromJson(
                response.data,
                (json) => suggestedProductListFromJson(json),
              );
          emit(
            state.copyWith(
              getSuggestedProductsStatus: GetSuggestedProductsStatus.success,
              suggestedProducts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getSuggestedProductsStatus: GetSuggestedProductsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getSuggestedProductsStatus: GetSuggestedProductsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeleteProductColorEvent(
    DeleteProductColorEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        clothingItemTransactionStatus: ClothingItemTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(
          endPoint: 'ClothingItem/DeleteProductColor/${event.productColorId}',
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeleteProductSizeEvent(
    DeleteProductSizeEvent event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(
      state.copyWith(
        clothingItemTransactionStatus: ClothingItemTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(
          endPoint: 'ClothingItem/DeleteProductSize/${event.productSizeId}',
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              clothingItemTransactionStatus:
                  ClothingItemTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
