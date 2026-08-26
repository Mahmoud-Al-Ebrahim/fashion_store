import 'package:easy_localization/easy_localization.dart';

import '../localization/translation_keys.dart';

/// A selectable option: [value] is what the API receives, [label] is the
/// localized text shown to the user.
class PickerOption {
  final String value;
  final String label;

  const PickerOption(this.value, this.label);
}

/// API enum values. Labels are resolved through easy_localization at call
/// time so switching language updates every picker.

const List<String> kGenderValues = ['Male', 'Female'];
const List<String> kSeasonValues = ['Summer', 'Spring', 'Autumn', 'Winter'];
const List<String> kTypeValues = [
  'Pants',
  'Skirt',
  'Dress',
  'ShortPants',
  'Shirt',
  'T_shirt',
  'Shoes',
  'SportSet',
];
const List<String> kClothingSizeValues = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
const List<String> kShoeSizeValues = [
  'Shoe36',
  'Shoe37',
  'Shoe38',
  'Shoe39',
  'Shoe40',
  'Shoe41',
  'Shoe42',
  'Shoe43',
  'Shoe44',
  'Shoe45',
];
const List<String> kOrderStatusValues = ['Processing', 'Cancelled', 'Delivered'];

List<PickerOption> genderOptions() =>
    kGenderValues.map((v) => PickerOption(v, LK.genderKey(v).tr())).toList();

List<PickerOption> seasonOptions() =>
    kSeasonValues.map((v) => PickerOption(v, LK.seasonKey(v).tr())).toList();

List<PickerOption> typeOptions() =>
    kTypeValues.map((v) => PickerOption(v, LK.typeKey(v).tr())).toList();

/// Shoe sizes display as the plain number ("40"), clothing sizes as-is ("M").
String sizeLabel(String value) =>
    value.startsWith('Shoe') ? value.replaceFirst('Shoe', '') : value;

List<PickerOption> clothingSizeOptions() =>
    kClothingSizeValues.map((v) => PickerOption(v, sizeLabel(v))).toList();

List<PickerOption> shoeSizeOptions() =>
    kShoeSizeValues.map((v) => PickerOption(v, sizeLabel(v))).toList();

List<PickerOption> allSizeOptions() => [
      ...clothingSizeOptions(),
      ...shoeSizeOptions(),
    ];

List<PickerOption> orderStatusOptions() => kOrderStatusValues
    .map((v) => PickerOption(v, LK.statusKey(v).tr()))
    .toList();

/// A named colour offered when a store owner adds a product colour.
///
/// [apiName] is the Arabic name actually persisted to the backend - the
/// existing catalog stores colour names in Arabic, so we keep writing them
/// that way regardless of UI language to avoid fragmenting the data. [key]
/// drives the localized display label.
class ProductColorSwatch {
  /// Stable English identity - `red`, `white`, ... This is the colour's
  /// *name*, and it is what the app keys filters and translations off.
  final String key;
  final String hex;

  /// Spelling used when writing a colour to the API.
  final String apiName;

  /// Shown in the customer's colour filter. Shades that only differ by tone
  /// (silver, navy, beige, gold) are excluded so the filter stays a short
  /// list of main colours.
  final bool isMain;

  const ProductColorSwatch(
    this.key,
    this.hex,
    this.apiName, {
    this.isMain = false,
  });

  String get label => LK.colorKey(key).tr();

  /// Value to send as `GetFilter?color=`.
  ///
  /// The catalog stores Arabic colour names *without* the hamza ("ابيض"),
  /// while [apiName] carries the correct spelling ("أبيض"). `GetFilter`
  /// matches the string exactly, so filtering on [apiName] matched nothing
  /// at all - every colour returned an empty list. Normalising here is what
  /// makes the filter select rows.
  String get queryName => normalizeColorName(apiName);
}

/// Folds the spelling variants the catalog contains onto one form.
///
/// Handles the hamza forms (أ إ آ -> ا), the two ya forms (ى -> ي), the two
/// ta forms (ة -> ه) and stray surrounding whitespace - one stored value is
/// literally " ابيض" with a leading space.
String normalizeColorName(String value) {
  return value
      .trim()
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');
}

const List<ProductColorSwatch> kColorSwatches = [
  ProductColorSwatch('white', '#FFFFFF', 'أبيض', isMain: true),
  ProductColorSwatch('black', '#000000', 'أسود', isMain: true),
  ProductColorSwatch('red', '#FF0000', 'أحمر', isMain: true),
  ProductColorSwatch('blue', '#0000FF', 'أزرق', isMain: true),
  ProductColorSwatch('green', '#008000', 'أخضر', isMain: true),
  ProductColorSwatch('yellow', '#FFFF00', 'أصفر', isMain: true),
  ProductColorSwatch('gray', '#808080', 'رمادي', isMain: true),
  ProductColorSwatch('brown', '#8B4513', 'بني', isMain: true),
  // The catalog stores زهري for pink, not وردي - filtering on the
  // latter matched nothing, and writing it would split the data in two.
  ProductColorSwatch('pink', '#FFB6C1', 'زهري', isMain: true),
  ProductColorSwatch('purple', '#800080', 'بنفسجي', isMain: true),
  ProductColorSwatch('orange', '#FFA500', 'برتقالي', isMain: true),
  ProductColorSwatch('silver', '#C0C0C0', 'فضي'),
  ProductColorSwatch('gold', '#FFD700', 'ذهبي'),
  ProductColorSwatch('navy', '#000080', 'كحلي'),
  ProductColorSwatch('beige', '#F5F5DC', 'بيج'),
];

/// Existing catalog data uses a few colour spellings that differ from
/// [kColorSwatches] (e.g. "اسود" without the hamza). Map those onto the same
/// key so they still translate.
const Map<String, String> _colorAliases = {
  'اسود': 'black',
  'ابيض': 'white',
  'احمر': 'red',
  'ازرق': 'blue',
  'اخضر': 'green',
  'اصفر': 'yellow',
  'زهري': 'pink',
  'وردي': 'pink',
  'رمادى': 'gray',
};

/// Translates a colour name coming back from the API. Unknown/free-form
/// colours fall back to the raw stored value.
String localizedColorName(String apiName) {
  final swatch = swatchForColorName(apiName);
  if (swatch != null) return swatch.label;
  final aliasKey = _colorAliases[normalizeColorName(apiName)];
  if (aliasKey != null) return LK.colorKey(aliasKey).tr();
  return apiName.trim();
}

/// Resolves any stored spelling - or an English key like `red` - onto its
/// swatch. Returns null for a free-form colour the catalog invented.
ProductColorSwatch? swatchForColorName(String value) {
  final normalized = normalizeColorName(value);
  final lower = normalized.toLowerCase();
  for (final swatch in kColorSwatches) {
    if (swatch.queryName == normalized || swatch.key == lower) return swatch;
  }
  final aliasKey = _colorAliases[normalized];
  if (aliasKey != null) {
    for (final swatch in kColorSwatches) {
      if (swatch.key == aliasKey) return swatch;
    }
  }
  return null;
}

/// The main colours offered in the customer's filter.
List<ProductColorSwatch> mainColorSwatches() =>
    kColorSwatches.where((swatch) => swatch.isMain).toList();

/// Best-effort hex lookup for a colour name returned by the API, used when
/// the endpoint doesn't include `colorHexCode`.
String? hexForColorName(String apiName) => swatchForColorName(apiName)?.hex;
