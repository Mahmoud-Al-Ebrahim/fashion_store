import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_color.dart';
import 'core/utils/api_service.dart';
import 'core/utils/my_shared_pref.dart';
import 'fashion_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MySharedPref.init();
  await ApiService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColor.primary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(FashionApp());
}
