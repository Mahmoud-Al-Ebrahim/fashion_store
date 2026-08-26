import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/core/utils/validators.dart';

/// Whether a customer may still withdraw an order.
///
/// Mirrors the rule in `OrderDetailsPage`. It keys off the *order* status,
/// not the payment: the API reports `Paid` for every order it has ever
/// created, cancelled ones included, so a payment-based rule would either
/// block everything or allow everything.
bool canCancel(String orderStatus) => orderStatus == 'Processing';

void main() {
  group('a customer may only cancel an order still being processed', () {
    test('processing can be cancelled', () {
      expect(canCancel('Processing'), isTrue);
    });

    test('delivered cannot be cancelled', () {
      expect(canCancel('Delivered'), isFalse);
    });

    test('already cancelled cannot be cancelled again', () {
      expect(canCancel('Cancelled'), isFalse);
    });

    test('covers every status the API defines', () {
      // enOrderStatus = Processing | Cancelled | Delivered
      const all = ['Processing', 'Cancelled', 'Delivered'];
      final allowed = all.where(canCancel).toList();
      expect(allowed, ['Processing']);
    });
  });

  group('minimum sign-up age', () {
    String iso(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

    test('the floor is 12', () {
      expect(kMinimumSignUpAge, 12);
    });

    test('exactly 12 today is accepted', () {
      final now = DateTime.now();
      final twelveToday = DateTime(now.year - 12, now.month, now.day);
      expect(validateBirthDate(iso(twelveToday)), isNull);
    });

    test('one day short of 12 is rejected', () {
      final now = DateTime.now();
      final almost = DateTime(now.year - 12, now.month, now.day)
          .add(const Duration(days: 1));
      expect(validateBirthDate(iso(almost)), isNotNull);
    });

    test('a young child is rejected', () {
      final now = DateTime.now();
      expect(
        validateBirthDate(iso(DateTime(now.year - 5, now.month, now.day))),
        isNotNull,
      );
    });

    test('an adult well over 18 is accepted', () {
      // The old picker bounded `firstDate` at 18 years ago, so a 40-year-old
      // could not enter their real birth date at all.
      final now = DateTime.now();
      expect(
        validateBirthDate(iso(DateTime(now.year - 40, now.month, now.day))),
        isNull,
      );
      expect(
        validateBirthDate(iso(DateTime(now.year - 80, now.month, now.day))),
        isNull,
      );
    });

    test('blank and malformed values are rejected', () {
      expect(validateBirthDate(null), isNotNull);
      expect(validateBirthDate(''), isNotNull);
      expect(validateBirthDate('not a date'), isNotNull);
    });
  });
}
