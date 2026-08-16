/// Response model for `POST Auth/RefreshToken` -> `data`.
class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresIn;

  RefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json['accessToken'].toString(),
      refreshToken: json['refreshToken'].toString(),
      expiresIn: DateTime.parse(json['expiresIn'].toString()),
    );
  }
}
