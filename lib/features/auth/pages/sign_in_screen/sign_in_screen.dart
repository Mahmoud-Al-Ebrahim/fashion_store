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
import '../../../../core/utils/show_message.dart';
import '../../../../core/utils/validators.dart';
import '../../../admin/admin_shell_screen.dart';
import '../../../nav_bar/user_nav_bar/user_nav_bar_screen.dart';
import '../sign_up/sign_up_screen.dart';
import 'otp_verification_page.dart';

/// Sign-in. On success the user is routed by role: store owners land on the
/// admin dashboard, everyone else on the customer shell.
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

  void _forgotPassword() {
    final email = emailController.text.trim();
    final error = validateEmail(email);
    if (error != null) {
      showMessage(error);
      return;
    }
    context.read<AuthBloc>().add(ForgotPasswordEvent(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (p, c) => p.loginStatus != c.loginStatus,
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.success) {
                HelperFunctions.navigateToPageAndPopAll(
                  context,
                  state.isStoreAdmin
                      ? const AdminShellScreen()
                      : const UserNavBar(),
                  true,
                );
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
                        cameFromRegisterPage: true,
                      ),
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (p, c) =>
                p.forgotPasswordStatus != c.forgotPasswordStatus,
            listener: (context, state) {
              if (state.forgotPasswordStatus ==
                  ForgotPasswordStatus.success) {
                showMessage(LK.authResetSent.tr(), hasError: false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OTPVerificationPage(
                      email: emailController.text.trim(),
                      cameFromRegisterPage: false,
                    ),
                  ),
                );
              } else if (state.forgotPasswordStatus ==
                  ForgotPasswordStatus.failure) {
                showMessage(state.errorMessage);
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(15)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height(100)),
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
                SizedBox(height: height(10)),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: _forgotPassword,
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
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.2),
                          )
                        : const SizedBox(height: 2.5);
                  },
                ),
                SizedBox(height: height(14)),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) => p.loginStatus != c.loginStatus,
                  builder: (context, state) {
                    final loading = state.loginStatus == LoginStatus.loading;
                    return AuthButton(
                      text: loading
                          ? LK.commonLoading.tr()
                          : LK.authLogin.tr(),
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
                TextButton(
                  onPressed: () => HelperFunctions.navigateToPage(
                    context,
                    const SignUpScreen(),
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
