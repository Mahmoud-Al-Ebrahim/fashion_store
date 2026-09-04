import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../app/widgets/loading_indicator/fashion_loader.dart';
import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/show_message.dart';
import 'reset_password_page.dart';
import 'sign_in_screen.dart';

/// Which flow the OTP screen is serving.
enum OtpPurpose {
  /// Confirm a freshly registered email via `Auth/ConfirmEmail`.
  emailConfirmation,

  /// Collect the code emailed by `Auth/ForgotPassword`; it is validated
  /// later, together with the new password, by `Auth/ResetPassword`.
  passwordReset,
}

/// Email OTP screen shared by the registration and password-reset flows.
///
/// The purpose decides both what "verify" does and which endpoint "resend"
/// calls - resending a *reset* code must re-trigger `Auth/ForgotPassword`,
/// not the email-confirmation OTP.
class OTPVerificationPage extends StatefulWidget {
  final OtpPurpose purpose;
  final String email;

  const OTPVerificationPage({
    super.key,
    this.purpose = OtpPurpose.emailConfirmation,
    required this.email,
  });

  bool get isConfirmation => purpose == OtpPurpose.emailConfirmation;

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController code = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  void _submit() {
    if (code.text.length < 6) {
      showMessage(LK.authOtpIncomplete.tr());
      return;
    }
    if (widget.isConfirmation) {
      context.read<AuthBloc>().add(
        ConfirmEmailEvent(email: widget.email, code: code.text),
      );
    } else {
      // Password reset verifies the code together with the new password.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ResetPasswordPage(email: widget.email, code: code.text),
        ),
      );
    }
  }

  void _resend() {
    final bloc = context.read<AuthBloc>();
    if (widget.isConfirmation) {
      bloc.add(ResendOtpCodeEvent(email: widget.email));
    } else {
      bloc.add(ForgotPasswordEvent(email: widget.email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          LK.authOtpTitle.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (p, c) =>
            p.confirmEmailStatus != c.confirmEmailStatus ||
            p.resendOtpStatus != c.resendOtpStatus ||
            p.forgotPasswordStatus != c.forgotPasswordStatus,
        listener: (context, state) {
          if (state.confirmEmailStatus == ConfirmEmailStatus.success) {
            showMessage(LK.authOtpVerified.tr(), hasError: false);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInScreen()),
              (_) => false,
            );
          } else if (state.confirmEmailStatus == ConfirmEmailStatus.failure) {
            showMessage(state.errorMessage);
          }
          if (state.forgotPasswordStatus == ForgotPasswordStatus.success &&
              !widget.isConfirmation) {
            showMessage(LK.authOtpSent.tr(), hasError: false);
          }
          if (state.resendOtpStatus == ResendOtpStatus.success) {
            showMessage(LK.authOtpSent.tr(), hasError: false);
          } else if (state.resendOtpStatus == ResendOtpStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final verifying =
              state.confirmEmailStatus == ConfirmEmailStatus.loading;
          final resending = widget.isConfirmation
              ? state.resendOtpStatus == ResendOtpStatus.loading
              : state.forgotPasswordStatus == ForgotPasswordStatus.loading;

          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 8),
                child: Text(
                  LK.authOtpTitle.tr(),
                  style: const TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    Text(
                      LK.authOtpSubtitle.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.secondary.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        color: AppColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  onChanged: (_) {},
                  obscureText: false,
                  controller: code,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderWidth: 1.5,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeColor: AppColor.primary,
                    inactiveColor: AppColor.border,
                    inactiveFillColor: AppColor.primarySoft,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              verifying
                  ? Center(child: FashionLoader())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        LK.authOtpVerify.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
              const SizedBox(height: 12),
              resending
                  ? Center(child: FashionLoader.spinKitThreeBounce())
                  : ElevatedButton(
                      onPressed: _resend,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppColor.primarySoft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        LK.authOtpResend.tr(),
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
