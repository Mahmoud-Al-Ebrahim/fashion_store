// import 'dart:io';
//
// import 'package:fashion_store/features/auth/pages/sign_up/second_step.dart';
// import 'package:fashion_store/features/auth/pages/sign_up/third_step.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
//
// import '../../../../app/widgets/button.dart';
// import '../../../../core/screen_util.dart';
// import '../../../../core/utils/show_message.dart';
// import '../../widgets/choose_account/choose_account_contructor_params.dart';
// import '../../widgets/choose_account/choose_account_list.dart';
// import 'first_step.dart';
// import 'fourth_step.dart';
//
// class SignUpScreen extends StatefulWidget {
//   final String userType;
//   final String userTypeTitle;
//
//   const SignUpScreen({
//     super.key,
//     required this.userType,
//     required this.userTypeTitle,
//   });
//
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   late final bool isForUserAccount;
//
//   @override
//   initState() {
//     isForUserAccount =
//         widget.userType == AccountKindValue.normalUser.toString();
//     print("userType ______________________-${widget.userType}");
//     super.initState();
//   }
//
//   // store or store additional inputs
//   final locationController = TextEditingController();
//   final informationAboutStoreController = TextEditingController();
//   final storeNameController = TextEditingController();
//   final ValueNotifier<XFile?> logo = ValueNotifier(null);
//   final ValueNotifier<XFile?> mainImage = ValueNotifier(null);
//   final ValueNotifier<XFile?> identity1 = ValueNotifier(null);
//   final ValueNotifier<XFile?> identity2 = ValueNotifier(null);
//   final ValueNotifier<LatLng?> location = ValueNotifier(null);
//
//   final categoryIdController = TextEditingController();
//   final countryIdController = TextEditingController();
//   final workingHours = TextEditingController();
//
//   int currentStep = 1;
//
//   // Controllers
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final usernameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final confirmPassword = TextEditingController();
//
//   // Controllers للخطوة الثالثة
//   final genderController = TextEditingController();
//   final birthDateController = TextEditingController();
//
//   // Form keys
//   final firstStepFormKey = GlobalKey<FormState>();
//   final secondStepFormKey = GlobalKey<FormState>();
//   final thirdStepFormKey = GlobalKey<FormState>();
//   final fourthStepFormKey = GlobalKey<FormState>();
//
//   // bloc
//
//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneController.dispose();
//     genderController.dispose();
//     birthDateController.dispose();
//     confirmPassword.dispose();
//     storeNameController.dispose();
//     locationController.dispose();
//     location.dispose();
//     usernameController.dispose();
//     informationAboutStoreController.dispose();
//     categoryIdController.dispose();
//     countryIdController.dispose();
//     workingHours.dispose();
//     super.dispose();
//   }
//
//   void nextStep() {
//     GlobalKey<FormState> currentFormKey;
//     switch (currentStep) {
//       case 1:
//         currentFormKey = firstStepFormKey;
//         break;
//       case 2:
//         currentFormKey = secondStepFormKey;
//         break;
//       case 3:
//         currentFormKey = thirdStepFormKey;
//       case 4:
//         currentFormKey = fourthStepFormKey;
//         break;
//       default:
//         currentFormKey = firstStepFormKey;
//     }
//
//     if (location.value == null && !isForUserAccount) {
//       showMessage("رجاء قم بتحديد الموقع");
//       return;
//     }
//
//     if (logo.value == null && !isForUserAccount) {
//       showMessage("اختيار لوغو مطلوب!");
//       return;
//     }
//     if (mainImage.value == null && !isForUserAccount) {
//       showMessage("صورة المتجر الرئيسية مطلوبة!");
//       return;
//     }
//     if (identity1.value == null && !isForUserAccount && currentStep == 3) {
//       showMessage("صورة الوجه الأمامي للهوية مطلوب!");
//       return;
//     }
//     if (identity2.value == null && !isForUserAccount && currentStep == 3) {
//       showMessage("صورة الوجه الخلفي للهوية مطلوب!");
//       return;
//     }
//     if (currentFormKey.currentState?.validate() ?? false) {
//       if (currentStep < 5) {
//         setState(() => currentStep++);
//       } else {
//         submitData();
//       }
//     }
//   }
//
//   void submitData() {
//     final data = {
//       "firstName": firstNameController.text,
//       "lastName": lastNameController.text,
//       "email": emailController.text,
//       "password": passwordController.text,
//       "phone": phoneController.text,
//       "gender": genderController.text,
//       "birthDate": birthDateController.text,
//     };
//
//     print("Sending data: $data");
//     // تبعت للـ backend
//   }
//
//   void previousStep() {
//     if (currentStep > 1) {
//       setState(() => currentStep--);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final stepsContent = [
//       FirstStep(
//         formKey: firstStepFormKey,
//         secondNameController: firstNameController,
//         firstNameController: lastNameController,
//         isForUserAccount: isForUserAccount,
//         informationAboutStoreController: informationAboutStoreController,
//         locationController: locationController,
//         storeName: storeNameController,
//         location: location,
//         logo: logo,
//         mainImage: mainImage,
//         userType: widget.userType,
//       ),
//       SecondStep(
//         emailController: emailController,
//         phoneController: phoneController,
//         usernameController: usernameController,
//         formKey: secondStepFormKey,
//       ),
//       Form(
//         key: thirdStepFormKey,
//         child: ThirdStep(
//           genderController: genderController,
//           birthDateController: birthDateController,
//           identity1: identity1,
//           identity2: identity2,
//           isForUserAccount: isForUserAccount,
//           workingHours: workingHours,
//         ),
//       ),
//       FourthStep(
//         passwordController: passwordController,
//         confirmPasswordController: confirmPassword,
//         formKey: fourthStepFormKey,
//         params: ChooseAccountConstructorParams(
//           firstName: firstNameController.text,
//           lastName: lastNameController.text,
//           email: emailController.text,
//           gender: genderController.text,
//           birthDate: birthDateController.text,
//           userType: widget.userType == AccountKindValue.store.toString()
//               ? "store"
//               : "normalUser",
//           location: locationController.text,
//           information: informationAboutStoreController.text,
//           workingHours: workingHours.text,
//           storeName: storeNameController.text,
//           latitude: location.value?.latitude,
//           longitude: location.value?.longitude,
//           storeLogo: logo.value != null ? File(logo.value!.path) : null,
//           identity1: identity1.value != null
//               ? File(identity1.value!.path)
//               : null,
//           identity2: identity2.value != null
//               ? File(identity2.value!.path)
//               : null,
//           storeMainImage: mainImage.value != null
//               ? File(mainImage.value!.path)
//               : null,
//         ),
//       ),
//       //  FifthStep(),
//     ];
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: width(15)),
//         child: Column(
//           children: [
//             SizedBox(height: 75),
//             Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 // النص بالنص
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (currentStep > 1)
//                     20.horizontalSpace,
//                     Text(
//                       "انشاء حساب/ ",
//                       style: Theme.of(context).textTheme.displaySmall,
//                     ),
//                     Text(
//                       widget.userTypeTitle,
//                       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                         color: Color(0xff7A7A7A),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // زر العودة عاليمين
//                 if (currentStep > 1)
//                   Positioned(
//                     right: 0,
//                     child: InkWell(
//                       onTap: previousStep,
//                       borderRadius: BorderRadius.circular(50),
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_back,
//                           size: 20,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: height(40)),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: width(40)),
//               child: StepProgressIndicator(
//                 totalSteps: 4,
//                 currentStep: currentStep,
//                 size: 0.6,
//                 selectedColor: Theme.of(context).colorScheme.primary,
//                 unselectedColor: Colors.grey[300]!,
//                 roundedEdges: Radius.circular(10),
//               ),
//             ),
//
//             // if (currentStep == 5)
//             // Expanded(
//             //   child: LayoutBuilder(
//             //     builder: (context, constraints) {
//             //       // FifthStep هو اللي ممكن يكون طويل
//             //       return FifthStep(
//             //         chooseAccountConstructorParams:
//             //             ChooseAccountConstructorParams(
//             //               firstName: firstNameController.text,
//             //               lastName: lastNameController.text,
//             //               email: emailController.text,
//             //               password: passwordController.text,
//             //               confirmPassword: confirmPassword.text,
//             //               gender: genderController.text,
//             //               birthDate: birthDateController.text,
//             //               userType: widget.userType,
//             //             ),
//             //       ); // FifthStep نفسه داخله Grid مع scroll
//             //     },
//             //   ),
//             // ),
//             SizedBox(
//               height: height(
//                 currentStep == 2
//                     ? 300
//                     : currentStep == 4
//                     ? 290
//                     : (!isForUserAccount && currentStep == 1)
//                     ? (1.sh - 300)
//                     : (!isForUserAccount && currentStep == 3)
//                     ? (0.7.sh)
//                     : 240,
//               ),
//               child: stepsContent[currentStep - 1],
//             ),
//             if (currentStep != 4)
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width(10)),
//                 child: AuthButton(onTap: nextStep, text: 'التالي'),
//               ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
