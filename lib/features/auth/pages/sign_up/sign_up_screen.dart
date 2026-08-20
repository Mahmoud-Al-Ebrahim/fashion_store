import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../app/widgets/button.dart';
import '../../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/show_message.dart';
import '../sign_in_screen/otp_verification_page.dart';
import 'additional_information_step.dart';
import 'contact_information_step.dart';
import 'owner_information_step.dart';
import 'password_step.dart';

/// Customer registration (`Auth/Register`) in four steps.
///
/// Store sign-up is no longer part of this flow: the backend creates stores
/// through `StoreRequest/Add` *after* a user account exists, so becoming a
/// seller now lives behind "Open your own store" in the drawer. Location and
/// national-ID capture were removed here for the same reason.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int currentStep = 0;
  late final List<GlobalKey<FormState>> formKeys;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  }

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
    super.dispose();
  }

  void nextStep() {
    if (!(formKeys[currentStep].currentState?.validate() ?? false)) return;
    if (currentStep == 1 &&
        (genderController.text.isEmpty || birthDateController.text.isEmpty)) {
      showMessage(LK.commonRequiredField.tr());
      return;
    }
    if (currentStep < formKeys.length - 1) {
      setState(() => currentStep++);
    }
  }

  void previousStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void submit() {
    if (!(formKeys.last.currentState?.validate() ?? false)) return;
    final birthDate = DateTime.tryParse(birthDateController.text.trim());
    if (birthDate == null) {
      showMessage(LK.commonRequiredField.tr());
      return;
    }
    context.read<AuthBloc>().add(
      RegisterEvent(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        userName: usernameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        gender: genderController.text.trim(),
        birthDate: birthDate,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      OwnerInformationStep(
        formKey: formKeys[0],
        firstNameController: firstNameController,
        lastNameController: lastNameController,
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
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.registerStatus != c.registerStatus,
        listener: (context, state) {
          if (state.registerStatus == RegisterStatus.success) {
            showMessage(LK.authRegisterSuccess.tr(), hasError: false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OTPVerificationPage(
                  email: emailController.text.trim(),
                  cameFromRegisterPage: true,
                ),
              ),
            );
          } else if (state.registerStatus == RegisterStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(15)),
          child: Column(
            children: [
              SizedBox(height: height(75)),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Text(
                    LK.authRegister.tr(),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  if (currentStep > 0)
                    PositionedDirectional(
                      end: 0,
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
                  child: AuthButton(
                    text: LK.commonNext.tr(),
                    onTap: nextStep,
                  ),
                ),
              SizedBox(height: height(20)),
            ],
          ),
        ),
      ),
    );
  }
}
