import 'package:fashion_store/features/common/store_fav_card.dart';
import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:fashion_store/models/dummy/stories_posts_fake_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreSeeMoreList extends StatefulWidget {
  // final HomeAndProductBloc homeAndProductBloc;

  const StoreSeeMoreList({super.key});

  @override
  State<StoreSeeMoreList> createState() => _StoreSeeMoreListState();
}

class _StoreSeeMoreListState extends State<StoreSeeMoreList> {
  static const _pageSize = 8;

  // ✅ PagingController للمتاجر
  // final PagingController<int, Store> _pagingController =
  // PagingController(firstPageKey: 1);

  // ✅ متغيرات لتتبع آخر فلتر
  String? _lastCategory;
  String? _lastSearch;
  bool _isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    // ✅ الاستماع لطلبات الصفحات الجديدة
    // _pagingController.addPageRequestListener((pageKey) {
    //   _loadItems(pageKey);
    // });
  }

  // ✅ تحميل المتاجر مع الفلاتر
  void _loadItems(int pageKey) {
    // if (_isLoadingPage) return; // منع الطلبات المتكررة
    //
    // final cubit = context.read<SeeMoreControllerCubit>();
    // final categoryId = cubit.state.selectedCategory?.id ?? '';
    // final searchQuery = cubit.state.searchQuery;
    //
    // _isLoadingPage = true;
    //
    // widget.homeAndProductBloc.add(
    //   SeeMoreStoresEvent(
    //     params: SeeMoreStoreParams(
    //       page: pageKey.toString(),
    //       category: categoryId,
    //       search: searchQuery,
    //     ),
    //   ),
    // );
  }

  // ✅ إعادة تعيين Pagination
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
    return SliverList.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: StoreFavCard(store: storesInfo[index]),
        );
      },
    );
    // ✅ الاستماع لتغييرات الفئة والبحث
    // return BlocListener<SeeMoreControllerCubit, SeeMoreControllerState>(
    //   listener: (context, cubitState) {
    //     final currentCategory = cubitState.selectedCategory?.id ?? '';
    //     final currentSearch = cubitState.searchQuery;
    //
    //     // ✅ لو الفئة أو البحث اتغير، نعيد التحميل
    //     if (_lastCategory != currentCategory || _lastSearch != currentSearch) {
    //       _lastCategory = currentCategory;
    //       _lastSearch = currentSearch;
    //       _resetPagination();
    //     }
    //   },
    //   child: BlocListener<HomeAndProductBloc, HomeAndProductState>(
    //     listener: (context, state) {
    //       final storeState = state.seeMoreStoreState;
    //
    //       _isLoadingPage = false; // التحميل خلص
    //
    //       if (storeState.isSuccess) {
    //         final newData = storeState.data?.items ?? [];
    //         final isLastPage = newData.length < _pageSize;
    //
    //         // ✅ منع التكرار
    //         final existingIds =
    //             _pagingController.itemList?.map((e) => e.id).toSet() ?? {};
    //         final uniqueNewData = newData
    //             .where((r) => !existingIds.contains(r.id))
    //             .toList();
    //
    //         if (isLastPage) {
    //           _pagingController.appendLastPage(uniqueNewData);
    //         } else {
    //           final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
    //           _pagingController.appendPage(uniqueNewData, nextPageKey);
    //         }
    //       } else if (storeState.isFailed) {
    //         _pagingController.error =
    //             storeState.message ?? "حدث خطأ أثناء التحميل";
    //       }
    //     },
    //     child: PagedSliverList<int, Store>(
    //       pagingController: _pagingController,
    //       builderDelegate: PagedChildBuilderDelegate<Store>(
    //         // ✅ عند التحميل الأول
    //         firstPageProgressIndicatorBuilder: (context) =>
    //             const CountryFavShimmer(),
    //
    //         // ✅ عند تحميل صفحة جديدة
    //         newPageProgressIndicatorBuilder: (context) => const Padding(
    //           padding: EdgeInsets.all(20.0),
    //           child: Center(child: CircularProgressIndicator()),
    //         ),
    //
    //         // ✅ عند حدوث خطأ
    //         firstPageErrorIndicatorBuilder: (context) => Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               const Icon(Icons.error_outline, size: 50, color: Colors.red),
    //               const SizedBox(height: 10),
    //               const Text('حدث خطأ في التحميل'),
    //               const SizedBox(height: 10),
    //               ElevatedButton(
    //                 onPressed: () => _pagingController.refresh(),
    //                 child: const Text('إعادة المحاولة'),
    //               ),
    //             ],
    //           ),
    //         ),
    //
    //         // ✅ عند عدم وجود بيانات
    //         noItemsFoundIndicatorBuilder: (context) => const Center(
    //           child: Padding(
    //             padding: EdgeInsets.all(20.0),
    //             child: Text("لا توجد متاجر", style: TextStyle(fontSize: 16)),
    //           ),
    //         ),
    //
    //         itemBuilder: (context, store, index) {
    //           return Padding(
    //             padding: const EdgeInsets.only(bottom: 15),
    //             child: StoreFavCard(store: store),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
