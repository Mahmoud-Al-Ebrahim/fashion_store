import 'package:easy_localization/easy_localization.dart';
import 'package:fashion_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:fashion_store/blocs/clothing_item_bloc/clothing_item_bloc.dart';
import 'package:fashion_store/blocs/post_bloc/post_bloc.dart';
import 'package:fashion_store/blocs/store_bloc/store_bloc.dart';
import 'package:fashion_store/blocs/store_follower_bloc/store_follower_bloc.dart';
import 'package:fashion_store/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/sensitive_connectivity/sensitive_connectivity_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/complaint_bloc/complaint_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'blocs/store_request_bloc/store_request_bloc.dart';
import 'blocs/user_bloc/user_bloc.dart';
import 'blocs/wallet_bloc/wallet_bloc.dart';
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
          BlocProvider(create: (context) => StoreBloc()),
          BlocProvider(create: (context) => PostBloc()),
          BlocProvider(create: (context) => StoreFollowerBloc()),
          BlocProvider(create: (context) => ClothingItemBloc()),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(create: (context) => WalletBloc()),
          BlocProvider(create: (context) => ComplaintBloc()),
          BlocProvider(create: (context) => StoreRequestBloc()),
          BlocProvider(create: (context) => UserBloc()),
          BlocProvider(create: (context) => OrderBloc()),
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
