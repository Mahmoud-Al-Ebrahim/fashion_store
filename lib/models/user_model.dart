class NormalUserInfo {
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;

  NormalUserInfo({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
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