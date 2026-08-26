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
import '../../core/constants/product_enums.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/product/product_catalog_model.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState()) {
    on<AddProductEvent>(_onAddProductEvent);
    on<UpdateProductEvent>(_onUpdateProductEvent);
    on<DeleteProductEvent>(_onDeleteProductEvent);
    on<GetAllDiscountProductEvent>(_onGetAllDiscountProductEvent);
    on<SearchProductsEvent>(_onSearchProductsEvent);
    on<FilterProductsEvent>(_onFilterProductsEvent);
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

  FutureOr<void> _onAddProductEvent(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        productTransactionStatus: ProductTransactionStatus.loading,
      ),
    );
    final Map<String, dynamic> form = {
      "Name": event.name,
      "Description": event.description,
      "Price": event.price,
      "Season": event.season,
      "Gender": event.gender,
      "Type": event.type,
      "Image": await _toMultipartFile(event.image),
      "CategoryId": event.categoryId,
    };
    if (event.discountPercentage != null) {
      form['DiscountPrecentage'] = event.discountPercentage;
    }
    if (event.discountStartDate != null) {
      form['DiscountStartDate'] = event.discountStartDate!
          .toUtc()
          .toIso8601String();
    }
    if (event.discountEndDate != null) {
      form['DiscountEndDate'] = event.discountEndDate!
          .toUtc()
          .toIso8601String();
    }
    await ApiService.postMethod(
          endPoint: 'Product/AddProduct',
          form: FormData.fromMap(form),
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateProductEvent(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        productTransactionStatus: ProductTransactionStatus.loading,
      ),
    );
    final Map<String, dynamic> form = {};
    if (event.price != null) form['Price'] = event.price;
    if (event.categoryId != null) form['CategoryId'] = event.categoryId;
    if (event.discountPercentage != null) {
      form['DiscountPrecentage'] = event.discountPercentage;
    }
    if (event.discountStartDate != null) {
      form['DiscountStartDate'] = event.discountStartDate!
          .toUtc()
          .toIso8601String();
    }
    if (event.discountEndDate != null) {
      form['DiscountEndDate'] = event.discountEndDate!
          .toUtc()
          .toIso8601String();
    }
    if (event.image != null) {
      form['Image'] = await _toMultipartFile(event.image!);
    }
    await ApiService.putMethod(
          endPoint: 'Product/UpdateProduct/${event.productId}',
          form: FormData.fromMap(form),
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeleteProductEvent(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        productTransactionStatus: ProductTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(
          endPoint: 'Product/DeleteProduct/${event.productId}',
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              productTransactionStatus: ProductTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllDiscountProductEvent(
    GetAllDiscountProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllDiscountProductStatus: GetAllDiscountProductStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Product/GetAllDiscountProduct')
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<ProductCatalogModel>>.fromJson(
                response.data,
                (json) => productCatalogListFromJson(json),
              );
          emit(
            state.copyWith(
              getAllDiscountProductStatus: GetAllDiscountProductStatus.success,
              discountedProducts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllDiscountProductStatus: GetAllDiscountProductStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllDiscountProductStatus: GetAllDiscountProductStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onSearchProductsEvent(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(searchProductsStatus: SearchProductsStatus.loading));
    await ApiService.getMethod(
          endPoint: 'Product/GetSearch/${Uri.encodeComponent(event.query)}',
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
              searchProductsStatus: SearchProductsStatus.success,
              searchResults: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              searchProductsStatus: SearchProductsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              searchProductsStatus: SearchProductsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onFilterProductsEvent(
    FilterProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(filterProductsStatus: FilterProductsStatus.loading));
    final Map<String, dynamic> query = {};
    if (event.minPrice != null) query['minPrice'] = event.minPrice.toString();
    if (event.maxPrice != null) query['maxPrice'] = event.maxPrice.toString();
    if (event.type != null) query['type'] = event.type;
    if (event.color != null) {
      // The filter carries a colour *name* (`red`, `white`, ...). The
      // catalog stores Arabic names, and `GetFilter` matches the string
      // exactly - so the name is resolved to the spelling actually stored
      // before it goes on the wire. Sending the raw English key, or the
      // hamza-bearing spelling the swatches carry, matches nothing.
      final swatch = swatchForColorName(event.color!);
      query['color'] = swatch?.queryName ?? normalizeColorName(event.color!);
    }
    if (event.size != null) query['size'] = event.size;
    await ApiService.getMethod(
          endPoint: 'Product/GetFilter',
          queryParameters: query,
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
              filterProductsStatus: FilterProductsStatus.success,
              filterResults: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              filterProductsStatus: FilterProductsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              filterProductsStatus: FilterProductsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
