import '../admin/product_dashboard_model.dart';
import 'product_catalog_model.dart';
import 'store_product_model.dart';
import '../clothing_item/suggested_product_model.dart';

/// The API has no "get product by id" endpoint - each list endpoint returns a
/// slightly different projection of a product. [ProductRef] is the common
/// shape the product-detail screen needs, built from whichever list the user
/// navigated from. Fields the source list didn't provide stay null and the
/// detail screen simply hides them.
class ProductRef {
  final int id;
  final int? storeId;

  /// Only known when navigating from a store screen or a store-tagged list.
  final String? storeName;
  final String name;
  final String? description;
  final double price;
  final double priceAfterDiscount;
  final double? discountPercentage;
  final String image;
  final double? rating;

  const ProductRef({
    required this.id,
    required this.name,
    required this.price,
    required this.priceAfterDiscount,
    required this.image,
    this.storeId,
    this.storeName,
    this.description,
    this.discountPercentage,
    this.rating,
  });

  bool get hasDiscount =>
      discountPercentage != null && priceAfterDiscount < price;

  /// Alias kept so the existing card/detail widgets keep reading `imageUrl`.
  String get imageUrl => image;

  ProductRef copyWith({int? storeId, String? storeName}) => ProductRef(
    id: id,
    name: name,
    price: price,
    priceAfterDiscount: priceAfterDiscount,
    image: image,
    storeId: storeId ?? this.storeId,
    storeName: storeName ?? this.storeName,
    description: description,
    discountPercentage: discountPercentage,
    rating: rating,
  );

  factory ProductRef.fromCatalog(ProductCatalogModel p) => ProductRef(
    id: p.id,
    storeId: p.storeId,
    name: p.name,
    price: p.price,
    priceAfterDiscount: p.priceAfterDiscount,
    discountPercentage: p.discountPercentage,
    image: p.image,
  );

  factory ProductRef.fromStoreProduct(
    StoreProductModel p, {
    int? storeId,
    String? storeName,
  }) => ProductRef(
    id: p.id,
    storeId: storeId,
    storeName: storeName,
    name: p.name,
    description: p.description,
    price: p.price,
    priceAfterDiscount: p.priceAfterDiscount,
    discountPercentage: p.discountPercentage,
    image: p.image,
    rating: p.rating,
  );

  factory ProductRef.fromSuggested(SuggestedProductModel p) => ProductRef(
    id: p.productId,
    name: p.name,
    price: p.price,
    priceAfterDiscount: p.priceAfterDiscount,
    image: p.imageUrl,
    rating: p.ratingValue,
  );

  factory ProductRef.fromDashboard(
    ProductDashboardItemModel p, {
    int? storeId,
  }) => ProductRef(
    id: p.id,
    storeId: storeId,
    name: p.name,
    description: p.description,
    price: p.price,
    priceAfterDiscount: p.priceAfterDiscount,
    discountPercentage: p.discountPercentage,
    image: p.image,
    rating: p.ratingValue,
  );
}
