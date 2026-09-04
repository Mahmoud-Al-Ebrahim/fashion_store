part of 'product_bloc.dart';

enum ProductTransactionStatus { init, loading, failure, success }

enum GetAllDiscountProductStatus { init, loading, failure, success }

enum SearchProductsStatus { init, loading, failure, success }

enum FilterProductsStatus { init, loading, failure, success }

enum LookupProductStatus { init, loading, notFound, failure, success }

class ProductState {
  final ProductTransactionStatus productTransactionStatus;
  final GetAllDiscountProductStatus getAllDiscountProductStatus;
  final SearchProductsStatus searchProductsStatus;
  final FilterProductsStatus filterProductsStatus;
  final LookupProductStatus lookupProductStatus;

  final String errorMessage;

  final List<ProductCatalogModel> discountedProducts;
  final List<ProductCatalogModel> searchResults;
  final List<ProductCatalogModel> filterResults;

  /// Result of the most recent [LookupProductEvent].
  final ProductCatalogModel? lookupProduct;

  /// Descriptions resolved by [LoadProductDescriptionEvent], keyed by
  /// product id. A separate slot on purpose: filling one product's
  /// description must not replace the list a screen is showing.
  final Map<int, String> productDescriptions;

  ProductState({
    this.productTransactionStatus = ProductTransactionStatus.init,
    this.getAllDiscountProductStatus = GetAllDiscountProductStatus.init,
    this.searchProductsStatus = SearchProductsStatus.init,
    this.filterProductsStatus = FilterProductsStatus.init,
    this.lookupProductStatus = LookupProductStatus.init,
    this.errorMessage = '',
    this.discountedProducts = const [],
    this.searchResults = const [],
    this.filterResults = const [],
    this.lookupProduct,
    this.productDescriptions = const {},
  });

  ProductState copyWith({
    ProductTransactionStatus? productTransactionStatus,
    GetAllDiscountProductStatus? getAllDiscountProductStatus,
    SearchProductsStatus? searchProductsStatus,
    FilterProductsStatus? filterProductsStatus,
    LookupProductStatus? lookupProductStatus,
    String? errorMessage,
    List<ProductCatalogModel>? discountedProducts,
    List<ProductCatalogModel>? searchResults,
    List<ProductCatalogModel>? filterResults,
    ProductCatalogModel? lookupProduct,
    Map<int, String>? productDescriptions,
  }) {
    return ProductState(
      productTransactionStatus:
          productTransactionStatus ?? this.productTransactionStatus,
      getAllDiscountProductStatus:
          getAllDiscountProductStatus ?? this.getAllDiscountProductStatus,
      searchProductsStatus: searchProductsStatus ?? this.searchProductsStatus,
      filterProductsStatus: filterProductsStatus ?? this.filterProductsStatus,
      lookupProductStatus: lookupProductStatus ?? this.lookupProductStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      discountedProducts: discountedProducts ?? this.discountedProducts,
      searchResults: searchResults ?? this.searchResults,
      filterResults: filterResults ?? this.filterResults,
      lookupProduct: lookupProduct ?? this.lookupProduct,
      productDescriptions: productDescriptions ?? this.productDescriptions,
    );
  }
}
