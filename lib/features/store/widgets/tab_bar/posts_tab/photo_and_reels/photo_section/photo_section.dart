import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/screen_util.dart';
import '../photo_and_reels_card.dart';

class PhotosSection extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const PhotosSection({
    super.key,
    // required this.storeBloc,
    required this.storeId,
  });

  @override
  State<PhotosSection> createState() => _PhotosSectionState();
}

class _PhotosSectionState extends State<PhotosSection>
    with AutomaticKeepAliveClientMixin<PhotosSection> {
  static const _pageSize = 8;

  // final PagingController<int, Photo> _pagingController =
  // PagingController(firstPageKey: 1);

  bool _isLoadingPage = false;

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
    //   StorePhotosEvent(
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
      itemCount: fakeStorePhotos.images!.length,
      itemBuilder: (context, index) {
        return PhotoAndReelsCard(
          imageUrl: fakeStorePhotos.images![index].url ?? "",
        );
      },
    );
    // return BlocProvider.value(
    //   value: widget.storeBloc,
    //   child: BlocListener<StoreBloc, StoreState>(
    //     listener: (context, state) {
    //       final photoState = state.storePhotosState;
    //       _isLoadingPage = false;
    //
    //       if (photoState.isSuccess) {
    //         final newItems = photoState.data?.images ?? [];
    //         final isLastPage = newItems.length < _pageSize;
    //
    //         // ✅ منع التكرار
    //         final existingUrls =
    //             _pagingController.itemList?.map((e) => e.url).toSet() ?? {};
    //         final uniqueNewItems = newItems
    //             .where((img) => !existingUrls.contains(img.url))
    //             .toList();
    //
    //         if (isLastPage) {
    //           _pagingController.appendLastPage(uniqueNewItems);
    //         } else {
    //           final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
    //           _pagingController.appendPage(uniqueNewItems, nextPageKey);
    //         }
    //       } else if (photoState.isFailed) {
    //         _pagingController.error =
    //             photoState.message ?? "حدث خطأ أثناء تحميل الصور";
    //       }
    //     },
    //     child: RefreshIndicator(
    //       onRefresh: () async {
    //         _resetPagination();
    //       },
    //       child: PagedGridView<int, Photo>(
    //         pagingController: _pagingController,
    //         padding: EdgeInsets.all(width(10)),
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 3,
    //           crossAxisSpacing: width(10),
    //           mainAxisSpacing: height(10),
    //           childAspectRatio: 140 / 220,
    //         ),
    //         builderDelegate: PagedChildBuilderDelegate<Photo>(
    //           firstPageProgressIndicatorBuilder: (
    //               _) => const PhotoReelShimmer(),
    //           newPageProgressIndicatorBuilder: (
    //               _) => const CircularProgressIndicator(),
    //           firstPageErrorIndicatorBuilder: (_) =>
    //               Center(
    //                 child: NoData(heightt: 400,
    //                     text: (AuthServiceLocator.instance.storeId != null
    //                         ?
    //                     "يرجى الانتظار للتفعيل نت قبل المسؤولين"
    //                         : "حدث خطأ ما!")),
    //               ),
    //           noItemsFoundIndicatorBuilder: (_) =>
    //           const NoData(heightt: 550, text: "لا توجد صور"),
    //           itemBuilder: (context, item, index) {
    //             return PhotoAndReelsCard(imageUrl: item.url ?? "");
    //           },
    //         ),
    //       ),
    //     ),)
    //   ,
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
