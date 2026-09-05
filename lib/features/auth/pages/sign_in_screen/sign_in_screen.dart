import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/clear_session_blocs.dart';
import '../../../../core/utils/my_shared_pref.dart';
import '../../../../core/utils/show_message.dart';
import '../../../../core/utils/validators.dart';
import '../../../role_router.dart';
import '../choose_account_kind_screen.dart';
import 'forgot_password_page.dart';
import 'otp_verification_page.dart';

/// Sign-in. On success the user is routed by role (see [RoleRouter]).
/// A "continue as guest" option lets people browse the catalog read-only.
class SignInScreen extends StatefulWidget {
  static String name = "LoginScreen";
  static String route = "/login";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Drops into read-only browsing with nothing of the previous account
  /// left behind.
  ///
  /// Clearing the stored token was not enough: the blocs live at the app
  /// root and outlive any single session, so a guest arriving here after
  /// somebody signed out still saw that person's cart, orders, wallet,
  /// profile and complaints - each screen only corrects itself once its own
  /// fetch returns, and as a guest those fetches 401 and leave the stale
  /// data on screen. AuthBloc is included because it still holds the login
  /// response, tokens and all.
  Future<void> _continueAsGuest() async {
    await ApiService.clearAuth();
    await MySharedPref.clearAuthData();
    if (!mounted) return;
    clearSessionBlocs(context, includeAuth: true);
    RoleRouter.goHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.loginStatus != c.loginStatus,
        listener: (context, state) {
          if (state.loginStatus == LoginStatus.success) {
            // Belt and braces for account switching: whatever the previous
            // session left in the root blocs is dropped before the new one
            // starts fetching. AuthBloc is left alone - it is holding the
            // login that just succeeded.
            clearSessionBlocs(context);
            RoleRouter.goHome(context);
          } else if (state.loginStatus == LoginStatus.failure) {
            showMessage(state.errorMessage);
            // An unconfirmed email is recoverable - send them to the OTP
            // screen instead of leaving them stuck on the form.
            if (state.errorMessage.contains('مؤكد') ||
                state.errorMessage.toLowerCase().contains('confirm')) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OTPVerificationPage(
                    email: emailController.text.trim(),
                    purpose: OtpPurpose.emailConfirmation,
                  ),
                ),
              );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(15)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height(90)),
                Text(
                      LK.authLogin.tr(),
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 400.ms),
                SizedBox(height: height(40)),
                Form(
                  key: loginFormKey,
                  child: Column(
                    children: [
                      AuthTextField(
                            controller: emailController,
                            hintText: LK.authEmail.tr(),
                            validator: validateEmail,
                          )
                          .animate(delay: 200.ms)
                          .fadeIn(duration: 400.ms)
                          .slide(begin: const Offset(1, 0), duration: 400.ms),
                      SizedBox(height: height(5)),
                      AuthTextField(
                            controller: passwordController,
                            hintText: LK.authPassword.tr(),
                            isPassword: true,
                            validator: validatePassword,
                          )
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 400.ms)
                          .slide(begin: const Offset(1, 0), duration: 400.ms),
                    ],
                  ),
                ),
                SizedBox(height: height(6)),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => HelperFunctions.navigateToPage(
                      context,
                      ForgotPasswordPage(
                        initialEmail: emailController.text.trim(),
                      ),
                    ),
                    child: Text(
                      LK.authForgotPassword.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.primary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) => p.loginStatus != c.loginStatus,
                  builder: (context, state) {
                    return state.loginStatus == LoginStatus.loading
                        ? LinearProgressIndicator(
                            minHeight: 2.5,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.2),
                          )
                        : const SizedBox(height: 2.5);
                  },
                ),
                SizedBox(height: height(14)),
                BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (p, c) => p.loginStatus != c.loginStatus,
                      builder: (context, state) {
                        final loading =
                            state.loginStatus == LoginStatus.loading;
                        return AuthButton(
                          text: loading
                              ? LK.commonLoading.tr()
                              : LK.authLogin.tr(),
                          widthButton: double.infinity,
                          onTap: loading
                              ? null
                              : () {
                                  if (loginFormKey.currentState?.validate() ??
                                      false) {
                                    context.read<AuthBloc>().add(
                                      LoginEvent(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                      ),
                                    );
                                  }
                                },
                        );
                      },
                    )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 400.ms),
                SizedBox(height: height(10)),
                AuthButton(
                      text: LK.authContinueAsGuest.tr(),
                      isWhiteBackground: true,
                      widthButton: double.infinity,
                      onTap: _continueAsGuest,
                    )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 400.ms),
                SizedBox(height: height(6)),
                TextButton(
                  onPressed: () => HelperFunctions.navigateToPage(
                    context,
                    const ChooseAccountKindScreen(),
                  ),
                  child: Text(LK.authNoAccount.tr()),
                ),
                SizedBox(height: height(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
