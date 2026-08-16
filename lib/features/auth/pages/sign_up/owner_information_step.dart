import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../../core/screen_util.dart';

class OwnerInformationStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  final ValueNotifier<XFile?> identityFront;

  final ValueNotifier<XFile?> identityBack;
  const OwnerInformationStep({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController, required this.identityFront, required this.identityBack,
  });

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
              hintText: "الاسم الاول",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الاسم مطلوب";
                }

                if (value.length < 3) {
                  return "الاسم الاول يجب ان يكون اكثر من 3 احرف";
                }

                return null;
              },
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(
              begin: const Offset(1, 0),
              duration: 400.ms,
            ),

            SizedBox(height: height(5)),

            AuthTextField(
              controller: lastNameController,
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
                .fadeIn(
              duration: 400.ms,
              delay: 150.ms,
            )
                .slide(
              begin: const Offset(1, 0),
              duration: 400.ms,
            ),
            ValueListenableBuilder(
              valueListenable: identityFront,
              builder: (
                  context,
                  selectedImage,
                  _,
                  ) {

                return GestureDetector(
                  onTap: () async {

                    identityFront.value =
                    await HelperFunctions
                        .pickImage();
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                      Colors.grey.shade200,
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                      border: Border.all(
                        color:
                        Theme.of(context)
                            .primaryColor,
                        width: 1,
                      ),
                    ),
                    child: selectedImage !=
                        null
                        ? ClipRRect(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                      child: Image.file(
                        File(
                          selectedImage
                              .path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(
                      child: Text(
                        "الوجه الأمامي للهوية",
                        style: TextStyle(
                          color: Colors
                              .grey
                              .shade700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(
              begin: const Offset(1, 0),
              duration: 400.ms,
            ),

            SizedBox(height: height(20)),

            ValueListenableBuilder(
              valueListenable: identityBack,
              builder: (
                  context,
                  selectedImage,
                  _,
                  ) {

                return GestureDetector(
                  onTap: () async {

                    identityBack.value =
                    await HelperFunctions
                        .pickImage();
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                      Colors.grey.shade200,
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                      border: Border.all(
                        color:
                        Theme.of(context)
                            .primaryColor,
                        width: 1,
                      ),
                    ),
                    child: selectedImage !=
                        null
                        ? ClipRRect(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                      child: Image.file(
                        File(
                          selectedImage
                              .path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(
                      child: Text(
                        "الوجه الخلفي للهوية",
                        style: TextStyle(
                          color: Colors
                              .grey
                              .shade700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(
              duration: 400.ms,
              delay: 250.ms,
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