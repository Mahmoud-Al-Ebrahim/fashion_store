import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/widgets/button.dart';
import '../../../../core/screen_util.dart';

class AddToCardCard extends StatelessWidget {
  final double productPrice;
  final String productId;
  // final HomeAndProductBloc homeAndProductBloc;

  const AddToCardCard({
    super.key,
    required this.productPrice,
    required this.productId,
    // required this.homeAndProductBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(160),
      width: width(400),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.20),
            blurRadius: 22,
            offset: const Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height(25),
          horizontal: width(20),
        ),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                GestureDetector(
                  // onTap: () => bloc.add(IncreaseQuantity()),
                  child: SvgPicture.asset("assets/svg/add-circle.svg",color: Theme.of(context).colorScheme.primary,),
                ),
                Text(
                  "${1}",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  // onTap: () => bloc.add(DecreaseQuantity()),
                  child: SvgPicture.asset("assets/svg/minus-cirlce.svg",color: Theme.of(context).colorScheme.primary,),
                ),
                const Spacer(),
                Text(
                  "${150.toStringAsFixed(2)} \$",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: width(10)),
              ],
            ),
            // SizedBox(height: height(10)),
            //
            // BlocBuilder<HomeAndProductBloc, HomeAndProductState>(
            //   builder: (context, state) {
            //     return state.addToCartState.isLoading
            //         ? LinearProgressIndicator(
            //       minHeight: 2.5,
            //       backgroundColor: Theme.of(context)
            //           .colorScheme
            //           .surfaceTint
            //           .withOpacity(0.2),
            //     )
            //         : const SizedBox();
            //   },
            // ),
            SizedBox(height: height(10)),

            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: AuthButton(
                  onTap: () {
                    // ✅ تحقق من التوكن
                    // if (AuthServiceLocator.instance.token == null ||
                    //     AuthServiceLocator.instance.token!.isEmpty) {
                    //   showFlushBar(context, "يرجى تسجيل الدخول لتتمكن من إضافة المنتجات إلى السلة");
                    //   return;
                    // }
                    //
                    // // ✅ إذا في توكن → نفذ الحدث
                    // homeAndProductBloc.add(
                    //   AddToCartEvent(
                    //     params: AddToCartParams(
                    //       productId: productId,
                    //       quantity: state.quantity,
                    //     ),
                    //     onSuccess: () {
                    //       GoRouterHelper(context).pushNamed(ConfirmOrderPage.name);
                    //     }, onFailed: () {
                    //     GoRouterHelper(context).pushNamed(ConfirmOrderPage.name);
                    //
                    //   },
                    //   ),
                    // );
                  },

                  text: "اضف للسلة",
                  widthButton: 350,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
