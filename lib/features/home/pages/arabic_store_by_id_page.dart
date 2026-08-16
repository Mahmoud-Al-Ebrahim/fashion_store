import 'package:fashion_store/features/common/store_fav_card.dart';
import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';
import '../../store/widgets/store_app_bar.dart';

class ArabicStoreByIdPage extends StatefulWidget {
  final Store store;
  static String name = "ArabicStoreByIdPage";
  static String route = "/ArabicStoreByIdPage";

  const ArabicStoreByIdPage({super.key, required this.store});

  @override
  State<ArabicStoreByIdPage> createState() => _ArabicStoreByIdPageState();
}

class _ArabicStoreByIdPageState extends State<ArabicStoreByIdPage>
    with AutomaticKeepAliveClientMixin {
  // late HomeAndProductBloc homeAndProductBloc;
  //
  // static const _pageSize = 8;
  // final PagingController<int, Store> _pagingController = PagingController(
  //   firstPageKey: 1,
  // );
  //
  // bool _isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    // homeAndProductBloc = getIt<HomeAndProductBloc>();
    // _pagingController.addPageRequestListener(_loadPage);
  }

  void _loadPage(int pageKey) {
    // if (_isLoadingPage) return;
    // _isLoadingPage = true;
    //
    // homeAndProductBloc.add(
    //   ArabicStoreByIdEvent(
    //     params: ArabicStoreByIdParams(
    //       countryId: widget.store.id ?? "",
    //       page: pageKey.toString(),
    //       perPage: _pageSize.toString(),
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
    super.build(context);

    return Scaffold(
      appBar: StoreAppBar(title: "المتجر ${widget.store.name}"),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // UpperSection(store: widget.store),
            Expanded(
              child: ListView.builder(itemBuilder: (context , index){
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: StoreFavCard(store: widget.store),
                );
              })

              // BlocListener<HomeAndProductBloc, HomeAndProductState>(
              //   listener: (context, state) {
              //     final storeState = state.arabicStoreByIdState;
              //     _isLoadingPage = false;
              //
              //     if (storeState.isSuccess) {
              //       final newItems = storeState.data?.items ?? [];
              //       final isLastPage = newItems.length < _pageSize;
              //
              //       final existingIds =
              //           _pagingController.itemList
              //               ?.map((e) => e.id)
              //               .toSet() ??
              //           {};
              //       final uniqueNewItems =
              //           newItems
              //               .where((res) => !existingIds.contains(res.id))
              //               .toList();
              //
              //       if (isLastPage) {
              //         _pagingController.appendLastPage(uniqueNewItems);
              //       } else {
              //         final nextPageKey =
              //             (_pagingController.nextPageKey ?? 1) + 1;
              //         _pagingController.appendPage(
              //           uniqueNewItems,
              //           nextPageKey,
              //         );
              //       }
              //     } else if (storeState.isFailed) {
              //       _pagingController.error =
              //           storeState.message ?? "حدث خطأ أثناء التحميل";
              //     }
              //   },
              //   child: RefreshIndicator(
              //     onRefresh: () async {
              //       _resetPagination();
              //     },
              //     child: PagedListView<int, Store>(
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       pagingController: _pagingController,
              //       builderDelegate: PagedChildBuilderDelegate<Store>(
              //         firstPageProgressIndicatorBuilder:
              //             (_) => CountryFavShimmer(),
              //         newPageProgressIndicatorBuilder:
              //             (_) => CircularProgressIndicator(),
              //         firstPageErrorIndicatorBuilder:
              //             (_) => NoData(
              //               isInternet: true,
              //               heightt: height(500),
              //               text:
              //                   "يبدو انك فقدت الاتصال بالانترنت يرجى المحاولة لاحقا",
              //             ),
              //         noItemsFoundIndicatorBuilder:
              //             (_) => const NoData(
              //               heightt: 660,
              //               text: "لا يوجد متاجر بعد",
              //             ),
              //         itemBuilder:
              //             (context, item, index) => Padding(
              //               padding: const EdgeInsets.only(bottom: 10),
              //               child: StoreFavCard(store: item),
              //             ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
