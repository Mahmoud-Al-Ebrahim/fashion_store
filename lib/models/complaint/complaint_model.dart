import '../../core/utils/api_service.dart';

/// Response model for `POST Complaint/AddComplaint` -> `data`.
class ComplaintDetailModel {
  final int id;
  final String customerId;
  final String customerFullName;
  final String? customerImageUrl;
  final String storeOwnerId;
  final String storeName;
  final String? storeLogoUrl;
  final String title;
  final String description;
  final DateTime createdAt;

  ComplaintDetailModel({
    required this.id,
    required this.customerId,
    required this.customerFullName,
    this.customerImageUrl,
    required this.storeOwnerId,
    required this.storeName,
    this.storeLogoUrl,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory ComplaintDetailModel.fromJson(Map<String, dynamic> json) {
    return ComplaintDetailModel(
      id: json['id'] as int,
      customerId: json['customerId'].toString(),
      customerFullName: json['customerFullName']?.toString() ?? '',
      customerImageUrl: ApiService.resolveUrl(
        json['customerImageUrl']?.toString(),
      ),
      storeOwnerId: json['storeOwnerId'].toString(),
      storeName: json['storeName']?.toString() ?? '',
      storeLogoUrl: json['storeLogoUrl']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}

/// Item of `GET Complaint/GetAllComplaints` -> `data` (store-owner view).
class StoreComplaintModel {
  final int complaintId;
  final String customerId;
  final String customerFullName;
  final String? customerImageUrl;
  final String title;
  final String description;
  final DateTime createdAt;
  final String status; // e.g. Pending

  /// Messages in this thread the signed-in side has not opened yet.
  final int numberOfUnReadMessage;

  StoreComplaintModel({
    required this.complaintId,
    required this.customerId,
    required this.customerFullName,
    this.customerImageUrl,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
    this.numberOfUnReadMessage = 0,
  });

  factory StoreComplaintModel.fromJson(Map<String, dynamic> json) {
    return StoreComplaintModel(
      complaintId: json['complaintId'] as int,
      customerId: json['customerId'].toString(),
      customerFullName: json['customerFullName']?.toString() ?? '',
      customerImageUrl: ApiService.resolveUrl(
        json['customerImageUrl']?.toString(),
      ),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      status: json['status']?.toString() ?? '',
      numberOfUnReadMessage:
          (json['numberOfUnReadMessage'] as num?)?.toInt() ?? 0,
    );
  }
}

List<StoreComplaintModel> storeComplaintListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => StoreComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();

/// Item of `GET Complaint/GetAllComplaintsByUser` -> `data` (customer view).
class UserComplaintModel {
  final int complaintId;
  final int storeId;
  final String storeName;
  final String? storeLogo;
  final String title;
  final String description;
  final DateTime createdAt;

  /// Messages in this thread the signed-in side has not opened yet.
  final int numberOfUnReadMessage;

  /// When the last message landed, or null for a thread nobody has written
  /// in yet. Used to order the list by real activity.
  final DateTime? lastMessageAt;

  UserComplaintModel({
    required this.complaintId,
    required this.storeId,
    required this.storeName,
    this.storeLogo,
    required this.title,
    required this.description,
    required this.createdAt,
    this.numberOfUnReadMessage = 0,
    this.lastMessageAt,
  });

  /// Newest activity first: the last message if there is one, otherwise the
  /// moment the complaint was filed.
  DateTime get lastActivityAt => lastMessageAt ?? createdAt;

  factory UserComplaintModel.fromJson(Map<String, dynamic> json) {
    return UserComplaintModel(
      complaintId: json['complaintId'] as int,
      storeId: json['storeId'] as int,
      storeName: json['storeName']?.toString() ?? '',
      storeLogo: ApiService.resolveUrl(json['storeLogo']?.toString()),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      numberOfUnReadMessage:
          (json['numberOfUnReadMessage'] as num?)?.toInt() ?? 0,
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? ''),
    );
  }
}

List<UserComplaintModel> userComplaintListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => UserComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
