import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../app/widgets/button.dart';
import '../../../../../core/screen_util.dart';

class CartSummaryView extends StatelessWidget {
  const CartSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: height(165),
        width: width(400),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .onPrimary,
          boxShadow: [
            BoxShadow(
              color: Theme
                  .of(context)
                  .colorScheme
                  .shadow
                  .withOpacity(0.20),
              blurRadius: 22,
              offset: const Offset(0, -2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            right: width(20),
            left: width(20),
            top: height(30),
            bottom: height(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/svg/garbage.svg"),
                  SizedBox(width: width(4)),
                  // state.selectedProductIds.length
                  Text(
                    "عدد الطلبات: ${2}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .shadow,
                    ),
                  ),
                  Spacer(),
                  // state.totalPrice
                  Text(
                    " ${135400.toStringAsFixed(2)} \$",
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .shadow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: height(10)),
              //
              // BlocBuilder<OrderBloc, OrderState>(
              //   builder: (context, state) {
              //
              //     return state.addMultipleItemsToCartState.isLoading
              //         ? LinearProgressIndicator(
              //       minHeight: 2.5,
              //       backgroundColor: Theme
              //           .of(
              //         context,
              //       )
              //           .colorScheme
              //           .surfaceTint
              //           .withOpacity(0.2),
              //     )
              //         : const SizedBox();
              //   },
              // ),
              SizedBox(height: height(10)),

              // BlocBuilder<OrderBloc, OrderState>(
              //   builder: (context, addMultipleItemsToCartState) {
              //     return
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: AuthButton(

                    onTap: () {
                      // final cartState = context.read<CartCubit>().state;
                      //
                      // final params = AddMultipleItemsToCartParams(
                      //   items: cartState.selectedProductIds.map((productId) {
                      //     return CartItemParam(productId: productId, quantity: 1); // 👈 quantity = 1 دايماً
                      //   }).toList(),
                      // );
                      //
                      // BlocProvider.of<OrderBloc>(context).add(
                      //   AddMultipleItemsToCartEvent(
                      //     addMultipleItemsToCartParams: params,
                      //     onSuccess: () {
                      //       print('success baby');
                      //     },
                      //   ),
                      // );
                    },
                    text: "اضف للسلة",
                    widthButton: 350,
                  ),
                ),
              ),
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
    // return BlocBuilder<CartCubit, CartState>(
    //   builder: (context, state) {
    //     if (state.selectedProductIds.isEmpty) {
    //       return const SizedBox.shrink();
    //     }
    //
    //     return Positioned(
    //       bottom: 0,
    //       left: 0,
    //       right: 0,
    //       child: Container(
    //         height: height(165),
    //         width: width(400),
    //         decoration: BoxDecoration(
    //           color: Theme
    //               .of(context)
    //               .colorScheme
    //               .onPrimary,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Theme
    //                   .of(context)
    //                   .colorScheme
    //                   .shadow
    //                   .withOpacity(0.20),
    //               blurRadius: 22,
    //               offset: const Offset(0, -2),
    //               spreadRadius: 1,
    //             ),
    //           ],
    //         ),
    //         child: Padding(
    //           padding: EdgeInsets.only(
    //             right: width(20),
    //             left: width(20),
    //             top: height(30),
    //             bottom: height(20),
    //           ),
    //           child: Column(
    //             children: [
    //               Row(
    //                 children: [
    //                   SvgPicture.asset(Assets.svgGarbage),
    //                   SizedBox(width: width(4)),
    //                   Text(
    //                     "عدد الطلبات: ${state.selectedProductIds.length}",
    //                     style: Theme
    //                         .of(context)
    //                         .textTheme
    //                         .labelLarge!
    //                         .copyWith(
    //                       color: Theme
    //                           .of(context)
    //                           .colorScheme
    //                           .shadow,
    //                     ),
    //                   ),
    //                   Spacer(),
    //                   Text(
    //                     " ${state.totalPrice.toStringAsFixed(2)} \$",
    //                     style: TextStyle(
    //                       color: Theme
    //                           .of(context)
    //                           .colorScheme
    //                           .shadow,
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               // SizedBox(height: height(10)),
    //               //
    //               // BlocBuilder<OrderBloc, OrderState>(
    //               //   builder: (context, state) {
    //               //
    //               //     return state.addMultipleItemsToCartState.isLoading
    //               //         ? LinearProgressIndicator(
    //               //       minHeight: 2.5,
    //               //       backgroundColor: Theme
    //               //           .of(
    //               //         context,
    //               //       )
    //               //           .colorScheme
    //               //           .surfaceTint
    //               //           .withOpacity(0.2),
    //               //     )
    //               //         : const SizedBox();
    //               //   },
    //               // ),
    //               SizedBox(height: height(10)),
    //
    //               // BlocBuilder<OrderBloc, OrderState>(
    //               //   builder: (context, addMultipleItemsToCartState) {
    //               //     return
    //                     Align(
    //                     alignment: Alignment.topCenter,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left: 0),
    //                       child: AuthButton(
    //
    //                           onTap: () {
    //                             // final cartState = context.read<CartCubit>().state;
    //                             //
    //                             // final params = AddMultipleItemsToCartParams(
    //                             //   items: cartState.selectedProductIds.map((productId) {
    //                             //     return CartItemParam(productId: productId, quantity: 1); // 👈 quantity = 1 دايماً
    //                             //   }).toList(),
    //                             // );
    //                             //
    //                             // BlocProvider.of<OrderBloc>(context).add(
    //                             //   AddMultipleItemsToCartEvent(
    //                             //     addMultipleItemsToCartParams: params,
    //                             //     onSuccess: () {
    //                             //       print('success baby');
    //                             //     },
    //                             //   ),
    //                             // );
    //                           },
    //                         text: "اضف للسلة",
    //                         widthButton: 350,
    //                       ),
    //                     ),
    //                   ),
    //               //   },
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
