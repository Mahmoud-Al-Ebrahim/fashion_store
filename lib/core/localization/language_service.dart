import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

enum LangCode { ar }

List<Locale> supportedLocal = [
  localMap[LangCode.ar]!,
];

final Locale defaultLocal = localMap[LangCode.ar]!;

final localMap = {
  LangCode.ar: const Locale('ar', 'SY'),
};

final mpaLanguageCodeToLocale = {
  LangCode.ar.name: const Locale('ar', 'SY'),
};

final languageNameAndLanguageCode = <String, String>{
   LangCode.ar.name : 'Arabic',
};

class LanguageService {
  static late Locale currentLanguage;
  static  String languageCode = 'ar';
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

  Locale get  _currentLanguage => context.locale;

  String get _languageCode => _currentLanguage.languageCode;

  bool get _rtl => context.locale == localMap[LangCode.ar]!;
}
