import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/validators.dart';

/// Final registration step - password + submit.
class PasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
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
                  controller: passwordController,
                  hintText: LK.authPassword.tr(),
                  isPassword: true,
                  validator: validatePassword,
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
            SizedBox(height: height(5)),
            AuthTextField(
                  controller: confirmPasswordController,
                  hintText: LK.authConfirmPassword.tr(),
                  isPassword: true,
                  validator: validateConfirmPassword(
                    () => passwordController.text,
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
            SizedBox(height: height(30)),
            BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) => p.registerStatus != c.registerStatus,
                  builder: (context, state) {
                    final loading =
                        state.registerStatus == RegisterStatus.loading;
                    return AuthButton(
                      text: loading
                          ? LK.commonLoading.tr()
                          : LK.authRegister.tr(),
                      onTap: loading ? null : onSubmit,
                    );
                  },
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
