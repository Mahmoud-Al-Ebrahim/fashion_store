import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/helper/helper_functions.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';

class ThirdStep extends StatefulWidget {
  final TextEditingController genderController;
  final TextEditingController birthDateController;
  final TextEditingController workingHours;
  final ValueNotifier<XFile?> identity1;
  final ValueNotifier<XFile?> identity2;
  final bool isForUserAccount;

  const ThirdStep({
    super.key,
    required this.genderController,
    required this.birthDateController,
    required this.identity1,
    required this.identity2,
    required this.isForUserAccount,
    required this.workingHours,
  });

  @override
  State<ThirdStep> createState() => _ThirdStepState();
}

class _ThirdStepState extends State<ThirdStep> {
  final Map<String, String> genderMap = {"ذكر": "male", "أنثى": "female"};

  String? selectedGender;
  DateTime? selectedDate;

  final List<String> genders = ["ذكر", "أنثى"];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(now.year - 18);
    final DateTime firstDate = DateTime(1900);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: firstDate,
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.birthDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height(35)),

        /// حقل اختيار الجنس
        DropdownButtonFormField<String>(
              value: selectedGender,
              validator: (value) =>
                  value == null || value.isEmpty ? "الرجاء اختيار الجنس" : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffb0b0b0b0).withOpacity(0.22),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: width(14),
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: const Color(0xFF2B2F3F14).withOpacity(0.2),
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
                hintText: "اختر الجنس",
              ),
              items: genders.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                  widget.genderController.text = genderMap[value!] ?? "";
                });
              },
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slide(begin: const Offset(1, 0), duration: 400.ms),

        SizedBox(height: height(20)),

        /// حقل تاريخ الميلاد
        GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: widget.birthDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الرجاء اختيار تاريخ الميلاد";
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffb0b0b0b0).withOpacity(0.22),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: width(14),
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: const Color(0xFF2B2F3F14).withOpacity(0.2),
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.3,
                      ),
                    ),
                    hintText: "اختر تاريخ الميلاد",
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xff7A7A7A),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xff7A7A7A),
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 300.milliseconds)
            .slide(begin: const Offset(1, 0), duration: 400.ms),
        SizedBox(height: height(20)),
        if (!widget.isForUserAccount) ...{
          AuthTextField(
                controller: widget.workingHours,
                hintText: "ساعات العمل مثلا 8:00AM - 12:00PM",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ساعات العمل مطلوبة";
                  }
                  return null;
                },
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(1, 0), duration: 400.ms),

          ValueListenableBuilder(
            valueListenable: widget.identity1,
            builder: (context, selectedImage, _) {
              return GestureDetector(
                onTap: () async {
                  widget.identity1.value = await HelperFunctions.pickImage();
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(selectedImage.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            "الوجه الأمامي للهوية",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                ),
              );
            },
          ),
          SizedBox(height: height(20)),
          ValueListenableBuilder(
            valueListenable: widget.identity2,
            builder: (context, selectedImage, _) {
              return GestureDetector(
                onTap: () async {
                  widget.identity2.value = await HelperFunctions.pickImage();
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(selectedImage.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            "الوجه الخلفي للهوية",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                ),
              );
            },
          ),
        },
      ],
    );
  }
}
