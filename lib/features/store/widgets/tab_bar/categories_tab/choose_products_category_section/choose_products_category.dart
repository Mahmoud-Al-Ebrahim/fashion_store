import 'package:flutter/material.dart';
import '../../../../../../models/dummy/store_fake.dart';
import 'choose_category_products_list_view.dart';

class ChooseProductsCategory extends StatefulWidget {
//   final AuthUserBloc authUserBloc;
// final StoreBloc storeBloc;
  final String storeId;

  const ChooseProductsCategory({super.key, required this.storeId});


  @override
  State<ChooseProductsCategory> createState() => _ChooseProductsCategoryState();
}

class _ChooseProductsCategoryState extends State<ChooseProductsCategory> {
  @override
  void initState() {
    // widget.authUserBloc.add(GetAllProductKindEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChooseCategoryProductsListView(
      categories: categories,
      storeId: widget.storeId,
      // storeBloc: widget.storeBloc,
    );
    // return BlocSelector<
    //     AuthUserBloc,
    //     AuthUserState,
    //     BlocStateData<GetAllProductKindModel>>(
    //   selector: (state) => state.getAllProductKindState,
    //   builder: (context, state) {
    //     return BlocStateDataBuilder(
    //       data: state,
    //       onFailed: CategoriesShimmer(),
    //       onLoading: CategoriesShimmer(),
    //       onSuccess: (state) {
    //         // أضفنا "الكل" بشكل يدوي
    //         final categories = [
    //           Category(name: "الكل", id: ""),
    //           ...state!.category!,
    //         ];
    //         return ChooseCategoryProductsListView(
    //         categories: categories,
    //         storeId: widget.storeId,
    //         storeBloc: widget.storeBloc,
    //         );
    //
    //
    //       },
    //     );
    //   },
    // );
  }
}

