import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/show_message.dart';
import '../../../../core/utils/validators.dart';
import 'sign_in_screen.dart';

/// Final step of the "forgot password" flow - posts `Auth/ResetPassword`
/// with the emailed code and the new password.
class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordPage({super.key, required this.email, required this.code});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      ResetPasswordEvent(
        email: widget.email,
        code: widget.code,
        newPassword: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(LK.authResetPassword.tr()),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.resetPasswordStatus != c.resetPasswordStatus,
        listener: (context, state) {
          if (state.resetPasswordStatus == ResetPasswordStatus.success) {
            showMessage(LK.authResetSuccess.tr(), hasError: false);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInScreen()),
              (_) => false,
            );
          } else if (state.resetPasswordStatus == ResetPasswordStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(15)),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: height(40)),
                AuthTextField(
                  controller: _passwordController,
                  hintText: LK.authNewPassword.tr(),
                  isPassword: true,
                  validator: validatePassword,
                ),
                SizedBox(height: height(8)),
                AuthTextField(
                  controller: _confirmController,
                  hintText: LK.authConfirmPassword.tr(),
                  isPassword: true,
                  validator: validateConfirmPassword(
                    () => _passwordController.text,
                  ),
                ),
                SizedBox(height: height(30)),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final loading =
                        state.resetPasswordStatus ==
                        ResetPasswordStatus.loading;
                    return AuthButton(
                      text: loading
                          ? LK.commonLoading.tr()
                          : LK.authResetPassword.tr(),
                      onTap: loading ? null : _submit,
                      widthButton: double.infinity,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
