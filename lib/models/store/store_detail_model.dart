import '../../core/utils/api_service.dart';

/// Full store record including status/audit fields. Returned by
/// `GET Store/GetStoresByAdmin` (single store owned by the caller) and by
/// the StoreRequest endpoints (`GetAllRequestStoreByUser`,
/// `GetFilterRequestStoreByUser`) which expose the same underlying entity
/// before/while it's still Pending approval.
class StoreDetailModel {
  final int id;

  /// Id of the account that owns (or requested) the store. Only the
  /// SuperAdmin request feed returns it; the public store list does not.
  final String? ownerId;
  final String storeName;
  final String description;
  final String storePhoneNumber;
  final String address;
  final String storeEmail;
  final String? logo;
  final String? featuredImage;
  final String workingHoursStart;
  final String workingHoursEnd;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? note;
  final String
  storeStatus; // enStoreStatus: Pending|Approved|Rejected|Deleted|Cancelled
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool isActive;

  StoreDetailModel({
    required this.id,
    this.ownerId,
    required this.storeName,
    required this.description,
    required this.storePhoneNumber,
    required this.address,
    required this.storeEmail,
    this.logo,
    this.featuredImage,
    required this.workingHoursStart,
    required this.workingHoursEnd,
    required this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.note,
    required this.storeStatus,
    required this.isDeleted,
    this.deletedAt,
    required this.isActive,
  });

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) {
    return StoreDetailModel(
      id: json['id'] as int,
      ownerId: json['ownerId']?.toString(),
      storeName: json['storeName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      // `Store/GetAllStores` says `storePhoneNumber`, while
      // `SuperAdmin/GetAllRequestStoreByFilter` says `phoneNumber` for the
      // same value - accept either so both feeds populate the card.
      storePhoneNumber:
          (json['storePhoneNumber'] ?? json['phoneNumber'])?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      storeEmail: (json['storeEmail'] ?? json['email'])?.toString() ?? '',
      logo: ApiService.resolveUrl(json['logo']?.toString()),
      featuredImage: ApiService.resolveUrl(json['featuredImage']?.toString()),
      workingHoursStart: json['workingHoursStart']?.toString() ?? '',
      workingHoursEnd: json['workingHoursEnd']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'].toString()),
      rejectedAt: json['rejectedAt'] == null
          ? null
          : DateTime.parse(json['rejectedAt'].toString()),
      note: json['note']?.toString(),
      storeStatus: json['storeStatus']?.toString() ?? '',
      isDeleted: json['isDeleted'] == true,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'].toString()),
      isActive: json['isActive'] == true,
    );
  }
}

List<StoreDetailModel> storeDetailListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => StoreDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();
