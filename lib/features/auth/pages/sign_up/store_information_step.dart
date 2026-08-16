import 'dart:io';

import 'package:fashion_store/features/auth/pages/sign_up/pick_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/theme/app_color.dart';

class StoreInformationStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController storeNameController;

  final TextEditingController addressController;

  final TextEditingController descriptionController;

  final TextEditingController workingHoursController;

  final TextEditingController storeEmailController;
  final TextEditingController storePhoneController;

  final ValueNotifier<XFile?> logo;

  final ValueNotifier<XFile?> mainImage;

  final ValueNotifier<LatLng?> location;

   StoreInformationStep({
    super.key,
    required this.formKey,
    required this.storeNameController,
    required this.addressController,
    required this.descriptionController,
    required this.workingHoursController,
    required this.logo,
    required this.mainImage,
    required this.location,
    required this.storeEmailController,
    required this.storePhoneController,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height(35)),
            AuthTextField(
                  controller: storeNameController,
                  hintText: "اسم المتجر",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "اسم المتجر مطلوب";
                    }

                    return null;
                  },
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),

            SizedBox(height: height(5)),

            AuthTextField(
              controller: addressController,
              hintText: "العنوان",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "العنوان مطلوب";
                }

                return null;
              },
            ),

            SizedBox(height: height(5)),

            AuthTextField(
              controller: descriptionController,
              hintText: "نبذة عن المتجر",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "يجب ادخال نبذة عن المتجر";
                }

                return null;
              },
            ),

            SizedBox(height: height(5)),

            AuthTextField(
              controller: workingHoursController,
              hintText: "ساعات العمل مثلا 8:00AM - 12:00PM",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "ساعات العمل مطلوبة";
                }

                final regex = RegExp(
                  r'^(0?[1-9]|1[0-2]):[0-5][0-9](AM|PM)\s-\s(0?[1-9]|1[0-2]):[0-5][0-9](AM|PM)$',
                  caseSensitive: false,
                );

                if (!regex.hasMatch(value.trim())) {
                  return "يجب أن تكون الصيغة مثل: 8:00AM - 12:00PM";
                }

                return null;
              },
            ),

            SizedBox(height: height(20)),
            AuthTextField(
                  controller: storeEmailController,
                  hintText: "البريد الالكتروني الخاص بالمتجر",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "البريد الالكتروني مطلوب";
                    }
                      if (!regex.hasMatch(
                        storeEmailController.text,
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
                  controller: storePhoneController,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "رقم الهاتف الخاص بالمتجر",
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
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Color(0x30B0B3BB),
                fixedSize: Size.fromWidth(1.sw),
                side: const BorderSide(color: AppColor.primary, width: 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                location.value = await Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => PickLocationPage()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 15,
                children: [
                  Icon(Icons.gps_fixed_rounded, color: AppColor.primary),
                  Text(
                    "تحديد موقع",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xff7A7A7A),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height(20)),

            ValueListenableBuilder(
              valueListenable: logo,
              builder: (context, selectedImage, _) {
                return GestureDetector(
                  onTap: () async {
                    logo.value = await HelperFunctions.pickImage();
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).primaryColor),
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
                              "لوغو",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                  ),
                );
              },
            ),

            SizedBox(height: height(20)),

            ValueListenableBuilder(
              valueListenable: mainImage,
              builder: (context, selectedImage, _) {
                return GestureDetector(
                  onTap: () async {
                    mainImage.value = await HelperFunctions.pickImage();
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).primaryColor),
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
                              "الصورة الرئيسية",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                  ),
                );
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
