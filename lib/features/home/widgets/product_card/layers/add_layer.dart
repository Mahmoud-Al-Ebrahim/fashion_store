import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/store/store_products_model.dart';
import '../../../../store/pages/store_screen.dart';
import '../../../pages/product_screen.dart';

class AddLayer extends StatelessWidget {
  final String productId;
  final double price;
  final bool isShowProductDetail;
  final bool? isRest;
  final Product? product;

  const AddLayer({
    super.key,
    required this.productId,
    required this.price,
    required this.isShowProductDetail,
    this.isRest = false,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isNotUser =
        false; //AuthServiceLocator.instance.role != TypeUser.user;
    return Positioned(
      bottom: -8,
      left: -2,
      child: GestureDetector(
        onTap: () {
          // if(isNotUser){
          //     showDialog(
          //       context: context,
          //       builder: (_) => BlocProvider.value(
          //         value: BlocProvider.of<StoreBloc>(context),
          //         child: AddOrEditProduct(product: product,)),
          //     );
          //   return ;
          // }
          isShowProductDetail && isRest == false
              ? context.pushPage(
                  ProductScreen(product: product!, store: product!.store!),
                )
              : isShowProductDetail && isRest == true
              ? context.pushPage(StoreScreen(storeId: productId))
              : print('object');
          ;
        },
        child: Container(
          height: height(47),
          width: width(47),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.22),
                blurRadius: 5,
                offset: const Offset(1, 1),
              ),
            ],
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: Center(
            child: Icon(
              isNotUser
                  ? Icons.edit
                  : isShowProductDetail
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 19,
            ),
          ),
        ),
      ),
    );
  }
}
