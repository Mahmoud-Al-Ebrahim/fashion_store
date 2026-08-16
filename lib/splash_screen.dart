import 'dart:ui';

import 'package:fashion_store/features/auth/pages/on_boarding_screen.dart';
import 'package:fashion_store/features/nav_bar/user_nav_bar/user_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'core/theme/app_color.dart';
import 'core/utils/my_shared_pref.dart';
import 'features/admin/admin_shell_screen.dart';
import 'features/auth/pages/sign_in_screen/sign_in_screen.dart';
import 'features/onboarding/onboarding_screen.dart' hide AppColor;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      String? token = MySharedPref.getToken();
      bool isStoreAdmin = MySharedPref.isStoreAdmin();
      bool? onBoardingSeen = MySharedPref.getOnBoardingSeen();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => !onBoardingSeen
              ? OnboardingScreen()
              : token != null
              ? (isStoreAdmin ? const AdminShellScreen() : UserNavBar())
              : SignInScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: .25),
                  Theme.of(context).colorScheme.primary.withValues(alpha: .40),
                ],
                stops: [0.0, 0.57, 1.0],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.8, sigmaY: 1),
              child: Container(
                color: Colors.transparent, // مهم حتى يشتغل البلور
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/svg/shopping illustration.svg'),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Fashion',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
