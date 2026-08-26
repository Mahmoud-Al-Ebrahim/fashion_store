import 'dart:convert';

import 'package:signalr_netcore/signalr_client.dart';

/// A SignalR HTTP client that reads response bodies as UTF-8.
///
/// The hub's long-polling responses come back as
/// `Content-Type: application/octet-stream` with **no charset**. `package:
/// http` follows the HTTP spec and falls back to latin1 in that case, so
/// every non-ASCII character arrived mangled: a message sent as
/// `مرحبا كيف حالك` was rendered `ÙØ±Ø­Ø¨Ø§ ÙÙÙ Ø­Ø§ÙÙ`. It looked
/// self-correcting only because the screen re-pulled the history over REST,
/// which *does* declare `charset=utf-8`, a moment later.
///
/// latin1 maps bytes 0x00-0xFF onto the identical code points, so the
/// mis-decode loses nothing and can be undone exactly: re-encode the string
/// back to those bytes and decode them properly.
class Utf8SignalRHttpClient extends WebSupportingHttpClient {
  Utf8SignalRHttpClient() : super(null);

  @override
  Future<SignalRHttpResponse> send(SignalRHttpRequest request) async {
    final response = await super.send(request);
    final content = response.content;
    if (content is! String) return response;

    final repaired = repairLatin1Utf8(content);
    if (repaired == content) return response;

    return SignalRHttpResponse(
      response.statusCode,
      statusText: response.statusText,
      content: repaired,
    );
  }
}

/// Undoes a latin1 decode of UTF-8 bytes, leaving anything else untouched.
///
/// Returns [value] unchanged when it cannot have been mis-decoded (it holds
/// a code point above 0xFF, so it is already real Unicode) or when the
/// recovered bytes are not valid UTF-8 (it really was latin1 text). Pure
/// ASCII round-trips to itself, so the common case is a no-op.
String repairLatin1Utf8(String value) {
  var suspect = false;
  for (final unit in value.codeUnits) {
    if (unit > 0xFF) return value;
    if (unit > 0x7F) suspect = true;
  }
  // All ASCII: nothing to repair, and decoding would just return the same
  // string at the cost of two conversions.
  if (!suspect) return value;

  try {
    // Strict: throws when the bytes are not well-formed UTF-8, which is the
    // signal that the text was genuinely latin1 and must be left alone.
    return utf8.decode(latin1.encode(value));
  } on FormatException {
    return value;
  }
}
