import 'package:dio/dio.dart';

/// Extracts a user-friendly error message from a failed API call.
/// Falls back to a generic Arabic message when the server didn't
/// return the usual `{ message, errors }` envelope (e.g. network errors).
String apiErrorMessage(dynamic error) {
  try {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.map((e) => e.toString()).join('\n');
        }
      }
    }
  } catch (_) {
    // fall through to generic message
  }
  return 'حدث خطأ ما، حاول مرة أخرى';
}
