part of 'clothing_item_bloc.dart';

@immutable
sealed class ClothingItemEvent {}

/// POST ClothingItem/AddColorforProduct?productId= (multipart/form-data)
class AddColorForProductEvent extends ClothingItemEvent {
  final int productId;
  final String color;
  final String colorHexCode;
  final File image;

  AddColorForProductEvent({
    required this.productId,
    required this.color,
    required this.colorHexCode,
    required this.image,
  });
}

/// POST ClothingItem/AddSizesforProduct?productColorId= (json array body)
class AddSizesForProductEvent extends ClothingItemEvent {
  final int productColorId;
  final List<({String size, int quantity})> sizes;

  AddSizesForProductEvent({required this.productColorId, required this.sizes});
}

/// PUT ClothingItem/UpdateDetailsforProduct?clothingItemId=&Color= (multipart/form-data)
class UpdateProductColorDetailsEvent extends ClothingItemEvent {
  final int clothingItemId;
  final String color;
  final File image;

  UpdateProductColorDetailsEvent({
    required this.clothingItemId,
    required this.color,
    required this.image,
  });
}

/// GET ClothingItem/GetAll/{productId} - all color variants + sizes for a product
class GetAllClothingItemsEvent extends ClothingItemEvent {
  final int productId;

  GetAllClothingItemsEvent({required this.productId});
}

/// GET ClothingItem/Get/{clothingItemId}
class GetClothingItemEvent extends ClothingItemEvent {
  final int clothingItemId;

  GetClothingItemEvent({required this.clothingItemId});
}

/// GET ClothingItem/GetAllSizeByProductColor?productId=&color=
class GetAllSizesByProductColorEvent extends ClothingItemEvent {
  final int productId;
  final String color;

  GetAllSizesByProductColorEvent({required this.productId, required this.color});
}

/// PUT ClothingItem/UpdateSizeforProduct?productSizeId=
class UpdateProductSizeEvent extends ClothingItemEvent {
  final int productSizeId;
  final int quantity;

  UpdateProductSizeEvent({required this.productSizeId, required this.quantity});
}

/// POST ClothingItem/GetSuggestByProductId?ProductId=
class GetSuggestedProductsEvent extends ClothingItemEvent {
  final int productId;

  GetSuggestedProductsEvent({required this.productId});
}

/// DELETE ClothingItem/DeleteProductColor/{productColorId}
class DeleteProductColorEvent extends ClothingItemEvent {
  final int productColorId;

  DeleteProductColorEvent({required this.productColorId});
}

/// DELETE ClothingItem/DeleteProductSize/{productSizeId}
class DeleteProductSizeEvent extends ClothingItemEvent {
  final int productSizeId;

  DeleteProductSizeEvent({required this.productSizeId});
}
