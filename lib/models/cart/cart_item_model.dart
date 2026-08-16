/// Item inside `GET Cart/GetCartItems` -> `data.cartItemDto`.
class CartItemModel {
  final int cartItemId;
  final int productSizeId;
  final int storeId;
  final int productId;
  final String productImage;
  final int quantity;
  final double price;
  final double priceAfterDiscount;
  final String size;
  final String color;
  final String colorHexCode;

  CartItemModel({
    required this.cartItemId,
    required this.productSizeId,
    required this.storeId,
    required this.productId,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.priceAfterDiscount,
    required this.size,
    required this.color,
    required this.colorHexCode,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cartItemId'] as int,
      productSizeId: json['productSizeId'] as int,
      storeId: json['storeId'] as int,
      productId: json['productId'] as int,
      productImage: json['productImage']?.toString() ?? '',
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      size: json['size']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      colorHexCode: json['colorHexCode']?.toString() ?? '',
    );
  }
}

/// Response model for `GET Cart/GetCartItems` -> `data`.
class CartSummaryModel {
  final List<CartItemModel> items;
  final double totalPrice;

  CartSummaryModel({required this.items, required this.totalPrice});

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      items: (json['cartItemDto'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Response model for `POST Cart/AddToCart` -> `data`.
class AddToCartResultModel {
  final int cartId;
  final int storeId;
  final int productId;
  final String productImage;
  final int quantity;
  final double price;
  final double priceAfterDiscount;
  final String size;
  final String color;
  final String colorHexCode;

  AddToCartResultModel({
    required this.cartId,
    required this.storeId,
    required this.productId,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.priceAfterDiscount,
    required this.size,
    required this.color,
    required this.colorHexCode,
  });

  factory AddToCartResultModel.fromJson(Map<String, dynamic> json) {
    return AddToCartResultModel(
      cartId: json['cartId'] as int,
      storeId: json['storeId'] as int,
      productId: json['productId'] as int,
      productImage: json['productImage']?.toString() ?? '',
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      size: json['size']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      colorHexCode: json['colorHexCode']?.toString() ?? '',
    );
  }
}
