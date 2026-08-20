import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/validators.dart';

/// Step 3 - email, phone and username.
class ContactInformationStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController usernameController;

  const ContactInformationStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.usernameController,
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
              controller: emailController,
              hintText: LK.authEmail.tr(),
              validator: validateEmail,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
            SizedBox(height: height(5)),
            AuthTextField(
              controller: phoneController,
              hintText: LK.authPhone.tr(),
              formatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? LK.commonRequiredField.tr()
                  : null,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
            SizedBox(height: height(5)),
            AuthTextField(
              controller: usernameController,
              hintText: LK.authUsername.tr(),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? LK.commonRequiredField.tr()
                  : null,
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
