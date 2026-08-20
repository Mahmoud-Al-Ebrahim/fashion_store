import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';

/// Step 1 - the customer's name. Identity-document capture was removed:
/// it belongs to the separate "become a seller" request, not registration.
class OwnerInformationStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const OwnerInformationStep({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
  });

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LK.commonRequiredField.tr();
    }
    if (value.trim().length < 3) return LK.commonInvalidValue.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height(35)),
            AuthTextField(
              controller: firstNameController,
              hintText: LK.authFirstName.tr(),
              validator: _validateName,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
            SizedBox(height: height(5)),
            AuthTextField(
              controller: lastNameController,
              hintText: LK.authLastName.tr(),
              validator: _validateName,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
