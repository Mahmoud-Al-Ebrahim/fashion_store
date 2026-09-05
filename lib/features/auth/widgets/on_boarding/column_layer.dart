import 'package:fashion_store/core/helper/helper_functions.dart';
import 'package:fashion_store/features/auth/pages/sign_up/sign_up_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fashion_store/core/localization/translation_keys.dart';
import 'package:fashion_store/features/auth/pages/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../app/widgets/button.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/clear_session_blocs.dart';
import '../../../../core/utils/my_shared_pref.dart';
import '../../../nav_bar/user_nav_bar/user_nav_bar_screen.dart';

/// Enters read-only browsing from onboarding.
///
/// Onboarding is normally the very first screen, but it is reachable again
/// after a reinstall-less sign-out, so it clears the session the same way
/// the sign-in screen's guest button does rather than assuming there is
/// nothing to clear.
Future<void> _continueAsGuest(BuildContext context) async {
  await ApiService.clearAuth();
  await MySharedPref.clearAuthData();
  if (!context.mounted) return;
  clearSessionBlocs(context, includeAuth: true);
  HelperFunctions.navigateToPageAndPopAll(context, const UserNavBar(), true);
}

class ColumnLayer extends StatelessWidget {
  const ColumnLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: height(52),
      right: width(19),
      left: width(17),
      child: Column(
        spacing: height(23.5),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: LK.onboardingWelcomeTo.tr()),
                TextSpan(
                  text: LK.onboardingBrand.tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(text: LK.onboardingTagline1.tr()),
              ],
            ),
          ),
          Text(
            LK.onboardingTagline2.tr(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Row(
            spacing: width(10),
            children: [
              SvgPicture.asset("assets/svg/done_on_boarding.svg"),
              Text(
                LK.onboardingBullet1.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: width(10),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: height(21)),
                child: SvgPicture.asset("assets/svg/done_on_boarding.svg"),
              ),
              Flexible(
                child: Text(
                  LK.onboardingBullet2.tr(),
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                    height: height(1.5),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              AuthButton(
                onTap: () {
                  HelperFunctions.navigateToPage(context, SignInScreen());
                },
                heightButton: 52,
                widthButton: 167,
                text: LK.authLogin.tr(),
              ),
              SizedBox(width: width(10)),
              AuthButton(
                onTap: () {
                  HelperFunctions.navigateToPage(context, const SignUpScreen());
                },
                heightButton: 52,
                widthButton: 167,
                isWhiteBackground: true,
                text: LK.authRegister.tr(),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              HelperFunctions.navigateToPageAndPopAll(context, UserNavBar());
            },
            child: Row(
              spacing: width(10),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _continueAsGuest(context),
                  child: Text(
                    LK.onboardingContinueGuest.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _continueAsGuest(context),
                  child: SvgPicture.asset("assets/svg/next.svg", height: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
