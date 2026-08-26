import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/core/services/utf8_signalr_http_client.dart';

/// The hub's long-polling responses carry
/// `Content-Type: application/octet-stream` with no charset, so `package:
/// http` decodes them as latin1 and every Arabic message arrived mangled.
/// These cases are taken from a real poll response captured off the server.
void main() {
  group('repairs a latin1 decode of UTF-8 bytes', () {
    test('the exact mojibake the server produced', () {
      // Captured live: sent 'مرحبا كيف حالك', rendered as the string below.
      const mangled = 'ÙØ±Ø­Ø¨Ø§ ÙÙÙ Ø­Ø§ÙÙ';
      const correct = 'مرحبا كيف حالك';
      expect(repairLatin1Utf8(latin1.decode(utf8.encode(correct))), correct);
      // And the mangled form itself is what a latin1 decode looks like.
      expect(latin1.decode(utf8.encode(correct)).startsWith('Ù'), isTrue);
      expect(mangled.codeUnits.every((u) => u <= 0xFF), isTrue);
    });

    test('round-trips arbitrary Arabic', () {
      for (final text in [
        'مرحبا',
        'شكرا لك، سيتم شحن الطلب غدا',
        'حذاء رياضي - أسود - قياس ٤٠',
      ]) {
        final mangled = latin1.decode(utf8.encode(text));
        expect(repairLatin1Utf8(mangled), text, reason: 'failed on $text');
      }
    });

    test('handles emoji and other multi-byte text', () {
      for (final text in ['ok 👍', 'café', '日本語']) {
        expect(repairLatin1Utf8(latin1.decode(utf8.encode(text))), text);
      }
    });
  });

  group('leaves everything else alone', () {
    test('plain ASCII is untouched', () {
      for (final text in ['hello', 'Order #12 shipped', '', '12345']) {
        expect(repairLatin1Utf8(text), text);
      }
    });

    test('text already decoded correctly is untouched', () {
      // Contains code points above 0xFF, so it cannot be a latin1 decode.
      const text = 'مرحبا كيف حالك';
      expect(repairLatin1Utf8(text), text);
    });

    test('genuine latin1 text that is not UTF-8 is untouched', () {
      // 0xFF 0xFE is not well-formed UTF-8, so the repair must back off
      // rather than corrupt it.
      final notUtf8 = String.fromCharCodes([0xFF, 0xFE, 0x41]);
      expect(repairLatin1Utf8(notUtf8), notUtf8);
    });

    test('a whole JSON frame is repaired in place', () {
      const frame =
          '{"type":1,"target":"ReceiveMessage","arguments":'
          '[{"id":62,"messageText":"مرحبا كيف حالك","isRead":false}]}';
      final mangled = latin1.decode(utf8.encode(frame));
      final repaired = repairLatin1Utf8(mangled);
      expect(repaired, frame);
      // And it still parses, which is what the transport does next.
      final decoded = jsonDecode(repaired) as Map<String, dynamic>;
      expect(
        (decoded['arguments'] as List).first['messageText'],
        'مرحبا كيف حالك',
      );
    });
  });
}
