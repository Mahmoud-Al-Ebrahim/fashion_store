import 'widgets/option_picker_field.dart';

/// API enum value -> Arabic label lists, used to build [OptionPickerField]s
/// across the admin product/order screens. The `value` sent to the API is
/// always the English enum name.

const List<PickerOption> kGenderOptions = [
  PickerOption('Male', 'رجالي'),
  PickerOption('Female', 'نسائي'),
];

const List<PickerOption> kSeasonOptions = [
  PickerOption('Summer', 'صيفي'),
  PickerOption('Spring', 'ربيعي'),
  PickerOption('Autumn', 'خريفي'),
  PickerOption('Winter', 'شتوي'),
];

const List<PickerOption> kTypeOptions = [
  PickerOption('Pants', 'بنطال'),
  PickerOption('Skirt', 'تنورة'),
  PickerOption('Dress', 'فستان'),
  PickerOption('ShortPants', 'شورت'),
  PickerOption('Shirt', 'قميص'),
  PickerOption('T_shirt', 'تيشيرت'),
  PickerOption('Shoes', 'أحذية'),
  PickerOption('SportSet', 'طقم رياضي'),
];

const List<PickerOption> kClothingSizeOptions = [
  PickerOption('XS', 'XS'),
  PickerOption('S', 'S'),
  PickerOption('M', 'M'),
  PickerOption('L', 'L'),
  PickerOption('XL', 'XL'),
  PickerOption('XXL', 'XXL'),
];

const List<PickerOption> kShoeSizeOptions = [
  PickerOption('Shoe36', '36'),
  PickerOption('Shoe37', '37'),
  PickerOption('Shoe38', '38'),
  PickerOption('Shoe39', '39'),
  PickerOption('Shoe40', '40'),
  PickerOption('Shoe41', '41'),
  PickerOption('Shoe42', '42'),
  PickerOption('Shoe43', '43'),
  PickerOption('Shoe44', '44'),
  PickerOption('Shoe45', '45'),
];

const List<PickerOption> kAllSizeOptions = [
  ...kClothingSizeOptions,
  ...kShoeSizeOptions,
];

const List<PickerOption> kOrderStatusOptions = [
  PickerOption('Processing', 'قيد التجهيز'),
  PickerOption('Cancelled', 'ملغي'),
  PickerOption('Delivered', 'تم التوصيل'),
];

/// (Arabic name, hex code) swatches offered when adding a product color -
/// there's no color-picker package in this project, so we offer a curated
/// palette matching the color names already used in the store's catalog.
const List<(String name, String hex)> kColorSwatches = [
  ('أبيض', '#FFFFFF'),
  ('أسود', '#000000'),
  ('أحمر', '#FF0000'),
  ('أزرق', '#0000FF'),
  ('أخضر', '#008000'),
  ('أصفر', '#FFFF00'),
  ('رمادي', '#808080'),
  ('بني', '#8B4513'),
  ('وردي', '#FFB6C1'),
  ('بنفسجي', '#800080'),
  ('برتقالي', '#FFA500'),
  ('فضي', '#C0C0C0'),
  ('ذهبي', '#FFD700'),
  ('كحلي', '#000080'),
  ('بيج', '#F5F5DC'),
];
