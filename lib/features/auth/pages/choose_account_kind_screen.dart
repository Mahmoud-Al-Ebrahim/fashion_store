import 'package:fashion_store/core/helper/helper_functions.dart';
import 'package:fashion_store/features/auth/pages/sign_up/sign_up_screen.dart';
import 'package:fashion_store/features/auth/pages/sign_up/stepper.dart';
import 'package:flutter/material.dart';
import '../../../app/widgets/button.dart';
import '../../../core/screen_util.dart';
import '../widgets/choose_account/choose_account_list.dart';
import '../widgets/choose_account/choose_account_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChooseAccountKindScreen extends StatefulWidget {
  static String name = "ChooseAccountKindScreen";
  static String route = "/ChooseAccountKindScreen";

  const ChooseAccountKindScreen({super.key});

  @override
  State<ChooseAccountKindScreen> createState() =>
      _ChooseAccountKindScreenState();
}

class _ChooseAccountKindScreenState extends State<ChooseAccountKindScreen> {
  int? selectedIndex;
  String? selectedValue;
  String? selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: height(75)),
            Center(
              child: Text(
                "اختر نوع الحساب",
                style: Theme
                    .of(context)
                    .textTheme
                    .displaySmall,
              ),
            ).animate().slide(
              begin: const Offset(1, 0), // من اليمين
              end: Offset.zero,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
            SizedBox(height: height(40)),
            SizedBox(
              height: height(250),
              child:
              GridView.builder(
                itemCount: kinds.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final kind = kinds[index];
                  return AccountKindItem(
                    title: kind.title,
                    icon: kind.icon,
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedValue = kind.value.name;
                        selectedTitle = kind.title;
                      });
                    },
                  );
                },
              ).animate().slide(
                begin: const Offset(-1, 0), // من اليسار
                end: Offset.zero,
                duration: 600.ms,
                curve: Curves.easeOut,
              ),
            ),
            SizedBox(height: height(20)),
            GestureDetector(
              onTap: selectedIndex != null
                  ? () {
                // هنا تنفذ أي عملية تريدها
                print("القيمة المختارة: ${selectedValue}");
              }
                  : null, // لو ما في اختيار ما يصير الضغط
              child:
              selectedIndex !=
                  null // يظهر الزر فقط لو في اختيار
                  ? AuthButton(
                text: 'التالي',
                onTap: () {
                  HelperFunctions.navigateToPage(context, SignUpScreen(
                      userType: selectedValue!, userTypeTitle: selectedTitle!));
                },
              )
                  : const SizedBox.shrink(), // ما يظهر أي شيء لو ما في اختيار
            ),
          ],
        ),
      ),
    );
  }
}
