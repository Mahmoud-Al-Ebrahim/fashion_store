/// Null-tolerant readers for API payloads.
///
/// The catalog endpoints omit fields rather than sending nulls, and a few
/// send numbers as strings. Casting straight to `int`/`num` therefore threw
/// on perfectly ordinary responses - a product with no rating yet, or a
/// comment the server returned without `createdAt`, crashed the details
/// screen instead of just rendering without that piece.
library;

/// Reads an integer, accepting `int`, `double`, or a numeric string.
int asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

/// Same as [asInt] but keeps null as null, for genuinely optional ids.
int? asIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Reads a double, accepting `num` or a numeric string.
double asDouble(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

double? asDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Reads a string, mapping null to [fallback] rather than the text "null".
String asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString();
  return text == 'null' ? fallback : text;
}

/// Reads a string, keeping null (and blank) as null.
String? asStringOrNull(dynamic value) {
  final text = asString(value);
  return text.isEmpty ? null : text;
}

bool asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;
  }
  return fallback;
}

/// Parses a date, falling back to the epoch rather than throwing.
///
/// A missing timestamp should render as "unknown", never take the screen
/// down with it.
DateTime asDate(dynamic value, {DateTime? fallback}) {
  return asDateOrNull(value) ?? fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? asDateOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString();
  if (text.isEmpty || text == 'null') return null;
  return DateTime.tryParse(text);
}
