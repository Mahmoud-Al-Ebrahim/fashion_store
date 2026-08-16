part of 'clothing_item_bloc.dart';

enum ClothingItemTransactionStatus { init, loading, failure, success }

enum GetAllClothingItemsStatus { init, loading, failure, success }

enum GetClothingItemStatus { init, loading, failure, success }

enum GetAllSizesByProductColorStatus { init, loading, failure, success }

enum GetSuggestedProductsStatus { init, loading, failure, success }

class ClothingItemState {
  final ClothingItemTransactionStatus clothingItemTransactionStatus;
  final GetAllClothingItemsStatus getAllClothingItemsStatus;
  final GetClothingItemStatus getClothingItemStatus;
  final GetAllSizesByProductColorStatus getAllSizesByProductColorStatus;
  final GetSuggestedProductsStatus getSuggestedProductsStatus;

  final String errorMessage;

  final List<ClothingItemModel> clothingItems;
  final ClothingItemBasicModel? clothingItem;
  final List<ProductSizeModel> sizesByColor;
  final List<SuggestedProductModel> suggestedProducts;

  ClothingItemState({
    this.clothingItemTransactionStatus = ClothingItemTransactionStatus.init,
    this.getAllClothingItemsStatus = GetAllClothingItemsStatus.init,
    this.getClothingItemStatus = GetClothingItemStatus.init,
    this.getAllSizesByProductColorStatus =
        GetAllSizesByProductColorStatus.init,
    this.getSuggestedProductsStatus = GetSuggestedProductsStatus.init,
    this.errorMessage = '',
    this.clothingItems = const [],
    this.clothingItem,
    this.sizesByColor = const [],
    this.suggestedProducts = const [],
  });

  ClothingItemState copyWith({
    ClothingItemTransactionStatus? clothingItemTransactionStatus,
    GetAllClothingItemsStatus? getAllClothingItemsStatus,
    GetClothingItemStatus? getClothingItemStatus,
    GetAllSizesByProductColorStatus? getAllSizesByProductColorStatus,
    GetSuggestedProductsStatus? getSuggestedProductsStatus,
    String? errorMessage,
    List<ClothingItemModel>? clothingItems,
    ClothingItemBasicModel? clothingItem,
    List<ProductSizeModel>? sizesByColor,
    List<SuggestedProductModel>? suggestedProducts,
  }) {
    return ClothingItemState(
      clothingItemTransactionStatus:
          clothingItemTransactionStatus ?? this.clothingItemTransactionStatus,
      getAllClothingItemsStatus:
          getAllClothingItemsStatus ?? this.getAllClothingItemsStatus,
      getClothingItemStatus: getClothingItemStatus ?? this.getClothingItemStatus,
      getAllSizesByProductColorStatus: getAllSizesByProductColorStatus ??
          this.getAllSizesByProductColorStatus,
      getSuggestedProductsStatus:
          getSuggestedProductsStatus ?? this.getSuggestedProductsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      clothingItems: clothingItems ?? this.clothingItems,
      clothingItem: clothingItem ?? this.clothingItem,
      sizesByColor: sizesByColor ?? this.sizesByColor,
      suggestedProducts: suggestedProducts ?? this.suggestedProducts,
    );
  }
}
