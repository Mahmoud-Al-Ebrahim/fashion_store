/// Response model for `GET User/GetUserProfile` -> `data`.
class UserProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePhoto;
  final DateTime birthDate;
  final String gender; // enGender: Male | Female
  final String userName;
  final String email;
  final String phoneNumber;

  UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePhoto,
    required this.birthDate,
    required this.gender,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'].toString(),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      profilePhoto: json['profilePhoto']?.toString(),
      birthDate: DateTime.parse(json['birthDate'].toString()),
      gender: json['gender']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
    );
  }
}
