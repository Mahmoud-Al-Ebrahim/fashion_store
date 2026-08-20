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
  final String key;
  final String hex;
  final String apiName;

  const ProductColorSwatch(this.key, this.hex, this.apiName);

  String get label => LK.colorKey(key).tr();
}

const List<ProductColorSwatch> kColorSwatches = [
  ProductColorSwatch('white', '#FFFFFF', 'أبيض'),
  ProductColorSwatch('black', '#000000', 'أسود'),
  ProductColorSwatch('red', '#FF0000', 'أحمر'),
  ProductColorSwatch('blue', '#0000FF', 'أزرق'),
  ProductColorSwatch('green', '#008000', 'أخضر'),
  ProductColorSwatch('yellow', '#FFFF00', 'أصفر'),
  ProductColorSwatch('gray', '#808080', 'رمادي'),
  ProductColorSwatch('brown', '#8B4513', 'بني'),
  ProductColorSwatch('pink', '#FFB6C1', 'وردي'),
  ProductColorSwatch('purple', '#800080', 'بنفسجي'),
  ProductColorSwatch('orange', '#FFA500', 'برتقالي'),
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
  'رمادى': 'gray',
};

/// Translates a colour name coming back from the API. Unknown/free-form
/// colours fall back to the raw stored value.
String localizedColorName(String apiName) {
  final trimmed = apiName.trim();
  for (final swatch in kColorSwatches) {
    if (swatch.apiName == trimmed) return swatch.label;
  }
  final aliasKey = _colorAliases[trimmed];
  if (aliasKey != null) return LK.colorKey(aliasKey).tr();
  return apiName;
}

/// Best-effort hex lookup for a colour name returned by the API, used when
/// the endpoint doesn't include `colorHexCode`.
String? hexForColorName(String apiName) {
  final trimmed = apiName.trim();
  for (final swatch in kColorSwatches) {
    if (swatch.apiName == trimmed) return swatch.hex;
  }
  final aliasKey = _colorAliases[trimmed];
  if (aliasKey != null) {
    for (final swatch in kColorSwatches) {
      if (swatch.key == aliasKey) return swatch.hex;
    }
  }
  return null;
}
