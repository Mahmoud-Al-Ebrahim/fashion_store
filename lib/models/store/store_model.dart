import '../../core/utils/api_service.dart';

/// Public store card, returned by `GET Store/GetAllStores`.
class StoreModel {
  final int id;
  final String storeName;
  final String description;
  final String storePhoneNumber;
  final String address;
  final String storeEmail;
  final String? logo;
  final String? featuredImage;
  final String workingHoursStart;
  final String workingHoursEnd;
  final bool isActive;

  StoreModel({
    required this.id,
    required this.storeName,
    required this.description,
    required this.storePhoneNumber,
    required this.address,
    required this.storeEmail,
    this.logo,
    this.featuredImage,
    required this.workingHoursStart,
    required this.workingHoursEnd,
    required this.isActive,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as int,
      storeName: json['storeName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      storePhoneNumber: json['storePhoneNumber']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      storeEmail: json['storeEmail']?.toString() ?? '',
      logo: ApiService.resolveUrl(json['logo']?.toString()),
      featuredImage: ApiService.resolveUrl(json['featuredImage']?.toString()),
      workingHoursStart: json['workingHoursStart']?.toString() ?? '',
      workingHoursEnd: json['workingHoursEnd']?.toString() ?? '',
      isActive: json['isActive'] == true,
    );
  }
}

List<StoreModel> storeListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
    .toList();
