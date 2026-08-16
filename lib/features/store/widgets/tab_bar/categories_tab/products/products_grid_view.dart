import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../home/widgets/product_card/product-card.dart';

class ProductsGridView extends StatefulWidget {
  final String storeId;
  // final StoreBloc storeBloc;

  const ProductsGridView({
    super.key,
    required this.storeId,
    // required this.storeBloc,
  });

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  @override
  Widget build(BuildContext context) {

    return SliverGrid.builder(
      itemCount: fakeProducts.products!.length , //state.products!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final product = fakeProducts.products![index];
        return ProductCard(isWithDetail: true, product: product, isShowProductDetail: false,);
      },
    );
    // return BlocSelector<
    //   StoreBloc,
    //   StoreState,
    //   BlocStateData<StoreProductsModel>
    // >(
    //   selector: (state) => state.storeProductsState,
    //   builder: (context, state) {
    //     return SliverToBoxAdapter(
    //       child: BlocStateDataBuilder<StoreProductsModel>(
    //         data: state,
    //         // حالة التحميل
    //         onLoading: ProductsShimmer(),
    //
    //         // الحالة الناجحة
    //         onSuccess: (state) {
    //           if (state == null ||
    //               state.products == null ||
    //               state.products!.isEmpty) {
    //             return SizedBox(
    //               height: 200,
    //               child: Center(child: Text("لا توجد منتجات بعد")),
    //             );
    //           }
    //           return GridView.builder(
    //             physics: const NeverScrollableScrollPhysics(),
    //             shrinkWrap: true,
    //             itemCount: state.products!.length,
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 0,
    //               vertical: 0,
    //             ),
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 2,
    //               mainAxisSpacing: 30,
    //               crossAxisSpacing: 30,
    //               childAspectRatio: 0.85,
    //             ),
    //             itemBuilder: (context, index) {
    //               final product = state.products![index];
    //               return ProductCard(isWithDetail: true, product: product, isShowProductDetail: false,);
    //             },
    //           );
    //         },
    //
    //         // حالة الخطأ
    //         onFailed: Center(
    //           child: NoData(heightt: 400, text: state.message ?? "حدث خطأ ما!"),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
