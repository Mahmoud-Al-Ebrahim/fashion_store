import 'package:flutter/material.dart';
import '../../../../../../core/screen_util.dart';
import '../../../../../../models/store/store_products_model.dart';
import 'choose_category_products_card.dart';

class ChooseCategoryProductsListView extends StatelessWidget {
  final List<Category> categories;
  final String storeId;
  // final StoreBloc storeBloc;

  const ChooseCategoryProductsListView({
    super.key,
    required this.categories,
    required this.storeId,
    // required this.storeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(39),
      child:
      // BlocBuilder<CategorySelectionCubit, Category?>(
      //   builder: (context, selectedCategory) {
      //     return

            ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              // نقارن بالـ id لأن هي الأهم
              final isSelected = false ; //selectedCategory?.id == category.id;

              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    print("تم الضغط على الفئة: ${category.name} - ID: ${category.id}");

                    // غير الفئة بالـ Cubit
                    // context.read<CategorySelectionCubit>().selectCategory(category);

                    // استدعي Bloc ليجيب المنتجات بهالفئة
                    // storeBloc.add(
                    //   StoreProductsEvent(
                    //     storeId: storeId,
                    //     params: StoreProductsParams(
                    //       storeId: storeId,
                    //       categoryId: category.id, page: '1',
                    //     ),
                    //   ),
                    // );

                    print("تم إرسال StoreProductsEvent مع categoryId: ${category.id}");
                  },
                  child: ChooseCategoryProductsCard(
                    title: category.name ?? '',
                    isSelected: isSelected,
                  ),
                ),
              );
            },
          )
      //   },
      // ),
    );
  }
}