import 'package:fashion_store/core/helper/helper_functions.dart';
import 'package:fashion_store/features/auth/pages/choose_account_kind_screen.dart';
import 'package:fashion_store/features/auth/pages/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../app/widgets/button.dart';
import '../../../../core/screen_util.dart';
import '../../../nav_bar/user_nav_bar/user_nav_bar_screen.dart';
class ColumnLayer extends StatelessWidget {
  const ColumnLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: height(52),
      right: width(19),
      left: width(17),
      child: Column(
        spacing: height(23.5),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                const TextSpan(text: "مرحبا بك في "),
                TextSpan(
                  text: "موضة",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const TextSpan(text: " _ منصتك لبيع"),
              ],
            ),
          ),
          Text(
            "وشراء أحدث صيحات الموضة",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Row(
            spacing: width(10),
            children: [
              SvgPicture.asset("assets/svg/done_on_boarding.svg"),
              Text(
                " هنا تلتقي الخبرات والأذواق العالمية",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: width(10),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: height(21)),
                child: SvgPicture.asset("assets/svg/done_on_boarding.svg"),
              ),
              Flexible(
                child: Text(
                  " تصفح أزياءنا، اطلب مايليق بمناسبتك، أو شارك إبداعاتك بكل سهولة وأمان..",
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                    height: height(1.5),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              AuthButton(
                onTap: (){
                  HelperFunctions.navigateToPage(context , SignInScreen());
                },
                heightButton: 52,
                widthButton: 167,
                text: 'تسجيل الدخول',
              ),
              SizedBox(width: width(10)),
              AuthButton(
                onTap: (){
                  HelperFunctions.navigateToPage(context , ChooseAccountKindScreen());
                },
                heightButton: 52,
                widthButton: 167,
                isWhiteBackground: true,
                text: 'أنشىء حساب',
              ),
            ],
          ),
          InkWell(
            onTap: () {
              HelperFunctions.navigateToPageAndPopAll(context , UserNavBar());
            },
            child: Row(
              spacing: width(10),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async{
                    HelperFunctions.navigateToPageAndPopAll(context , UserNavBar());
                  },
                  child: Text(
                    "اكمل التصفح كزائر",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    HelperFunctions.navigateToPageAndPopAll(context , UserNavBar());
                  },
                    child: SvgPicture.asset("assets/svg/next.svg",height: 30,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
