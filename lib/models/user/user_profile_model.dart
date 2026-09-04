import '../../core/utils/api_service.dart';

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

  /// Roles the account holds, e.g. `['User', 'Admin']`.
  ///
  /// `SuperAdmin/ActiveUsers` does not return this yet - it comes back empty
  /// against the current server. Everything that reads it therefore treats
  /// "no roles" as a plain customer, and starts working the moment the
  /// backend adds the field, with no further change here.
  final List<String> roles;

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
    this.roles = const [],
  });

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'].toString(),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      profilePhoto: ApiService.resolveUrl(json['profilePhoto']?.toString()),
      birthDate: DateTime.parse(json['birthDate'].toString()),
      gender: json['gender']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      roles: _rolesFromJson(json['roles'] ?? json['role']),
    );
  }
}

/// Accepts either `["Admin"]` or `[{"name":"Admin"}]`, which are the two
/// shapes the API uses for roles elsewhere (login returns the latter).
List<String> _rolesFromJson(dynamic value) {
  if (value is String) return value.isEmpty ? const [] : [value];
  if (value is! List) return const [];
  final out = <String>[];
  for (final entry in value) {
    if (entry is String) {
      out.add(entry);
    } else if (entry is Map && entry['name'] != null) {
      out.add(entry['name'].toString());
    }
  }
  return out;
}
