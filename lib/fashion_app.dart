import 'package:easy_localization/easy_localization.dart';
import 'package:fashion_store/features/auth/pages/verification/verification_page.dart';
import 'package:fashion_store/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/sensitive_connectivity/sensitive_connectivity_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'core/localization/localization_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FashionApp extends StatelessWidget {
  FashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SensitiveConnectivityBloc()),
          BlocProvider(create: (context) => AuthBloc()..add(LoadStoredAuthEvent())),
        ],
        child: LocalizationService(
          child: Builder(
            builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                locale: context.locale,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'El Messiri',
                ),
                home: SplashScreen(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
