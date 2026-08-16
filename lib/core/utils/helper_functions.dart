import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fashion_store/core/utils/my_shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import '../localization/language_service.dart';


class HelperFunctions {
  static changeAppStatus(ThemeMode theme) {
    final color =
        theme == ThemeMode.dark
            ? const Color(0xFF191C1D)
            : const Color(0xFFFBFDFD);
    final brightness =
        theme == ThemeMode.light ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness,
      ),
    );
  }


  static Future<bool> lostInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.none;
  }


  static Route createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static String getTheFirstTwoLettersOfName(String name) {
    return name.split(' ').length == 2
        ? name.split(' ')[0][0] + name.split(' ')[1][0]
        : name.split(' ').first.length > 1
        ? (name.split(' ')[0][0] + name.split(' ')[0][1])
        : name.split(' ').first;
  }

  static String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  static Locale getInitLocale() {
    // return mpaLanguageCodeToLocale['ar']!;
    final devicelang = MySharedPref.getLanguage() ?? WidgetsBinding.instance.window.locale.languageCode;
    return mpaLanguageCodeToLocale[devicelang] ?? defaultLocal ;
  }

  static DateTime getZonedDate(DateTime date) {
    return date.toLocal();
  }

  static String getTimeInFormat(Duration duration) {
    String? hours =
        duration.inHours > 0 ? twoDigits(duration.inHours.remainder(60)) : null;
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${hours ?? ''}$minutes:$seconds';
  }


  static String twoDigits(int n) => n.toString().padLeft(2, "0");

  static String getTimeInHMSFormat({required Duration seconds}) {
    String twoDigitMinutes = twoDigits(seconds.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(seconds.inSeconds.remainder(60).abs());
    return "${twoDigits(seconds.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }


  static navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  static slidingNavigation(
    BuildContext context,
    Widget page, {
    int milliseconds = 300,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return page;
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), //// navigation from right
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }
}
