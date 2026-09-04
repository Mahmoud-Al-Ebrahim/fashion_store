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
  return asDateOrNull(value) ??
      fallback ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? asDateOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value.toString();
  if (text.isEmpty || text == 'null') return null;
  return DateTime.tryParse(text);
}

/// Parses a server timestamp that carries no timezone designator, as UTC.
///
/// The API serialises DateTimes bare - `2026-09-02T13:18:45.3350146`, no
/// trailing `Z` and no `+03:00` - and the values are UTC. `DateTime.parse`
/// reads an offset-less string as *local* time, so the subsequent
/// `.toLocal()` was a no-op and every chat message rendered three hours
/// early in Damascus (UTC+3).
///
/// A value that *does* carry an offset (or a `Z`) is parsed as given, so
/// this stays correct if the backend starts emitting one.
DateTime? asServerDateOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  var text = value.toString().trim();
  if (text.isEmpty || text == 'null') return null;

  if (_needsUtcMarker(text)) text = '${text}Z';
  return DateTime.tryParse(text)?.toLocal();
}

/// True when a `Z` has to be appended for the value to read as UTC.
///
/// False when the string already states its zone - a trailing `Z`, or a
/// `+hh:mm` / `-hh:mm` offset - and false for a date with no time at all:
/// `DateTime.parse` only accepts a zone after a time, so `2026-09-02Z`
/// would fail to parse where `2026-09-02` succeeds.
bool _needsUtcMarker(String text) {
  if (text.endsWith('Z') || text.endsWith('z')) return false;

  // The separator is `T` in ISO-8601, though a space is also accepted.
  var timeStart = text.indexOf('T');
  if (timeStart < 0) timeStart = text.indexOf(' ');
  if (timeStart < 0) return false;

  // Search past the separator so the dashes in the date are not mistaken
  // for a negative offset.
  final time = text.substring(timeStart);
  return !time.contains('+') && !time.contains('-');
}

/// [asServerDateOrNull] with the epoch as the fallback, matching [asDate].
DateTime asServerDate(dynamic value) =>
    asServerDateOrNull(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
