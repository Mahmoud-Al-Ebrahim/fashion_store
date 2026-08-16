import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/show_message.dart';
import '../../../admin/admin_shell_screen.dart';
import '../../../nav_bar/user_nav_bar/user_nav_bar_screen.dart';
import '../verification/verification_page.dart';

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
  final confirmPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();


  static const String _pattern =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final RegExp regex = RegExp(_pattern);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    // authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(15)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height(100)),

              // ====== العنوان ======
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تسجيل الدخول / ",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        "مستخدم",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xff7A7A7A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slide(begin: const Offset(1, 0), duration: 400.ms),

              SizedBox(height: height(40)),

              Form(
                key: loginFormKey,
                child: Column(
                  children: [
                    // ====== الحقل الأول ======
                    AuthTextField(
                          controller: emailController,
                          hintText: "البريد الإلكتروني",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الايميل مطلوب";
                            }

                            if (!regex.hasMatch(
                              emailController.text,
                            )) {
                              return "هذا البريد الالكتروني غير صالح";
                            }
                            return null;
                          },
                        )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 400.ms)
                        .slide(begin: const Offset(1, 0), duration: 400.ms),

                    SizedBox(height: height(5)),

                    // ====== الحقل الثاني ======
                    AuthTextField(
                          controller: passwordController,
                          hintText: "كلمة المرور",
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال كلمة المرور";
                            }
                            if (value.length < 8) {
                              return "كلمة المرور يجب أن تكون 8 محارف على الأقل";
                            }
                            return null;
                          },
                        )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 400.ms)
                        .slide(begin: const Offset(1, 0), duration: 400.ms),

                    SizedBox(height: height(5)),

                    // ====== الحقل الثالث ======
                    AuthTextField(
                          controller: confirmPasswordController,
                          hintText: "تأكيد كلمة المرور",
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء تأكيد كلمة المرور";
                            }
                            if (value != passwordController.text) {
                              return "كلمة المرور غير متطابقة";
                            }
                            return null;
                          },
                        )
                        .animate(delay: 600.ms)
                        .fadeIn(duration: 400.ms)
                        .slide(begin: const Offset(1, 0), duration: 400.ms),
                  ],
                ),
              ),

              SizedBox(height: height(20)),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      showMessage("البريد الالكتروني لايجب أن يكون فارغاً");
                      return;
                    }
                    if (!regex.hasMatch(emailController.text)) {
                      showMessage("هذا البريد الالكتروني غير صالح");
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                            OTPVerificationPage(cameFromRegisterPage: false , email : emailController.text),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.primary.withOpacity(0.1),
                  ),
                  child: Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.primary.withOpacity(0.5),
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ),

              // ====== شريط التحميل ======
              BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state.loginStatus == LoginStatus.loading
                          ? LinearProgressIndicator(
                              minHeight: 2.5,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
                            )
                          : const SizedBox(height: 2.5);
                    },
                  )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 400.ms)
                  .slide(begin: const Offset(1, 0), duration: 400.ms),

              // ====== الزر ======
              BlocConsumer<AuthBloc, AuthState>(
                listenWhen: (previous, current) =>
                    previous.loginStatus != current.loginStatus,
                listener: (context, state) {
                  if (state.loginStatus == LoginStatus.success) {
                    HelperFunctions.navigateToPageAndPopAll(
                      context,
                      state.isStoreAdmin ? const AdminShellScreen() : const UserNavBar(),
                      true,
                    );
                  } else if (state.loginStatus == LoginStatus.failure) {
                    showMessage(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return AuthButton(
                    text: 'تسجيل الدخول',
                    onTap: () {
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
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 400.ms)
                  .slide(begin: const Offset(1, 0), duration: 400.ms),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
