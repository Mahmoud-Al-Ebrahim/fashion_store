part of 'store_request_bloc.dart';

@immutable
sealed class StoreRequestEvent {}

/// POST StoreRequest/Add (multipart/form-data) - apply to become a store owner
class AddStoreRequestEvent extends StoreRequestEvent {
  final String storeName;
  final String description;
  final String address;
  final File featuredImage;
  final File logo;
  final String workingHoursStart;
  final String workingHoursEnd;
  final String phoneNumber;
  final String email;
  final File nationalIdFrontImage;
  final File nationalIdBackImage;
  final File storeLicense;

  AddStoreRequestEvent({
    required this.storeName,
    required this.description,
    required this.address,
    required this.featuredImage,
    required this.logo,
    required this.workingHoursStart,
    required this.workingHoursEnd,
    required this.phoneNumber,
    required this.email,
    required this.nationalIdFrontImage,
    required this.nationalIdBackImage,
    required this.storeLicense,
  });
}

/// PUT StoreRequest/CancelRequest/{storeRequestId}/cancel
class CancelStoreRequestEvent extends StoreRequestEvent {
  final int storeRequestId;

  CancelStoreRequestEvent({required this.storeRequestId});
}

/// PUT StoreRequest/UpdateRequest/{storeId}/update (only non-null fields are sent)
class UpdateStoreRequestEvent extends StoreRequestEvent {
  final int storeId;
  final String? storeName;
  final String? description;
  final String? address;
  final String? workingHoursStart;
  final String? workingHoursEnd;

  UpdateStoreRequestEvent({
    required this.storeId,
    this.storeName,
    this.description,
    this.address,
    this.workingHoursStart,
    this.workingHoursEnd,
  });
}

/// GET StoreRequest/GetFilesByStore/{storeId}
class GetStoreRequestFilesEvent extends StoreRequestEvent {
  final int storeId;

  GetStoreRequestFilesEvent({required this.storeId});
}

/// GET StoreRequest/GetAllRequestStoreByUser
class GetAllStoreRequestsByUserEvent extends StoreRequestEvent {}

/// GET StoreRequest/GetFilterRequestStoreByUser
class GetFilterStoreRequestsByUserEvent extends StoreRequestEvent {
  final String
  storeStatus; // enStoreStatus: Pending|Approved|Rejected|Deleted|Cancelled

  GetFilterStoreRequestsByUserEvent({required this.storeStatus});
}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearStoreRequestEvent extends StoreRequestEvent {}
