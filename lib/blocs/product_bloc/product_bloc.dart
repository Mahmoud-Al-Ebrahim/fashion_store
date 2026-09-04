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
import '../../models/product/store_product_model.dart';

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
    on<LookupProductEvent>(_onLookupProductEvent);
    on<LoadProductDescriptionEvent>(_onLoadProductDescriptionEvent);
    on<ClearProductEvent>((event, emit) => emit(ProductState()));
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
      "Occasion": event.occasion,
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
    if (event.price != null) form['Price'] = event.price?.toInt();
    if (event.categoryId != null) form['CategoryId'] = event.categoryId;
    if (event.discountPercentage != null) {
      form['DiscountPrecentage'] = event.discountPercentage?.toInt();
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
    if (event.name != null) {
      form['Name'] = event.name;
    }
    if (event.desc != null) {
      form['Description'] = event.desc;
    }
    print(form);
    print(event.productId);
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

  /// Reads the store's catalog and keeps the description of [productId].
  ///
  /// Failure is deliberately silent: the description is supplementary, and
  /// an error banner over a product screen that is otherwise fine would be
  /// worse than simply not showing it.
  FutureOr<void> _onLoadProductDescriptionEvent(
    LoadProductDescriptionEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state.productDescriptions.containsKey(event.productId)) return;
    try {
      final response = await ApiService.getMethod(
        endPoint: 'Store/GetAllProductsByStore',
        queryParameters: {'storeId': event.storeId.toString()},
      );
      final apiResponse = ApiResponseModel<List<StoreProductModel>>.fromJson(
        response.data,
        (json) => storeProductListFromJson(json),
      );
      final updated = Map<int, String>.from(state.productDescriptions);
      for (final product in apiResponse.data ?? const <StoreProductModel>[]) {
        if (product.description.trim().isEmpty) continue;
        updated[product.id] = product.description.trim();
      }
      emit(state.copyWith(productDescriptions: updated));
    } catch (error) {
      log('product description lookup failed: $error');
    }
  }

  FutureOr<void> _onLookupProductEvent(
    LookupProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(lookupProductStatus: LookupProductStatus.loading));
    await ApiService.getMethod(endPoint: 'Product/GetFilter')
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<List<ProductCatalogModel>>.fromJson(
                response.data,
                (json) => productCatalogListFromJson(json),
              );
          ProductCatalogModel? match;
          for (final product
              in apiResponse.data ?? const <ProductCatalogModel>[]) {
            if (product.id == event.productId) {
              match = product;
              break;
            }
          }
          emit(
            state.copyWith(
              // A product can be deleted while it still sits in somebody's old
              // order, so "not found" is an ordinary outcome, not an error.
              lookupProductStatus: match == null
                  ? LookupProductStatus.notFound
                  : LookupProductStatus.success,
              lookupProduct: match,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              lookupProductStatus: LookupProductStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              lookupProductStatus: LookupProductStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
