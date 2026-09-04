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
import 'blocs/admin_bloc/admin_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/category_bloc/category_bloc.dart';
import 'blocs/comment_bloc/comment_bloc.dart';
import 'blocs/product_bloc/product_bloc.dart';
import 'blocs/rating_bloc/rating_bloc.dart';
import 'blocs/super_admin_bloc/super_admin_bloc.dart';
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
      // Every bloc lives here, above MaterialApp and therefore above the
      // Navigator. That matters: `Navigator.push` mounts a route *outside*
      // the provider scope of the widget that pushed it, so a bloc provided
      // lower down (in a shell) would be invisible - or worse, silently
      // resolve to a second instance - on every pushed page.
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
          BlocProvider(create: (context) => ProductBloc()),
          BlocProvider(create: (context) => CategoryBloc()),
          BlocProvider(create: (context) => CommentBloc()),
          BlocProvider(create: (context) => RatingBloc()),
          BlocProvider(create: (context) => AdminBloc()),
          BlocProvider(create: (context) => SuperAdminBloc()),
        ],
        child: LocalizationService(
          child: Builder(
            builder: (context) {
              return MaterialApp(
                // Rebuilds the whole navigator when the language changes.
                //
                // `'key'.tr()` reads a *static* translation table - it never
                // becomes a dependent of any InheritedWidget. Changing the
                // locale rebuilds MaterialApp, but routes already on the
                // Navigator keep the widgets they built, so their `.tr()`
                // results are never re-evaluated: the home page stayed in
                // Arabic ("عروض وخصومات") after switching to English. Keying
                // on the locale forces the routes to be built again.
                key: ValueKey(context.locale.toString()),
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
