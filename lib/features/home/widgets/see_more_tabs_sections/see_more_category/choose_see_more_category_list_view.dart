import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../models/store/store_products_model.dart';
import 'choose_see_more_category_card.dart';

class ChooseSeeMoreCategoryListView extends StatelessWidget {
  final List<Category> categories;
  // final HomeAndProductBloc homeAndProductBloc;
  final bool isProducts;

  const ChooseSeeMoreCategoryListView({
    super.key,
    required this.categories,
    // required this.homeAndProductBloc,
    required this.isProducts,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(39),
      child:
      // BlocBuilder<SeeMoreControllerCubit, SeeMoreControllerState>(
      //   buildWhen:
      //       (p, c) =>
      //           p.currentTabIndex != c.currentTabIndex ||
      //           p.categoriesPerTab != c.categoriesPerTab,
      //   builder: (context, seeMoreState) {
      //     // ✅ التعديل: نستخدم selectedCategory من SeeMoreControllerCubit
      //     final selectedCategory = seeMoreState.selectedCategory;
      //
      //     return
            ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = false;//selectedCategory?.id == category.id;

              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    // ✅ تحديث الكاتيجوري للتاب الحالي فقط
                    // context.read<SeeMoreControllerCubit>().selectCategory(
                    //   category,
                    // );
                    //
                    // print(
                    //   "تم اختيار الفئة: ${category.name} - ID: ${category.id}",
                    // );
                    //
                    // if (isProducts) {
                    //   homeAndProductBloc.add(
                    //     SeeMoreProductsEvent(
                    //       params: SeeMoreProductsParams(
                    //         page: "1",
                    //         category: category.id,
                    //       ),
                    //     ),
                    //   );
                    // } else {
                    //   homeAndProductBloc.add(
                    //     SeeMoreStoresEvent(
                    //       params: SeeMoreStoreParams(
                    //         page: "1",
                    //         category: category.id,
                    //       ),
                    //     ),
                    //   );
                   // }
                  },
                  child: ChooseSeeMoreCategoryCard(
                    title: category.name ?? '',
                    isSelected: isSelected,
                  ),
                ),
              );
            },
          )
    );
  }
}
