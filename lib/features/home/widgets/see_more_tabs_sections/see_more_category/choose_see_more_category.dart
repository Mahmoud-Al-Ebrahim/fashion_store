import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_see_more_category_list_view.dart';

class ChooseSeeMoreCategory extends StatefulWidget {
  // final AuthUserBloc authUserBloc;
  // final HomeAndProductBloc homeAndProductBloc;
  final bool isProduct;

  const ChooseSeeMoreCategory({
    super.key,
    // required this.authUserBloc,
    // required this.homeAndProductBloc,
    required this.isProduct,
  });

  @override
  State<ChooseSeeMoreCategory> createState() => _ChooseSeeMoreCategoryState();
}

class _ChooseSeeMoreCategoryState extends State<ChooseSeeMoreCategory> {
  @override
  void initState() {
    // widget.authUserBloc.add(GetAllProductKindEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChooseSeeMoreCategoryListView(
      categories: categories,
      // homeAndProductBloc: widget.homeAndProductBloc,
      isProducts: widget.isProduct,
    );
    // return BlocSelector<
    //   AuthUserBloc,
    //   AuthUserState,
    //   BlocStateData<GetAllProductKindModel>
    // >(
    //   selector: (state) => state.getAllProductKindState,
    //   builder: (context, state) {
    //     return BlocStateDataBuilder(
    //       data: state,
    //       onFailed: CategoriesShimmer(),
    //       onLoading: CategoriesShimmer(),
    //       onSuccess: (state) {
    //         // أضفنا "الكل" بشكل يدوي
    //         final categories = [
    //           allCategoryObject,
    //           ...state!.category!,
    //         ];
    //         return ChooseSeeMoreCategoryListView(
    //           categories: categories,
    //           homeAndProductBloc: widget.homeAndProductBloc,
    //           isProducts: widget.isProduct,
    //         );
    //       },
    //     );
    //   },
    // );
  }
}
