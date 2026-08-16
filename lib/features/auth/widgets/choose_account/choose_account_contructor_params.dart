import 'dart:io';

class ChooseAccountConstructorParams {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String birthDate;
  final String userType;
  final String? location;
  final String? information;
  final String? storeName;
  final File? storeLogo;
  final File? storeMainImage;
  final File? identity1;
  final File? identity2;
  final double? latitude;
  final double? longitude;
  final String? workingHours;

  ChooseAccountConstructorParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.birthDate,
    this.latitude,
    this.longitude,
    this.storeMainImage,
    this.identity1,
    this.identity2,
    required this.userType,
    this.location,
    this.workingHours,
    this.information,
    this.storeLogo,
    this.storeName,
  });
}
