import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/product_enums.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../admin/widgets/option_picker_field.dart';
import '../../../../core/utils/validators.dart';

/// Step 2 - gender + birth date.
///
/// `genderController` carries the API enum value (`Male` / `Female`); the
/// picker shows the localized label.
class AdditionalInformationStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController genderController;
  final TextEditingController birthDateController;

  const AdditionalInformationStep({
    super.key,
    required this.formKey,
    required this.genderController,
    required this.birthDateController,
  });

  @override
  State<AdditionalInformationStep> createState() =>
      _AdditionalInformationStepState();
}

class _AdditionalInformationStepState extends State<AdditionalInformationStep> {
  DateTime? selectedDate;

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    // Nobody under 12 may register. The old bounds were the wrong way
    // round - `firstDate: now - 18y` meant anyone *older* than 18 could not
    // pick their real birth date at all, while a newborn was allowed.
    final oldestAllowed = DateTime(now.year - 100, now.month, now.day);
    final youngestAllowed = DateTime(
      now.year - kMinimumSignUpAge,
      now.month,
      now.day,
    );
    var initial = selectedDate ?? DateTime(now.year - 18, now.month, now.day);
    if (initial.isAfter(youngestAllowed)) initial = youngestAllowed;
    if (initial.isBefore(oldestAllowed)) initial = oldestAllowed;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: oldestAllowed,
      lastDate: youngestAllowed,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.birthDateController.text =
            '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: height(35)),
          OptionPickerField(
                hintText: LK.authGender.tr(),
                options: genderOptions(),
                selectedValue: widget.genderController.text.isEmpty
                    ? null
                    : widget.genderController.text,
                onSelected: (option) =>
                    setState(() => widget.genderController.text = option.value),
                validator: (_) => widget.genderController.text.isEmpty
                    ? LK.commonRequiredField.tr()
                    : null,
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),
          SizedBox(height: height(10)),
          GestureDetector(
                onTap: () => pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: widget.birthDateController,
                    // The picker already bounds the range; this also
                    // catches a value restored from a saved form.
                    validator: validateBirthDate,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(
                        0xffb0b0b0,
                      ).withValues(alpha: 0.22),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width(14),
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: const Color(0xFF2B2F3F).withValues(alpha: 0.2),
                          width: 1.3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.3,
                        ),
                      ),
                      hintText: LK.authBirthDate.tr(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),
        ],
      ),
    );
  }
}
