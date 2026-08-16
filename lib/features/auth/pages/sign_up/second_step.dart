import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';

class SecondStep extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController usernameController;
  final GlobalKey<FormState> formKey;

  const SecondStep({
    super.key,
    required this.emailController,
    required this.formKey,
    required this.phoneController,
    required this.usernameController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: height(35)),
          AuthTextField(
                controller: emailController,
                hintText: "الايميل",
                validator: (value) {
                  if (!RegExp(r'^[\w\.-]+@gmail\.com$').hasMatch(value!)) {
                    return "يرجى إدخال إيميل Gmail صالح مثل example@gmail.com";
                  }

                  if (value.isEmpty) {
                    return "الايميل مطلوب";
                  }
                  return null;
                },
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),
          AuthTextField(
                controller: phoneController,
                hintText: "رقم الهاتف",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "رقم الهاتف مطلوب";
                  }
                  if (value.length < 10) {
                    return "رقم الهاتف يجب أن يكون من عشر خانات مثال: 0912345678";
                  }
                  return null;
                },
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),
          AuthTextField(
                controller: usernameController,
                hintText: "اسم المستخدم",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "اسم المستخدم مطلوب";
                  }
                  if (value.length < 6) {
                    return "اسم المستخدم يجب أن يكون على الأقل 6 محارف";
                  }
                  return null;
                },
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),
        ],
      ),
    );
    ;
  }
}
