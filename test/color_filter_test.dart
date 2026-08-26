import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/core/constants/product_enums.dart';

/// The customer colour filter used to return an empty list for *every*
/// colour: the swatches carry "أبيض" (with hamza) while the catalog stores
/// "ابيض" (without), and `Product/GetFilter` matches the string exactly.
///
/// The expected query values below were confirmed against the live API:
/// `GetFilter?color=اسود` -> 18 products, `?color=أسود` -> 0.
void main() {
  group('Arabic colour normalisation', () {
    test('folds every hamza form onto a bare alef', () {
      expect(normalizeColorName('أبيض'), 'ابيض');
      expect(normalizeColorName('إبيض'), 'ابيض');
      expect(normalizeColorName('آبيض'), 'ابيض');
    });

    test('trims the stray whitespace present in the catalog', () {
      // One stored value is literally " ابيض".
      expect(normalizeColorName(' ابيض'), 'ابيض');
    });

    test('leaves an already-normal name untouched', () {
      expect(normalizeColorName('اسود'), 'اسود');
    });
  });

  group('queryName is what the API matches', () {
    test('black and white resolve to the stored spelling', () {
      final black = swatchForColorName('black')!;
      final white = swatchForColorName('white')!;
      expect(black.queryName, 'اسود');
      expect(white.queryName, 'ابيض');
    });

    test('no main colour would be sent with a hamza', () {
      for (final swatch in mainColorSwatches()) {
        expect(
          swatch.queryName,
          isNot(contains('أ')),
          reason: '${swatch.key} would match nothing',
        );
      }
    });
  });

  group('resolving a colour by name', () {
    test('accepts the English name the filter now carries', () {
      expect(swatchForColorName('red')?.key, 'red');
      expect(swatchForColorName('WHITE')?.key, 'white');
    });

    test('accepts either Arabic spelling', () {
      expect(swatchForColorName('أسود')?.key, 'black');
      expect(swatchForColorName('اسود')?.key, 'black');
      expect(swatchForColorName(' ابيض')?.key, 'white');
    });

    test('pink resolves from either spelling to the stored one', () {
      // The catalog uses زهري; وردي is the spelling the swatch used to send,
      // which matched nothing.
      expect(swatchForColorName('زهري')?.key, 'pink');
      expect(swatchForColorName('وردي')?.key, 'pink');
      expect(swatchForColorName('pink')!.queryName, 'زهري');
    });

    test('returns null for a free-form colour', () {
      expect(swatchForColorName('turquoise-ish'), isNull);
    });

    test('hex lookup works from any spelling', () {
      expect(hexForColorName('اسود'), '#000000');
      expect(hexForColorName('أسود'), '#000000');
      expect(hexForColorName('black'), '#000000');
    });
  });

  group('main colours', () {
    test('is a short list, and a subset of all swatches', () {
      final main = mainColorSwatches();
      expect(main, isNotEmpty);
      expect(main.length, lessThan(kColorSwatches.length));
      for (final swatch in main) {
        expect(kColorSwatches, contains(swatch));
      }
    });

    test('excludes the shade-only colours', () {
      final keys = mainColorSwatches().map((s) => s.key);
      expect(keys, isNot(contains('silver')));
      expect(keys, isNot(contains('navy')));
      expect(keys, isNot(contains('beige')));
      expect(keys, isNot(contains('gold')));
    });

    test('includes the primaries', () {
      final keys = mainColorSwatches().map((s) => s.key);
      for (final k in ['red', 'white', 'black', 'blue', 'green']) {
        expect(keys, contains(k));
      }
    });
  });
}
