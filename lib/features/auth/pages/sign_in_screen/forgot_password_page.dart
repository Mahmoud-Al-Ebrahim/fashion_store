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
import 'otp_verification_page.dart';

/// Step 1 of password recovery: collect the email and request a reset code.
///
/// This used to piggyback on the sign-in form's email field, which meant
/// tapping "forgot password" with an empty form just produced a validation
/// error. It's now its own screen with its own field.
class ForgotPasswordPage extends StatefulWidget {
  /// Prefills the field when the user already typed an email on sign-in.
  final String initialEmail;

  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      ForgotPasswordEvent(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(LK.authForgotTitle.tr()),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.forgotPasswordStatus != c.forgotPasswordStatus,
        listener: (context, state) {
          if (state.forgotPasswordStatus == ForgotPasswordStatus.success) {
            showMessage(LK.authResetSent.tr(), hasError: false);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OTPVerificationPage(
                  email: _emailController.text.trim(),
                  purpose: OtpPurpose.passwordReset,
                ),
              ),
            );
          } else if (state.forgotPasswordStatus ==
              ForgotPasswordStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(15)),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: height(30)),
                Text(
                  LK.authForgotSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color(0xff7A7A7A),
                  ),
                ),
                SizedBox(height: height(30)),
                AuthTextField(
                  controller: _emailController,
                  hintText: LK.authEmail.tr(),
                  validator: validateEmail,
                ),
                SizedBox(height: height(30)),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final loading = state.forgotPasswordStatus ==
                        ForgotPasswordStatus.loading;
                    return AuthButton(
                      text: loading
                          ? LK.commonLoading.tr()
                          : LK.authForgotSend.tr(),
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
