/// Response model for `POST Auth/Login` -> `data`.
class LoginResponseModel {
  final List<String> roles;
  final String accessToken;
  final String refreshTokenString;
  final String refreshUserName;
  final DateTime refreshTokenExpireIn;

  LoginResponseModel({
    required this.roles,
    required this.accessToken,
    required this.refreshTokenString,
    required this.refreshUserName,
    required this.refreshTokenExpireIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final roles = (json['getRoles'] as List<dynamic>? ?? [])
        .map((e) => (e as Map<String, dynamic>)['name'].toString())
        .toList();
    final jwt = json['jwtAuthResult'] as Map<String, dynamic>;
    final refresh = jwt['refreshToken'] as Map<String, dynamic>;
    return LoginResponseModel(
      roles: roles,
      accessToken: jwt['accessToken'].toString(),
      refreshTokenString: refresh['refreshTokenString'].toString(),
      refreshUserName: refresh['userName'].toString(),
      refreshTokenExpireIn: DateTime.parse(refresh['expireIn'].toString()),
    );
  }
}
