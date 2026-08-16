import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';

class ContactInformationStep extends StatelessWidget {

  final GlobalKey<FormState> formKey;

  final TextEditingController
  emailController;

  final TextEditingController
  phoneController;

  final TextEditingController
  usernameController;

   ContactInformationStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.usernameController,
  });

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
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: height(35)),

            AuthTextField(
              controller: emailController,
              hintText: "البريد الالكتروني",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "البريد الالكتروني مطلوب";
                }
                if (!regex.hasMatch(
                  emailController.text,
                )) {
                  return "هذا البريد الالكتروني غير صالح";
                }

                return null;
              },
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),

            SizedBox(height: height(5)),

            AuthTextField(
              controller: phoneController,
              formatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              hintText: "رقم الهاتف",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "رقم الهاتف مطلوب";
                }
                final regex = RegExp(r'^09\d{8}$');

                if (!regex.hasMatch(value.trim())) {
                  return "رقم الهاتف غير صالح";
                }
                return null;
              },
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),

            SizedBox(height: height(5)),

            AuthTextField(
              controller:
              usernameController,
              formatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              hintText: "اسم المستخدم",
              validator: (value) {

                if (value == null ||
                    value.isEmpty) {

                  return "اسم المستخدم مطلوب";
                }

                if (value.length < 4) {

                  return "اسم المستخدم يجب ان يكون اكثر من 4 احرف";
                }

                return null;
              },
            )
                .animate()
                .fadeIn(
              duration: 400.ms,
              delay: 300.ms,
            )
                .slide(
              begin: const Offset(1, 0),
              duration: 400.ms,
            ),
          ],
        ),
      ),
    );
  }
}