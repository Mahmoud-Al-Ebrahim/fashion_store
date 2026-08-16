import 'dart:io';

class StoreInfo {
  final String storeName;
  final String description;
  final String address;
  final String workingHours;

  final double? latitude;
  final double? longitude;

  final File logo;
  final File mainImage;

  StoreInfo({
    required this.storeName,
    required this.description,
    required this.address,
    required this.workingHours,
    required this.latitude,
    required this.longitude,
    required this.logo,
    required this.mainImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "store_name": storeName,
      "description": description,
      "address": address,
      "working_hours": workingHours,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}