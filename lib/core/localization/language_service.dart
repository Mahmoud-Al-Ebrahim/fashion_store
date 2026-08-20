import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

enum LangCode { ar, en }

final localMap = {
  LangCode.ar: const Locale('ar', 'SY'),
  LangCode.en: const Locale('en', 'US'),
};

List<Locale> supportedLocal = [
  localMap[LangCode.ar]!,
  localMap[LangCode.en]!,
];

final Locale defaultLocal = localMap[LangCode.ar]!;

final mpaLanguageCodeToLocale = {
  LangCode.ar.name: localMap[LangCode.ar]!,
  LangCode.en.name: localMap[LangCode.en]!,
};

/// Native display name for each supported language, used by the in-app
/// language switcher so each option reads in its own language.
final languageNameAndLanguageCode = <String, String>{
  LangCode.ar.name: 'العربية',
  LangCode.en.name: 'English',
};

class LanguageService {
  static late Locale currentLanguage;
  static String languageCode = 'ar';
  static late bool rtl;

  final BuildContext context;
  static LanguageService? _instance;

  LanguageService._singleton(this.context) {
    currentLanguage = _currentLanguage;
    languageCode = _languageCode;
    rtl = _rtl;
  }

  factory LanguageService(BuildContext context) {
    if (_instance != null) {
      if (context.locale.languageCode != languageCode) {
        return LanguageService._singleton(context);
      }
      return _instance!;
    }
    return LanguageService._singleton(context);
  }

  Locale get _currentLanguage => context.locale;

  String get _languageCode => _currentLanguage.languageCode;

  bool get _rtl => context.locale.languageCode == LangCode.ar.name;

  /// Whether the app is currently displaying a right-to-left language.
  static bool isRtl(BuildContext context) =>
      context.locale.languageCode == LangCode.ar.name;

  /// Switches the app locale and persists it (easy_localization has
  /// `saveLocale: true`, so the choice survives restarts).
  static Future<void> switchTo(BuildContext context, LangCode code) async {
    await context.setLocale(localMap[code]!);
  }
}
