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
