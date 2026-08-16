import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';

import '../../../product_card/product-card.dart';

class SeeMoreProductGridView extends StatefulWidget {
  const SeeMoreProductGridView({super.key});

  @override
  State<SeeMoreProductGridView> createState() => _SeeMoreProductGridViewState();
}

class _SeeMoreProductGridViewState extends State<SeeMoreProductGridView> {
  static const _pageSize = 8;

  // final PagingController<int, Product> _pagingController = PagingController(
  //   firstPageKey: 1,
  // );

  String? _lastCategory;
  String? _lastSearch;
  bool _isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    // _pagingController.addPageRequestListener((pageKey) {
    //   _loadItems(pageKey);
    // });
  }

  void _loadItems(int pageKey) {
    // if (_isLoadingPage) return; // ✅ إضافة
    //
    // final cubit = context.read<SeeMoreControllerCubit>();
    // final categoryId = cubit.state.selectedCategory?.id ?? '';
    // final searchQuery = cubit.state.searchQuery;
    //
    // _isLoadingPage = true;
    //
    // context.read<HomeAndProductBloc>().add(
    //   SeeMoreProductsEvent(
    //     params: SeeMoreProductsParams(
    //       page: pageKey.toString(),
    //       category: categoryId,
    //       search: searchQuery,
    //     ),
    //   ),
    // );
  }

  void _resetPagination() {
    // _pagingController.itemList = [];
    // _pagingController.nextPageKey = 1;
    // _pagingController.refresh();
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.78,
        ),
        itemCount: fakeProducts.products!.length,
        itemBuilder: (context, index)
    {
      return ProductCard(
        isWithDetail: true,
        product: fakeProducts.products![index],
        isShowProductDetail: true,
      );
    });

    // return BlocListener<SeeMoreControllerCubit, SeeMoreControllerState>(
    // listener: (context, cubitState) {
    // final currentCategory = cubitState.selectedCategory?.id ?? '';
    // final currentSearch = cubitState.searchQuery;
    //
    // if (_lastCategory != currentCategory || _lastSearch != currentSearch) {
    // _lastCategory = currentCategory;
    // _lastSearch = currentSearch;
    // _resetPagination();
    // }
    // },
    // child: BlocListener<HomeAndProductBloc, HomeAndProductState>(
    // listener: (context, state) {
    // final productsState = state.seeMoreProductsState;
    //
    // _isLoadingPage = false; // ✅ إضافة
    //
    // if (productsState.isSuccess) {
    // final newData = productsState.data?.items ?? [];
    // final isLastPage = newData.length < _pageSize;
    //
    // // ✅ إضافة: منع التكرار
    // final existingIds =
    // _pagingController.itemList?.map((e) => e.id).toSet() ?? {};
    // final uniqueNewData =
    // newData
    //     .where((product) => !existingIds.contains(product.id))
    //     .toList();
    //
    // if (isLastPage) {
    // _pagingController.appendLastPage(
    // uniqueNewData,
    // ); // ✅ تعديل: استخدام uniqueNewData
    // } else {
    // final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
    // _pagingController.appendPage(
    // uniqueNewData,
    // nextPageKey,
    // ); // ✅ تعديل: استخدام uniqueNewData
    // }
    // } else if (productsState.isFailed) {
    // _pagingController.error =
    // productsState.message ?? "حدث خطأ أثناء التحميل";
    // }
    // },
    // child: BlocProvider(
    // create: (context) => getIt<StoreBloc>(),
    // child: PagedSliverGrid<int, Product>(
    // pagingController: _pagingController,
    // builderDelegate: PagedChildBuilderDelegate<Product>(
    // firstPageProgressIndicatorBuilder:
    // (context) => const ProductsShimmer(),
    // newPageProgressIndicatorBuilder:
    // (context) => const CircularProgressIndicator(),
    // firstPageErrorIndicatorBuilder:
    // (context) => Center(
    // child: Column(
    // mainAxisAlignment: MainAxisAlignment.center,
    // children: [
    // Text('حدث خطأ في التحميل'),
    // ElevatedButton(
    // onPressed: () => _pagingController.refresh(),
    // child: Text('إعادة المحاولة'),
    // ),
    // ],
    // ),
    // ),
    // itemBuilder: (context, product, index) {
    // return ProductCard(
    // isWithDetail: true,
    // product: product,
    // isShowProductDetail: true,
    // );
    // },
    // noItemsFoundIndicatorBuilder:
    // (context) => const SizedBox(
    // height: 200,
    // child: Center(child: Text("لا توجد منتجات")),
    // ),
    // ),
    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    // crossAxisCount: 2,
    // mainAxisSpacing: 15,
    // crossAxisSpacing: 15,
    // childAspectRatio: 0.78,
    // ),
    // ),
    // ),
    // ),
    // );
  }
}
