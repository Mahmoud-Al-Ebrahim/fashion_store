import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'my_shared_pref.dart';

class ApiService {
  static late Dio _dio;
  static const String baseUrl = 'https://www.marketexpress.somee.com'; // MarketExpress API server url
  static late Uri baseUri;
  static String? token;
  static String prefix = '/api/';

  static init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    baseUri = Uri.parse(baseUrl);
    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    }
    BaseOptions options = BaseOptions(
      headers: headers,
      contentType: 'application/json',
      responseType: ResponseType.json,
      baseUrl: baseUrl,
    );
    _dio = Dio(options);
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(onError: (error, handler) async {
        final requestOptions = error.requestOptions;
        final isRefreshCall = requestOptions.path.contains('Auth/RefreshToken');
        if (error.response?.statusCode == 401 && !isRefreshCall) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            requestOptions.headers[HttpHeaders.authorizationHeader] =
                'Bearer $token';
            try {
              final retryResponse = await _dio.fetch(requestOptions);
              return handler.resolve(retryResponse);
            } catch (_) {
              // fall through to original error
            }
          } else {
            await clearAuth();
          }
        }
        return handler.next(error);
      }),
    );
  }

  /// Attempts to refresh the access token using the stored refresh token.
  /// Returns true if a new access token was obtained and persisted.
  static Future<bool> _tryRefreshToken() async {
    final refreshToken = MySharedPref.getRefreshToken();
    if (token == null || refreshToken == null) return false;
    try {
      final dioForRefresh = Dio(BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
        responseType: ResponseType.json,
      ));
      final response = await dioForRefresh.postUri(
        Uri(host: baseUri.host, scheme: baseUri.scheme, path: '${prefix}Auth/RefreshToken'),
        data: {'accessToken': token, 'refreshToken': refreshToken},
      );
      final data = response.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        final newAccessToken = data['data']['accessToken'] as String;
        final newRefreshToken = data['data']['refreshToken'] as String;
        await setAuthToken(newAccessToken);
        await MySharedPref.saveRefreshToken(newRefreshToken);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Updates the in-memory token, the Dio default header, and persists it.
  static Future<void> setAuthToken(String? newToken) async {
    token = newToken;
    if (newToken == null) {
      _dio.options.headers.remove(HttpHeaders.authorizationHeader);
      await MySharedPref.clearToken();
    } else {
      _dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';
      await MySharedPref.saveToken(newToken);
    }
  }

  /// Clears the access token and refresh token (used on logout / forced sign-out).
  static Future<void> clearAuth() async {
    await setAuthToken(null);
    await MySharedPref.clearRefreshToken();
  }

  /// Some image fields come back as full URLs (Cloudinary), others as
  /// server-relative paths (`/uploads/xxx.jpg`). This resolves either into a
  /// displayable absolute URL.
  static String? resolveUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return path.startsWith('/') ? '$baseUrl$path' : '$baseUrl/$path';
  }
  // end point means the suffix string after the server url (no leading '/api/')

  static Future<Response> postMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
        String? bodyAsString,
        dynamic form ,
      Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
     return _dio.postUri(uri, data: form ?? bodyAsString ?? body);
  }

  static Future<Response> putMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
        String? bodyAsString,
        dynamic form,
      Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.putUri(uri, data: form ?? bodyAsString ?? body);
  }

  static Future<Response> getMethod(
      {required String endPoint, Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.getUri(uri); // get request does not contain a body
  }

  static Future<Response> deleteMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
      dynamic body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path:prefix +  endPoint,
      queryParameters: queryParameters,
    );
    return _dio.deleteUri(uri, data: body);
  }
  static Future<Response> patchMethod(
      {required String endPoint, Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
    );
    return _dio.patchUri(uri,data: body); // get request does not contain a body
  }
  // static Future<Response> patchMethodForImage(
  //     {required String endPoint, required File file}) async {
  //   String fileName = file.path.split('/').last;
  //   String mimeType = mime(fileName) ?? '';
  //   String mimee = mimeType.split('/')[0];
  //   String type = mimeType.split('/')[1];
  //   Uri uri = Uri(
  //     host: baseUri.host,
  //     port: 9000,
  //     scheme: baseUri.scheme,
  //     path: prefix + endPoint,
  //   );
  //   return _dio.patchUri(uri,data: FormData.fromMap(
  //       {
  //         "photo": await MultipartFile.fromFile(
  //           file.path,
  //           filename: fileName,
  //           contentType: MediaType(mimee, type),
  //         ),
  //       }
  //   )); // get request does not contain a body
  // }
}
