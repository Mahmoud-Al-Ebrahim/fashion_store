import 'dart:convert';

/// Minimal JWT payload decoder (no signature verification - the token is
/// already trusted since it was issued by our own backend over HTTPS).
class JwtHelper {
  JwtHelper._();

  static const String _nameClaim =
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name';
  static const String _userIdClaim =
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';
  static const String _roleClaim =
      'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

  static Map<String, dynamic> decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      final normalized = base64Url.normalize(parts[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static String? getUserId(String token) =>
      decodePayload(token)[_userIdClaim] as String?;

  static String? getUserName(String token) =>
      decodePayload(token)[_nameClaim] as String?;

  static List<String> getRoles(String token) {
    final payload = decodePayload(token);
    final roles = payload[_roleClaim];
    if (roles is List) return roles.map((e) => e.toString()).toList();
    if (roles is String) return [roles];
    return [];
  }
}
