import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/screen_util.dart';

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

class _AdditionalInformationStepState
    extends State<AdditionalInformationStep> {

  final Map<String, String> genderMap = {
    "ذكر": "male",
    "أنثى": "female",
  };

  final List<String> genders = [
    "ذكر",
    "أنثى",
  ];

  String? selectedGender;

  DateTime? selectedDate;

  Future<void> pickDate(BuildContext context) async {

    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      selectedDate ??
          DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {

      setState(() {

        selectedDate = picked;

        widget.birthDateController.text =
            DateFormat(
              "yyyy-MM-dd",
            ).format(picked);
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

          DropdownButtonFormField<String>(
            value: selectedGender,
            validator: (value) {

              if (value == null || value.isEmpty) {
                return "الرجاء اختيار الجنس";
              }

              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(
                0xffb0b0b0b0,
              ).withOpacity(0.22),
              contentPadding:
              EdgeInsets.symmetric(
                horizontal: width(14),
                vertical: 12,
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: const Color(
                    0xFF2B2F3F14,
                  ).withOpacity(0.2),
                  width: 1.3,
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .primaryColor,
                  width: 1.3,
                ),
              ),
              hintText: "اختر الجنس",
            ),
            items: genders.map((gender) {

              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (value) {

              setState(() {

                selectedGender = value;

                widget.genderController.text =
                    genderMap[value!] ?? "";
              });
            },
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(
            begin: const Offset(1, 0),
            duration: 400.ms,
          ),

          SizedBox(height: height(20)),

          GestureDetector(
            onTap: () => pickDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller:
                widget.birthDateController,
                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return "الرجاء اختيار تاريخ الميلاد";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(
                    0xffb0b0b0b0,
                  ).withOpacity(0.22),
                  contentPadding:
                  EdgeInsets.symmetric(
                    horizontal: width(14),
                    vertical: 12,
                  ),
                  enabledBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),
                    borderSide: BorderSide(
                      color: const Color(
                        0xFF2B2F3F,
                      ).withOpacity(0.2),
                      width: 1.3,
                    ),
                  ),
                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),
                    borderSide: BorderSide(
                      color:
                      Theme.of(context)
                          .primaryColor,
                      width: 1.3,
                    ),
                  ),
                  hintText:
                  "اختر تاريخ الميلاد",
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                  ),
                ),
              ),
            ),
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
    );
  }
}