import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';

class PasswordStep extends StatelessWidget {

  final GlobalKey<FormState> formKey;

  final TextEditingController
  passwordController;

  final TextEditingController
  confirmPasswordController;

  final VoidCallback onSubmit;

  const PasswordStep({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: height(35)),

            AuthTextField(
              controller:
              passwordController,
              hintText: "كلمة المرور",
              isPassword: true,
              validator: (value) {

                if (value == null ||
                    value.isEmpty) {

                  return "الرجاء إدخال كلمة المرور";
                }

                if (value.length < 6) {

                  return "كلمة المرور يجب أن تكون 6 محارف على الأقل";
                }

                final hasLowercase =
                RegExp(
                  r'[a-z]',
                ).hasMatch(value);

                final hasUppercase =
                RegExp(
                  r'[A-Z]',
                ).hasMatch(value);

                final hasNumber =
                RegExp(
                  r'[0-9]',
                ).hasMatch(value);

                if (!hasLowercase ||
                    !hasUppercase ||
                    !hasNumber) {

                  return "يجب أن تحتوي كلمة المرور على أحرف صغيرة وكبيرة وأرقام";
                }

                return null;
              },
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(
              begin: const Offset(1, 0),
              duration: 400.ms,
            ),

            SizedBox(height: height(5)),

            AuthTextField(
              controller:
              confirmPasswordController,
              hintText:
              "تأكيد كلمة المرور",
              isPassword: true,
              validator: (value) {

                if (value == null ||
                    value.isEmpty) {

                  return "الرجاء تأكيد كلمة المرور";
                }

                if (value !=
                    passwordController.text) {

                  return "كلمتا المرور غير متطابقتين";
                }

                return null;
              },
            )
                .animate()
                .fadeIn(
              duration: 400.ms,
              delay: 250.ms,
            )
                .slide(
              begin: const Offset(1, 0),
              duration: 400.ms,
            ),

            SizedBox(height: height(30)),

            AuthButton(
              text: "انشاء حساب",
              onTap: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}