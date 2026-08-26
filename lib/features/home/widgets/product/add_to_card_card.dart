import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/widgets/button.dart';
import '../../../../blocs/cart_bloc/cart_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/session.dart';
import '../../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../shop/widgets/price_tag.dart';

/// Bottom "add to cart" bar - original design, now driven by the real cart
/// bloc. Quantity is local until the item is added; the button is disabled
/// until a size has been chosen (the API keys cart items by `productSizeId`).
class AddToCardCard extends StatefulWidget {
  final double unitPrice;
  final int? selectedProductSizeId;

  const AddToCardCard({
    super.key,
    required this.unitPrice,
    required this.selectedProductSizeId,
  });

  @override
  State<AddToCardCard> createState() => _AddToCardCardState();
}

class _AddToCardCardState extends State<AddToCardCard> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAdd = widget.selectedProductSizeId != null;

    return Container(
      height: height(170),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height(20),
          horizontal: width(20),
        ),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _quantity++),
                  child: SvgPicture.asset(
                    "assets/svg/add-circle.svg",
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  '$_quantity',
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                  child: SvgPicture.asset(
                    "assets/svg/minus-cirlce.svg",
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatPrice(widget.unitPrice * _quantity)} ${LK.commonCurrency.tr()}',
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: width(10)),
              ],
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return state.addToCartStatus == AddToCartStatus.loading
                    ? LinearProgressIndicator(
                        minHeight: 2.5,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.2),
                      )
                    : const SizedBox(height: 2.5);
              },
            ),
            SizedBox(height: height(10)),
            AuthButton(
              onTap: !canAdd
                  ? null
                  : () async {
                      // Guests may browse, but the cart needs an account.
                      if (!await requireAuth(
                        context,
                        onSignIn: () => HelperFunctions.navigateToPageAndPopAll(
                          context,
                          const SignInScreen(),
                          true,
                        ),
                      )) {
                        return;
                      }
                      if (!context.mounted) return;
                      context.read<CartBloc>().add(
                        AddToCartEvent(
                          productSizeId: widget.selectedProductSizeId!,
                          quantity: _quantity,
                        ),
                      );
                    },
              color: canAdd ? null : Colors.grey,
              text: canAdd
                  ? LK.productAddToCart.tr()
                  : LK.productSelectSizeFirst.tr(),
              widthButton: double.infinity,
              heightButton: height(54),
            ),
          ],
        ),
      ),
    );
  }
}
