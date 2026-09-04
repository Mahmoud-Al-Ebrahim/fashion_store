import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/core/utils/json_parse.dart';
import 'package:fashion_store/models/complaint/message_model.dart';

/// Chat messages rendered three hours early in Damascus.
///
/// The API serialises timestamps bare - `2026-09-02T13:18:45.3350146`, no
/// trailing `Z`, no `+03:00` - and those values are UTC. `DateTime.parse`
/// reads an offset-less string as *local* time, so the `.toLocal()` that
/// followed was a no-op and the raw UTC clock reading went straight to the
/// bubble. In UTC+3 that is exactly three hours behind the real send time.
void main() {
  group('bare server timestamps are UTC', () {
    test('an offset-less value is read as UTC, not as local time', () {
      final parsed = asServerDateOrNull('2026-09-02T13:18:45.3350146')!;
      expect(parsed.toUtc().hour, 13);
      expect(parsed.toUtc().minute, 18);

      // The old behaviour: parsed as local, so the UTC reading drifted by
      // the zone offset. Only a UTC-zero machine sees no difference.
      final naive = DateTime.parse('2026-09-02T13:18:45.3350146');
      if (naive.timeZoneOffset != Duration.zero) {
        expect(naive.toUtc().hour, isNot(13));
      }
    });

    test('the returned value is in local time', () {
      final parsed = asServerDateOrNull('2026-09-02T13:18:45')!;
      expect(parsed.isUtc, isFalse);
      expect(
        parsed.difference(DateTime.utc(2026, 9, 2, 13, 18, 45)),
        Duration.zero,
      );
    });

    test('a value that already states its zone is left alone', () {
      final zulu = asServerDateOrNull('2026-09-02T13:18:45Z')!;
      final offset = asServerDateOrNull('2026-09-02T16:18:45+03:00')!;
      expect(zulu.toUtc(), DateTime.utc(2026, 9, 2, 13, 18, 45));
      expect(offset.toUtc(), DateTime.utc(2026, 9, 2, 13, 18, 45));
    });

    test('a date with no time still parses', () {
      // `DateTime.parse` only accepts a zone after a time, so appending a
      // `Z` to a bare date would make it unparseable.
      expect(asServerDateOrNull('2026-09-02'), isNotNull);
    });

    test('junk and blanks stay null rather than throwing', () {
      expect(asServerDateOrNull(null), isNull);
      expect(asServerDateOrNull(''), isNull);
      expect(asServerDateOrNull('null'), isNull);
      expect(asServerDateOrNull('not a date'), isNull);
      expect(
        asServerDate('not a date'),
        DateTime.fromMillisecondsSinceEpoch(0),
      );
    });
  });

  group('MessageModel', () {
    test('reads sentAt as a UTC instant', () {
      final message = MessageModel.fromJson(const {
        'id': 98,
        'senderId': '2caae590',
        'senderName': 'test',
        'messageText': 'hi',
        'sentAt': '2026-09-02T13:18:45.3350146',
        'isRead': false,
        'isEdited': false,
      });
      expect(message.createdAt.toUtc().hour, 13);
      expect(message.createdAt.isUtc, isFalse);
    });
  });
}
