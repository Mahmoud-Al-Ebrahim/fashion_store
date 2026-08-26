import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/core/utils/json_parse.dart';
import 'package:fashion_store/models/clothing_item/clothing_item_model.dart';
import 'package:fashion_store/models/comment/comment_model.dart';
import 'package:fashion_store/models/product/product_catalog_model.dart';
import 'package:fashion_store/models/rating/rating_model.dart';

/// The product details screen used to throw "Null check operator used on a
/// null value" whenever the API left a field out - a product with no rating,
/// a comment without a timestamp, a price returned as a string. Parsing now
/// degrades to a sensible default instead of taking the screen down.
void main() {
  group('readers tolerate missing and oddly-typed values', () {
    test('asInt', () {
      expect(asInt(5), 5);
      expect(asInt(5.9), 5);
      expect(asInt('7'), 7);
      expect(asInt(null), 0);
      expect(asInt('not a number'), 0);
      expect(asInt(null, fallback: -1), -1);
    });

    test('asDouble', () {
      expect(asDouble(2), 2.0);
      expect(asDouble('2.5'), 2.5);
      expect(asDouble(null), 0);
      expect(asDouble('abc'), 0);
    });

    test('asString never yields the text "null"', () {
      expect(asString(null), '');
      expect(asString('x'), 'x');
      expect(asString(3), '3');
      // The old `json['x'].toString()` produced a literal "null" on screen.
      expect(asString(null), isNot('null'));
    });

    test('asStringOrNull collapses blanks to null', () {
      expect(asStringOrNull(null), isNull);
      expect(asStringOrNull(''), isNull);
      expect(asStringOrNull('a'), 'a');
    });

    test('asDate falls back instead of throwing', () {
      expect(asDateOrNull(null), isNull);
      expect(asDateOrNull('nonsense'), isNull);
      expect(asDate(null).millisecondsSinceEpoch, 0);
      expect(asDate('2026-08-20T15:36:52').year, 2026);
    });

    test('asBool', () {
      expect(asBool(true), isTrue);
      expect(asBool('true'), isTrue);
      expect(asBool(null), isFalse);
      expect(asBool(1), isTrue);
    });
  });

  group('product detail models survive a sparse payload', () {
    test('a catalog product with only an id', () {
      final model = ProductCatalogModel.fromJson({'id': 11});
      expect(model.id, 11);
      expect(model.name, '');
      expect(model.price, 0);
      expect(model.priceAfterDiscount, 0);
      expect(model.discountPercentage, isNull);
      expect(model.discountStartDate, isNull);
    });

    test('an entirely empty catalog payload does not throw', () {
      expect(() => ProductCatalogModel.fromJson({}), returnsNormally);
    });

    test('a comment with no timestamp', () {
      expect(() => CommentModel.fromJson({'commentId': 1}), returnsNormally);
    });

    test('a rating with no value', () {
      final model = RatingModel.fromJson({'productId': 3});
      expect(model.productId, 3);
      expect(model.ratingValue, 0);
    });

    test('a colour entry with no sizes', () {
      expect(() => ClothingItemModel.fromJson({'id': 1}), returnsNormally);
    });

    test('prices arriving as strings still parse', () {
      final model = ProductCatalogModel.fromJson({
        'id': 1,
        'price': '1500',
        'priceAfterDiscount': '1200.5',
      });
      expect(model.price, 1500);
      expect(model.priceAfterDiscount, 1200.5);
    });
  });
}
