part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

/// POST Product/AddProduct (store owner, multipart/form-data)
class AddProductEvent extends ProductEvent {
  final String name;
  final String description;
  final double price;
  final String season; // enSeason: Summer|Spring|Autumn|Winter
  final String gender; // enGender: Male|Female
  final String type; // enType
  final File image;
  final int categoryId;
  final double? discountPercentage;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;

  AddProductEvent({
    required this.name,
    required this.description,
    required this.price,
    required this.season,
    required this.gender,
    required this.type,
    required this.image,
    required this.categoryId,
    this.discountPercentage,
    this.discountStartDate,
    this.discountEndDate,
  });
}

/// PUT Product/UpdateProduct/{productId} (store owner, multipart/form-data)
/// Only [price], [categoryId], [discountPercentage]/[discountStartDate]/[discountEndDate]
/// and [image] are editable per the API.
class UpdateProductEvent extends ProductEvent {
  final int productId;
  final double? price;
  final int? categoryId;
  final double? discountPercentage;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final File? image;

  UpdateProductEvent({
    required this.productId,
    this.price,
    this.categoryId,
    this.discountPercentage,
    this.discountStartDate,
    this.discountEndDate,
    this.image,
  });
}

/// DELETE Product/DeleteProduct/{productId}
class DeleteProductEvent extends ProductEvent {
  final int productId;

  DeleteProductEvent({required this.productId});
}

/// GET Product/GetAllDiscountProduct
class GetAllDiscountProductEvent extends ProductEvent {}

/// GET Product/GetSearch/{query}
class SearchProductsEvent extends ProductEvent {
  final String query;

  SearchProductsEvent({required this.query});
}

/// GET Product/GetFilter
class FilterProductsEvent extends ProductEvent {
  final double? minPrice;
  final double? maxPrice;
  final String? type; // enType
  final String? color;
  final String? size; // enSize

  FilterProductsEvent({
    this.minPrice,
    this.maxPrice,
    this.type,
    this.color,
    this.size,
  });
}

/// Resolves one product by id, for screens that only hold a `productId`.
///
/// Cart lines, order items and the sales breakdown all reference a product
/// by id alone - the API exposes no "get product by id", so this reads the
/// unfiltered `Product/GetFilter` list and picks the match. It writes to its
/// own state slot rather than `filterResults`, so opening a product from an
/// order never disturbs whatever the explore screen was showing.
class LookupProductEvent extends ProductEvent {
  final int productId;

  LookupProductEvent({required this.productId});
}
