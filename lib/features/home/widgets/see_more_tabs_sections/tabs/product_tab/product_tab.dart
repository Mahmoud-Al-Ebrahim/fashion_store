import 'package:fashion_store/features/home/widgets/see_more_tabs_sections/tabs/product_tab/see_more_product_grid_view.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/screen_util.dart';
import '../../see_more_category/choose_see_more_category.dart';

class ProductsTab extends StatefulWidget {
  // final AuthUserBloc authUserBloc;
  // final HomeAndProductBloc homeAndProductBloc;

  const ProductsTab({
    super.key,
    // required this.authUserBloc,
    // required this.homeAndProductBloc,
  });

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    //   // ✅ تحميل البيانات مع الكاتيجوري الافتراضي "الكل"
    //   widget.homeAndProductBloc.add(
    //     SeeMoreProductsEvent(
    //       params: SeeMoreProductsParams(
    //         page: '1',
    //         category: '', // "الكل" = empty string
    //       ),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ChooseSeeMoreCategory(
                  // authUserBloc: widget.authUserBloc,
                  // homeAndProductBloc: widget.homeAndProductBloc,
                  isProduct: true,
                ),
                SizedBox(height: height(20)),
              ],
            ),
          ),
          SeeMoreProductGridView(),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}