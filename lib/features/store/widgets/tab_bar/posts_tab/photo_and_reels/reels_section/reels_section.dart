import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/screen_util.dart';
import '../photo_and_reels_card.dart';

class ReelsSection extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const ReelsSection({
    super.key,
    // required this.storeBloc,
    required this.storeId,
  });

  @override
  State<ReelsSection> createState() => _ReelsSectionState();
}

class _ReelsSectionState extends State<ReelsSection>
    with AutomaticKeepAliveClientMixin<ReelsSection> {
  // static const _pageSize = 8;
  // final PagingController<int, Video> _pagingController =
  // PagingController(firstPageKey: 1);
  //
  // bool _isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    // _pagingController.addPageRequestListener(_loadPage);
  }

  void _loadPage(int pageKey) {
    // if (_isLoadingPage) return;
    // _isLoadingPage = true;
    //
    // widget.storeBloc.add(
    //   StoreReelsEvent(
    //     storeId: widget.storeId,
    //     page: pageKey.toString(),
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: width(10),
        mainAxisSpacing: height(10),
        childAspectRatio: 140 / 220,
      ),
      itemCount: fakeReels.videos!.length,
      itemBuilder: (context, index) {
        final item = fakeReels.videos![index];
        return PhotoAndReelsCard(
          imageUrl: item.thumbnailUrl ?? "",
          videoUrl: item.videoUrl,
        );
      },
    );
    // return BlocProvider.value(
    //   value: widget.storeBloc,
    //   child: BlocListener<StoreBloc, StoreState>(
    //     listener: (context, state) {
    //       final reelsState = state.storeReelsState;
    //       _isLoadingPage = false;
    //
    //       if (reelsState.isSuccess) {
    //         final newItems = reelsState.data?.videos ?? [];
    //         final isLastPage = newItems.length < _pageSize;
    //
    //         // ✅ منع التكرار حسب الـvideoUrl
    //         final existingUrls =
    //             _pagingController.itemList?.map((e) => e.videoUrl).toSet() ?? {};
    //         final uniqueNewItems = newItems
    //             .where((video) => !existingUrls.contains(video.videoUrl))
    //             .toList();
    //
    //         if (isLastPage) {
    //           _pagingController.appendLastPage(uniqueNewItems);
    //         } else {
    //           final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
    //           _pagingController.appendPage(uniqueNewItems, nextPageKey);
    //         }
    //       } else if (reelsState.isFailed) {
    //         _pagingController.error =
    //             reelsState.message ?? "حدث خطأ أثناء تحميل المقاطع";
    //       }
    //     },
    //     child: RefreshIndicator(
    //       onRefresh: () async {
    //         _resetPagination();
    //       },
    //       child: PagedGridView<int, Video>(
    //         pagingController: _pagingController,
    //         padding: EdgeInsets.all(width(10)),
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 3,
    //           crossAxisSpacing: width(10),
    //           mainAxisSpacing: height(10),
    //           childAspectRatio: 140 / 220,
    //         ),
    //         builderDelegate: PagedChildBuilderDelegate<Video>(
    //           firstPageProgressIndicatorBuilder: (_) =>
    //           const PhotoReelShimmer(),
    //           newPageProgressIndicatorBuilder: (_) =>
    //           const CircularProgressIndicator(),
    //           firstPageErrorIndicatorBuilder: (_) => Center(
    //             child: NoData(heightt: 400,
    //                 text: (AuthServiceLocator.instance.storeId != null ?
    //                 "يرجى الانتظار للتفعيل نت قبل المسؤولين" : "حدث خطأ ما!")),
    //           ),
    //           noItemsFoundIndicatorBuilder: (_) =>
    //           const NoData(heightt: 550, text: "لا توجد مقاطع بعد"),
    //           itemBuilder: (context, item, index) {
    //             return PhotoAndReelsCard(
    //               imageUrl: item.thumbnailUrl ?? "",
    //               videoUrl: item.videoUrl,
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
