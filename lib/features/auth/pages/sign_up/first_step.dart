import 'dart:io';

import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:fashion_store/core/theme/app_color.dart';
import 'package:fashion_store/features/auth/pages/sign_up/pick_location_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/helper/helper_functions.dart';
import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';

class FirstStep extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController secondNameController;
  final TextEditingController locationController;
  final TextEditingController informationAboutStoreController;
  final TextEditingController storeName;

  final GlobalKey<FormState> formKey;
  final bool isForUserAccount;
  final ValueNotifier<XFile?> logo;
  final ValueNotifier<XFile?> mainImage;
  final ValueNotifier<LatLng?> location;

  final String userType;

  const FirstStep({
    super.key,
    required this.firstNameController,
    required this.secondNameController,
    required this.formKey,
    required this.isForUserAccount,
    required this.logo,
    required this.mainImage,
    required this.storeName,
    required this.locationController,
    required this.informationAboutStoreController,
    required this.userType,
    required this.location,
  });

  @override
  State<FirstStep> createState() => _FirstStepState();
}

class _FirstStepState extends State<FirstStep> {
  late final TextEditingController categoryTextController;
  late final TextEditingController countryTextController;

  late String title;

  @override
  void initState() {
    title = "المتجر";
    categoryTextController = TextEditingController();
    countryTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    categoryTextController.dispose();
    countryTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height(35)),

            // الحقل الأول
            AuthTextField(
                  controller: widget.firstNameController,
                  hintText: "الاسم الاول",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الاسم مطلوب";
                    }
                    if (value.length < 3) {
                      return "الاسم  الاول يجب ان يكون اكثر من 3 احرف";
                    }
                    return null;
                  },
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(1, 0), duration: 400.ms),

            SizedBox(height: height(3)),

            // الحقل الثاني
            AuthTextField(
                  controller: widget.secondNameController,
                  hintText: "الاسم الاخير",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الاسم مطلوب";
                    }
                    if (value.length < 3) {
                      return "الاسم الاخير يجب ان يكون اكثر من 3 احرف";
                    }
                    return null;
                  },
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms) // تأخير بسيط
                .slide(begin: const Offset(1, 0), duration: 400.ms),
            // من اليمين لليسار
            if (!widget.isForUserAccount) ...{
              AuthTextField(
                    controller: widget.storeName,
                    hintText: "اسم $title",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "هذا الحقل مطلوب";
                      }
                      return null;
                    },
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slide(begin: const Offset(1, 0), duration: 400.ms),

              AuthTextField(
                    controller: widget.locationController,
                    hintText: "العنوان",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "العنوان مطلوب";
                      }
                      return null;
                    },
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slide(begin: const Offset(1, 0), duration: 400.ms),

              AuthTextField(
                    controller: widget.informationAboutStoreController,
                    hintText: "نبذة عن $title",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يجب إدخال نبذة عن $title";
                      }
                      return null;
                    },
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slide(begin: const Offset(1, 0), duration: 400.ms),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0x30B0B3BB),
                  fixedSize: Size.fromWidth(1.sw),
                  side: const BorderSide(color: Color(0x38F27D72), width: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  widget.location.value = await Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => PickLocationPage()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    Icon(Icons.gps_fixed_rounded, color: AppColor.primary),
                    Text("تحديد موقع", style: context.textTheme.bodyMedium),
                  ],
                ),
              ),
              SizedBox(height: height(15)),
              ValueListenableBuilder(
                valueListenable: widget.logo,
                builder: (context, selectedImage, _) {
                  return GestureDetector(
                    onTap: () async {
                      widget.logo.value = await HelperFunctions.pickImage();
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
                valueListenable: widget.mainImage,
                builder: (context, selectedImage, _) {
                  return GestureDetector(
                    onTap: () async {
                      widget.mainImage.value =
                          await HelperFunctions.pickImage();
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
                                "صورة رئيسية",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: height(30)),
            },
          ],
        ),
      ),
    );
  }
}
