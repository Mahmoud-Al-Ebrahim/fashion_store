import 'dart:io';

import 'package:fashion_store/features/auth/pages/sign_up/password_step.dart';
import 'package:fashion_store/features/auth/pages/sign_up/store_information_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../app/widgets/button.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/show_message.dart';
import '../../../../models/sign_up_request_model.dart';
import '../../../../models/store_info_model.dart';
import '../../../../models/store_owner_model.dart';
import '../../../../models/user_model.dart';
import '../../widgets/choose_account/choose_account_list.dart';
import 'additional_information_step.dart';
import 'contact_information_step.dart';
import 'owner_information_step.dart';

class SignUpScreen extends StatefulWidget {
  final String userType;

  final String userTypeTitle;

  const SignUpScreen({
    super.key,
    required this.userType,
    required this.userTypeTitle,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final bool isNormalUser;

  @override
  void initState() {
    super.initState();
    isNormalUser = widget.userType == AccountKindValue.normalUser.name;
    formKeys = List.generate(
      isNormalUser ? 4 : 5,
      (_) => GlobalKey<FormState>(),
    );
  }

  int currentStep = 0;

  /// OWNER / USER

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final genderController = TextEditingController();

  final birthDateController = TextEditingController();

  /// CONTACT

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final usernameController = TextEditingController();

  /// PASSWORD

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  /// STORE

  final storeEmailController = TextEditingController();

  final storePhoneController = TextEditingController();

  final storeNameController = TextEditingController();

  final addressController = TextEditingController();

  final descriptionController = TextEditingController();

  final workingHoursController = TextEditingController();

  final ValueNotifier<LatLng?> location = ValueNotifier(null);

  final ValueNotifier<XFile?> logo = ValueNotifier(null);

  final ValueNotifier<XFile?> mainImage = ValueNotifier(null);

  final ValueNotifier<XFile?> identityFront = ValueNotifier(null);

  final ValueNotifier<XFile?> identityBack = ValueNotifier(null);

  late final List<GlobalKey<FormState>> formKeys;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();

    genderController.dispose();
    birthDateController.dispose();

    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();

    passwordController.dispose();
    confirmPasswordController.dispose();

    storeNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    workingHoursController.dispose();

    super.dispose();
  }

  void nextStep() {
    final form = formKeys[currentStep];
    if (!(form.currentState?.validate()
        ??
        false)) {

      return;
    }

    if (!isNormalUser) {

      if (currentStep == 1) {

        if (location.value == null) {

          showMessage(
            "رجاء قم بتحديد الموقع",
          );

          return;
        }

        if (logo.value == null) {

          showMessage(
            "اختيار لوغو مطلوب",
          );

          return;
        }

        if (mainImage.value == null) {

          showMessage(
            "الصورة الرئيسية مطلوبة",
          );

          return;
        }
      }

      if (currentStep == 2) {

        if (identityFront.value ==
            null) {

          showMessage(
            "صورة الوجه الأمامي للهوية مطلوبة",
          );

          return;
        }

        if (identityBack.value ==
            null) {

          showMessage(
            "صورة الوجه الخلفي للهوية مطلوبة",
          );

          return;
        }
      }
    }

    final totalSteps = isNormalUser ? 4 : 5;

    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep == 0) {
      return;
    }

    setState(() {
      currentStep--;
    });
  }

  void submit() {
    if (!(formKeys.last.currentState?.validate() ?? false)) {
      return;
    }

    if (isNormalUser) {
      final request = SignUpRequest(
        accountType: "normalUser",
        email: emailController.text,
        phone: phoneController.text,
        username: usernameController.text,
        password: passwordController.text,
        normalUser: NormalUserInfo(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          gender: genderController.text,
          birthDate: birthDateController.text,
        ),
      );

      print(request.toJson());
    } else {
      final request = SignUpRequest(
        accountType: "store",
        email: emailController.text,
        phone: phoneController.text,
        username: usernameController.text,
        password: passwordController.text,

        owner: OwnerInfo(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          gender: genderController.text,
          birthDate: birthDateController.text,
          identityBack: File(identityBack.value!.path),
          identityFront: File(identityFront.value!.path),
        ),

        store: StoreInfo(
          storeName: storeNameController.text,
          address: addressController.text,
          description: descriptionController.text,
          workingHours: workingHoursController.text,
          latitude: location.value?.latitude,
          longitude: location.value?.longitude,
          logo: File(logo.value!.path),
          mainImage: File(mainImage.value!.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = isNormalUser
        ? [
            OwnerInformationStep(
              formKey: formKeys[0],
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              identityBack: identityBack,
              identityFront: identityFront,
            ),

            AdditionalInformationStep(
              formKey: formKeys[1],
              genderController: genderController,
              birthDateController: birthDateController,
            ),

            ContactInformationStep(
              formKey: formKeys[2],
              emailController: emailController,
              phoneController: phoneController,
              usernameController: usernameController,
            ),

            PasswordStep(
              formKey: formKeys[3],
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              onSubmit: submit,
            ),
          ]
        : [
            StoreInformationStep(
              formKey: formKeys[0],
              storeNameController: storeNameController,
              addressController: addressController,
              descriptionController: descriptionController,
              workingHoursController: workingHoursController,
              storeEmailController: storeEmailController,
              storePhoneController: storePhoneController,
              logo: logo,
              mainImage: mainImage,
              location: location,
            ),

            OwnerInformationStep(
              formKey: formKeys[1],
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              identityBack: identityBack,
              identityFront: identityFront,
            ),

            AdditionalInformationStep(
              formKey: formKeys[2],
              genderController: genderController,
              birthDateController: birthDateController,
            ),

            ContactInformationStep(
              formKey: formKeys[3],
              emailController: emailController,
              phoneController: phoneController,
              usernameController: usernameController,
            ),

            PasswordStep(
              formKey: formKeys[4],
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              onSubmit: submit,
            ),
          ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(15)),
        child: Column(
          children: [
            SizedBox(height: 75),

            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentStep > 0) 20.horizontalSpace,

                        Text(
                          "انشاء حساب / ",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),

                        Text(
                          widget.userTypeTitle,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: const Color(0xff7A7A7A),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    if (!isNormalUser) ...{
                      Text(
                        currentStep == 0
                            ? "( معلومات عن المتجر )"
                            : "( معلومات مالك المتجر )",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xff7A7A7A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    },
                  ],
                ),

                if (currentStep > 0)
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: previousStep,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: height(40)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width(40)),
              child: StepProgressIndicator(
                totalSteps: steps.length,
                currentStep: currentStep + 1,
                size: 6,
                selectedColor: Theme.of(context).primaryColor,
                unselectedColor: Colors.grey[300]!,
                roundedEdges: const Radius.circular(12),
              ),
            ),

            Expanded(child: steps[currentStep]),

            if (currentStep != steps.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(10)),
                child: AuthButton(text: "التالي", onTap: nextStep),
              ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
