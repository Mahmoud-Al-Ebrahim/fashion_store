// ---------------- ReviewTab ----------------
import 'package:fashion_store/features/store/widgets/tab_bar/reviews_tab/review_list_view.dart';
import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/widgets/nodata.dart';
import '../../../../shimmer/store_shimmer/review_shimmer.dart';
import 'add_review.dart';

class ReviewTab extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const ReviewTab({
    super.key,
    // required this.storeBloc,
    required this.storeId,
  });

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab>
    with AutomaticKeepAliveClientMixin<ReviewTab> {
  static const _pageSize = 8;
  // final PagingController<int, Review> _pagingController =
  // PagingController(firstPageKey: 1);

  bool _isLoadingPage = false;

  @override
  bool get wantKeepAlive => true;

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
    //   StoreReviewsEvent(
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
    return Stack(
      children: [
        // BlocProvider.value(
        //   value: widget.storeBloc,
        //   child: BlocListener<StoreBloc, StoreState>(
        //     listener: (context, state) {
        //       final reviewState = state.storeReviewState;
        //       _isLoadingPage = false;
        //
        //       if (reviewState.isSuccess) {
        //         final newItems = reviewState.data?.reviews ?? [];
        //         final isLastPage = newItems.length < _pageSize;
        //
        //         // ✅ منع التكرار حسب الـid
        //         final existingIds =
        //             _pagingController.itemList?.map((e) => e.id).toSet() ?? {};
        //         final uniqueNewItems = newItems
        //             .where((review) => !existingIds.contains(review.id))
        //             .toList();
        //
        //         if (isLastPage) {
        //           _pagingController.appendLastPage(uniqueNewItems);
        //         } else {
        //           final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
        //           _pagingController.appendPage(uniqueNewItems, nextPageKey);
        //         }
        //       } else if (reviewState.isFailed) {
        //         _pagingController.error =
        //             reviewState.message ?? "حدث خطأ أثناء تحميل التقييمات";
        //       }
        //     },
        //     child:
        RefreshIndicator(
              onRefresh: () async {
                _resetPagination();
              },
              child: ReviewListView(reviews: fakeReviews.reviews ?? []),

              // PagedListView<int, Review>(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: width(20),
              //     vertical: height(20),
              //   ),
              //   pagingController: _pagingController,
              //   builderDelegate: PagedChildBuilderDelegate<Review>(
              //     firstPageProgressIndicatorBuilder: (_) =>
              //     const ReviewShimmer(),
              //     newPageProgressIndicatorBuilder: (_) =>
              //     const CircularProgressIndicator(),
              //     firstPageErrorIndicatorBuilder: (_) =>
              //     const ReviewShimmer(),
              //     noItemsFoundIndicatorBuilder: (_) => const NoData(
              //       heightt: 550,
              //       text: "لا توجد تقييمات بعد",
              //     ),
              //     itemBuilder: (context, item, index) {
              //       return ;
              //     },
              //   ),
              // ),
            ),

        // ✅ زر إضافة تقييم
        Positioned(
          bottom: 30,
          left: 20,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: () async {
              // if (AuthServiceLocator.instance.token == null ||
              //     AuthServiceLocator.instance.token!.isEmpty) {
              //   showFlushBar(context,
              //       "يرجى إنشاء حساب أو تسجيل الدخول لتتمكن من التقييم");
              //   return;
              // }

              await showDialog(
                context: context,
                builder: (_) => AddReview(
                  storeId: widget.storeId,
                  // storeBloc: widget.storeBloc,
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
