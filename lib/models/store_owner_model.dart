import 'dart:io';

class OwnerInfo {
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;
  final File identityFront;
  final File identityBack;
  OwnerInfo({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.identityFront,
    required this.identityBack,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "birth_date": birthDate,
    };
  }
}