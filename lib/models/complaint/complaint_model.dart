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
      customerImageUrl: json['customerImageUrl']?.toString(),
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

  StoreComplaintModel({
    required this.complaintId,
    required this.customerId,
    required this.customerFullName,
    this.customerImageUrl,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  factory StoreComplaintModel.fromJson(Map<String, dynamic> json) {
    return StoreComplaintModel(
      complaintId: json['complaintId'] as int,
      customerId: json['customerId'].toString(),
      customerFullName: json['customerFullName']?.toString() ?? '',
      customerImageUrl: json['customerImageUrl']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      status: json['status']?.toString() ?? '',
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

  UserComplaintModel({
    required this.complaintId,
    required this.storeId,
    required this.storeName,
    this.storeLogo,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory UserComplaintModel.fromJson(Map<String, dynamic> json) {
    return UserComplaintModel(
      complaintId: json['complaintId'] as int,
      storeId: json['storeId'] as int,
      storeName: json['storeName']?.toString() ?? '',
      storeLogo: json['storeLogo']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}

List<UserComplaintModel> userComplaintListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => UserComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
