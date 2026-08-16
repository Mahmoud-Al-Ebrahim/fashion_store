part of 'product_bloc.dart';

enum ProductTransactionStatus { init, loading, failure, success }

enum GetAllDiscountProductStatus { init, loading, failure, success }

enum SearchProductsStatus { init, loading, failure, success }

enum FilterProductsStatus { init, loading, failure, success }

class ProductState {
  final ProductTransactionStatus productTransactionStatus;
  final GetAllDiscountProductStatus getAllDiscountProductStatus;
  final SearchProductsStatus searchProductsStatus;
  final FilterProductsStatus filterProductsStatus;

  final String errorMessage;

  final List<ProductCatalogModel> discountedProducts;
  final List<ProductCatalogModel> searchResults;
  final List<ProductCatalogModel> filterResults;

  ProductState({
    this.productTransactionStatus = ProductTransactionStatus.init,
    this.getAllDiscountProductStatus = GetAllDiscountProductStatus.init,
    this.searchProductsStatus = SearchProductsStatus.init,
    this.filterProductsStatus = FilterProductsStatus.init,
    this.errorMessage = '',
    this.discountedProducts = const [],
    this.searchResults = const [],
    this.filterResults = const [],
  });

  ProductState copyWith({
    ProductTransactionStatus? productTransactionStatus,
    GetAllDiscountProductStatus? getAllDiscountProductStatus,
    SearchProductsStatus? searchProductsStatus,
    FilterProductsStatus? filterProductsStatus,
    String? errorMessage,
    List<ProductCatalogModel>? discountedProducts,
    List<ProductCatalogModel>? searchResults,
    List<ProductCatalogModel>? filterResults,
  }) {
    return ProductState(
      productTransactionStatus:
          productTransactionStatus ?? this.productTransactionStatus,
      getAllDiscountProductStatus:
          getAllDiscountProductStatus ?? this.getAllDiscountProductStatus,
      searchProductsStatus: searchProductsStatus ?? this.searchProductsStatus,
      filterProductsStatus: filterProductsStatus ?? this.filterProductsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      discountedProducts: discountedProducts ?? this.discountedProducts,
      searchResults: searchResults ?? this.searchResults,
      filterResults: filterResults ?? this.filterResults,
    );
  }
}
