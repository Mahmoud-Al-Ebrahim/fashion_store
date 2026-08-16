import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/screen_util.dart';
import 'cart_summary_view.dart';
import 'choose_products_category_section/choose_products_category.dart';
import 'products/add_or_edit_product.dart';
import 'products/products_grid_view.dart';

class CategoriesTab extends StatefulWidget {
  // final AuthUserBloc authUserBloc;
  final String storeId;
  // final StoreBloc storeBloc;

  const CategoriesTab({
    super.key,
    // required this.authUserBloc,
    required this.storeId,
    // required this.storeBloc,
  });

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // late OrderBloc orderBloc;

  @override
  void initState() {
    super.initState();

    // widget.storeBloc.add(
    //   StoreProductsEvent(
    //     storeId: widget.storeId,
    //     params: StoreProductsParams(storeId: widget.storeId, page: '1'),
    //   ),
    // );
    // orderBloc = getIt<OrderBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ChooseProductsCategory(
                      // authUserBloc: widget.authUserBloc,
                      storeId: widget.storeId,
                      // storeBloc: widget.storeBloc,
                    ),
                    SizedBox(height: height(20)),
                  ],
                ),
              ),
              // if(AuthServiceLocator.instance.role != TypeUser.user)...{
              //   SliverToBoxAdapter(
              //     child: BlocBuilder<StoreBloc, StoreState>(
              //       buildWhen: (p, c) => p.addProductState != c.addProductState,
              //       builder: (context, state) {
              //         return state.addProductState.isLoading
              //             ? Center(child: MinBaytyLoader())
              //             : InkWell(
              //           onTap: () async {
              //             showDialog(
              //               context: context,
              //               builder: (_) =>
              //                   BlocProvider.value(
              //                     value: BlocProvider.of<StoreBloc>(
              //                         context),
              //                     child: AddOrEditProduct(),),
              //             );
              //           },
              //           child: Container(
              //             width: 1.sw - 50,
              //             height: height(40),
              //             decoration: BoxDecoration(
              //               color: Colors.orange.shade100,
              //               borderRadius: BorderRadius.circular(20),
              //               border: Border.all(color: Color(0x38666A7A)),
              //             ),
              //             child: Stack(
              //               children: [
              //                 const Center(
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Icon(
              //                         Icons.add,
              //                         size: 40,
              //                         color: Colors.deepOrange,
              //                       ),
              //                       Text("إضافة صنف جديد"),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              //   SliverToBoxAdapter(child: SizedBox(height: height(20)),)
              // },
              ProductsGridView(
                storeId: widget.storeId,
                // storeBloc: widget.storeBloc,
              ),
              SliverToBoxAdapter(child: SizedBox(height: 130)),
            ],
          ),
        ),

        /// 🟢 الكارت بأسفل الصفحة
        const CartSummaryView(),
      ],
    );
  }
}
