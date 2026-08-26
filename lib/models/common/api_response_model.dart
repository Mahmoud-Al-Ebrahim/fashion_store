/// Generic wrapper matching every MarketExpress API response envelope:
/// { "statusCode": int, "success": bool, "message": string, "data": T|null, "errors": [] }
class ApiResponseModel<T> {
  final int statusCode;
  final bool success;
  final String message;
  final T? data;
  final List<String> errors;

  ApiResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
    this.errors = const [],
  });

  /// [fromData] converts the raw `data` json into the typed [T]. Omit it when
  /// [T] is a primitive (e.g. `int`, `String`) already matching the raw json.
  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic rawData)? fromData,
  ]) {
    final rawData = json['data'];
    return ApiResponseModel<T>(
      statusCode: json['statusCode'] is int ? json['statusCode'] : 0,
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData == null
          ? null
          : (fromData != null ? fromData(rawData) : rawData as T),
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
