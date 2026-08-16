import 'package:fashion_store/core/helper/helper_functions.dart';
import 'package:fashion_store/features/auth/pages/verification/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';
import '../../widgets/choose_account/choose_account_contructor_params.dart';

class FourthStep extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final ChooseAccountConstructorParams params;


  const FourthStep({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.params,
  });

  @override
  State<FourthStep> createState() => _FourthStepState();
}

class _FourthStepState extends State<FourthStep> {
  late final bool isForUserAccount;

  @override
  void initState() {
    super.initState();
    isForUserAccount = widget.params.userType == "normalUser";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: height(35)),
          AuthTextField(
            controller: widget.passwordController,
            hintText: "كلمة المرور",
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "الرجاء إدخال كلمة المرور";
              }
              if (value.length < 6) {
                return "كلمة المرور يجب أن تكون 6 محارف على الأقل";
              }

              // ✅ تحقق من وجود حرف صغير
              final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
              // ✅ تحقق من وجود حرف كبير
              final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
              // ✅ تحقق من وجود رقم
              final hasNumber = RegExp(r'[0-9]').hasMatch(value);

              if (!hasLowercase || !hasUppercase || !hasNumber) {
                return "يجب أن تحتوي كلمة المرور على أحرف صغيرة وكبيرة وأرقام";
              }

              return null;
            },
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),

          SizedBox(height: height(5)),

          /// تأكيد كلمة المرور
          AuthTextField(
            controller: widget.confirmPasswordController,
            hintText: "تأكيد كلمة المرور",
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "الرجاء تأكيد كلمة المرور";
              }
              if (value != widget.passwordController.text) {
                return "كلمتا المرور غير متطابقتين";
              }
              return null;
            },
          ).animate()
              .fadeIn(duration: 400.ms,delay: 400.milliseconds)
              .slide(begin: const Offset(1, 0), duration: 400.ms),
          SizedBox(height: height(30)),
          // BlocBuilder<AuthUserBloc, AuthUserState>(
          //   builder: (context, state) {
          //     return state.signUpState.isLoading
          //         ? LinearProgressIndicator(
          //           minHeight: 2.5,
          //           backgroundColor: Theme.of(
          //             context,
          //           ).colorScheme.surfaceTint.withOpacity(0.2),
          //         )
          //         : const SizedBox();
          //   },
          // ),
          SizedBox(height: height(10)),
          AuthButton(
            text: 'انشاء حساب',
            onTap: () async {
              HelperFunctions.navigateToPage(context, OTPVerificationPage(email: widget.params.email));
            },
          )
        ],
      ),
    );
  }
}
