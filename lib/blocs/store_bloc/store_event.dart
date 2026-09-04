part of 'store_bloc.dart';

@immutable
sealed class StoreEvent {}

/// GET Store/GetAllStores (public - browse all approved stores)
class GetAllStoresEvent extends StoreEvent {}

/// GET Store/GetStoresByAdmin (store owner - the store they own)
class GetStoreByAdminEvent extends StoreEvent {}

/// GET Store/GetAllProductsByStore
class GetAllProductsByStoreEvent extends StoreEvent {
  final int storeId;

  GetAllProductsByStoreEvent({required this.storeId});
}

/// PATCH Store/UpdateStore (store owner - only non-null fields are sent)
class UpdateStoreEvent extends StoreEvent {
  final int storeId;
  final String? storeName;
  final String? description;
  final String? address;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final String? phoneNumber;

  UpdateStoreEvent({
    required this.storeId,
    this.storeName,
    this.description,
    this.address,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.phoneNumber,
  });
}

/// PUT Store/UpdateStoreImages (store owner, multipart/form-data)
class UpdateStoreImagesEvent extends StoreEvent {
  final File? featuredImage;
  final File? logo;

  UpdateStoreImagesEvent({this.featuredImage, this.logo});
}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearStoreEvent extends StoreEvent {}
