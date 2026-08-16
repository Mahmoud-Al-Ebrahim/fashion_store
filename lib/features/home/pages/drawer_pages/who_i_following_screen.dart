import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/dummy/store_fake.dart';
import '../../../store/pages/store_screen.dart';
import '../../../store/widgets/store_app_bar.dart';
import '../../../store/widgets/store_top_side/image_top_side.dart';
import '../../../store/widgets/store_top_side/reviews_stars.dart';

class WhoIFollowingScreen extends StatefulWidget {
  static String name = "WhoIFollowingScreen";
  static String route = "/WhoIFollowingScreen";

  const WhoIFollowingScreen({super.key});

  @override
  State<WhoIFollowingScreen> createState() => _WhoIFollowingScreenState();
}

class _WhoIFollowingScreenState extends State<WhoIFollowingScreen>
    with AutomaticKeepAliveClientMixin<WhoIFollowingScreen> {
  // late AuthUserBloc authUserBloc;
  // late StoreBloc storeBloc;

  static const _pageSize = 8;

  // final PagingController<int, Follow> _pagingController =
  // PagingController(firstPageKey: 1);

  bool _isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    // authUserBloc = getIt<AuthUserBloc>();
    // storeBloc = getIt<StoreBloc>();
    // _pagingController.addPageRequestListener(_loadPage);
  }

  void _loadPage(int pageKey) {
    // if (_isLoadingPage) return;
    // _isLoadingPage = true;
    // authUserBloc.add(FollowingEvent(page: pageKey.toString()));
  }

  void _resetPagination() {
    // _pagingController.itemList = [];
    // _pagingController.nextPageKey = 1;
    // _pagingController.refresh();
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    // authUserBloc.close();
    // storeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: StoreAppBar(
        title: "من أتابع",
        onTap: () {
          context.pop();
        },
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final follow = stores[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(13),
              vertical: height(7),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushPage(StoreScreen(storeId: ''));
                        },
                        child: Row(
                          children: [
                            ImageTopSide(
                              heightWidth: 55,
                              imageUrl: follow.logoUrl ?? "",
                            ),
                            SizedBox(width: width(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  follow.name ?? "____",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium,
                                ),
                                SizedBox(height: height(6)),
                                // follow.averageRating
                                ReviewsStars(rating: 4.6),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // BlocSelector<
                    //   StoreBloc,
                    //   StoreState,
                    //   BlocStateData<FollowStoreModel>?
                    // >(
                    //   selector: (state) => state.followStoreStates[follow.id],
                    //   builder: (context, followState) {
                    //     final isCurrentlyFollowing =
                    //         followState?.data?.isFollowing ?? true;
                    //     final isLoading = followState?.isLoading ?? false;
                    GestureDetector(
                      onTap:
                          false // isLoading
                          ? null
                          : () {
                              // storeBloc.add(
                              //   FollowStoreEvent(
                              //     storeId: follow.id!,
                              //     currentFollowStatus: isCurrentlyFollowing,
                              //     onSuccess: () {},
                              //   ),
                              // );
                            },
                      child: FollowButton(isFollowing: false),
                    ),
                    //   },
                    // ),
                  ],
                ),
                SizedBox(height: height(10)),
                Divider(
                  height: 1.2,
                  thickness: 1.1,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.5),
                ),
              ],
            ),
          );
        },
      ),

      // BlocListener<AuthUserBloc, AuthUserState>(
      //   listener: (context, state) {
      //     final followState = state.followingState;
      //     _isLoadingPage = false;
      //
      //     if (followState.isSuccess) {
      //       final newItems = followState.data?.follows ?? [];
      //       final isLastPage = newItems.length < _pageSize;
      //
      //       final existingIds =
      //           _pagingController.itemList?.map((e) => e.id).toSet() ?? {};
      //       final uniqueNewItems =
      //       newItems.where((f) => !existingIds.contains(f.id)).toList();
      //
      //       if (isLastPage) {
      //         _pagingController.appendLastPage(uniqueNewItems);
      //       } else {
      //         final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
      //         _pagingController.appendPage(uniqueNewItems, nextPageKey);
      //       }
      //     } else if (followState.isFailed) {
      //       _pagingController.error =
      //           followState.message ?? "حدث خطأ أثناء التحميل";
      //     }
      //   },
      //   child: RefreshIndicator(
      //     onRefresh: () async {
      //       _resetPagination();
      //     },
      //     child: PagedListView<int, Follow>(
      //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      //       pagingController: _pagingController,
      //       builderDelegate: PagedChildBuilderDelegate<Follow>(
      //         firstPageProgressIndicatorBuilder: (_) => Center(child: CircularProgressIndicator()),
      //         newPageProgressIndicatorBuilder: (_) => Center(child: CircularProgressIndicator()),
      //         firstPageErrorIndicatorBuilder: (_) => NoData(
      //           heightt: height(550),
      //           text: "يبدو انك فقدت الاتصال بالانترنت يرجى المحاولة لاحقا",
      //           isInternet: true,
      //         ),
      //         newPageErrorIndicatorBuilder: (context) => Center(
      //           child: TextButton.icon(
      //             onPressed: () => _pagingController.retryLastFailedRequest(),
      //             icon: const Icon(Icons.refresh),
      //             label: const Text('إعادة المحاولة'),
      //           ),
      //         ),
      //         noItemsFoundIndicatorBuilder: (_) => const NoData(
      //           heightt: 650,
      //           text: 'لم تقم بمتابعة أحد',
      //         ),
      //         itemBuilder: (context, follow, index) {
      //           return Padding(
      //             padding: EdgeInsets.symmetric(
      //               horizontal: width(13),
      //               vertical: height(7),
      //             ),
      //             child: Column(
      //               children: [
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: GestureDetector(
      //                         onTap: () {
      //                           context.pushNamed(
      //                             StoreScreen.name,
      //                             queryParameters: {
      //                               "storeId": follow.id.toString(),
      //                             },
      //                           );
      //                         },
      //                         child: Row(
      //                           children: [
      //                             ImageTopSide(
      //                               heightWidth: 55,
      //                               imageUrl: follow.logoUrl ?? "",
      //                             ),
      //                             SizedBox(width: width(10)),
      //                             Column(
      //                               crossAxisAlignment:
      //                               CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   follow.name ?? "____",
      //                                   style: Theme.of(context)
      //                                       .textTheme
      //                                       .bodyMedium,
      //                                 ),
      //                                 SizedBox(height: height(6)),
      //                                 ReviewsStars(
      //                                   rating: follow.averageRating,
      //                                 ),
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                     BlocSelector<StoreBloc, StoreState,
      //                         BlocStateData<FollowStoreModel>?>(
      //                       selector: (state) =>
      //                       state.followStoreStates[follow.id],
      //                       builder: (context, followState) {
      //                         final isCurrentlyFollowing =
      //                             followState?.data?.isFollowing ?? true;
      //                         final isLoading =
      //                             followState?.isLoading ?? false;
      //
      //                         return GestureDetector(
      //                           onTap: isLoading
      //                               ? null
      //                               : () {
      //                             storeBloc.add(
      //                               FollowStoreEvent(
      //                                 storeId: follow.id!,
      //                                 currentFollowStatus:
      //                                 isCurrentlyFollowing,
      //                                 onSuccess: () {},
      //                               ),
      //                             );
      //                           },
      //                           child: FollowButton(
      //                             isFollowing: isCurrentlyFollowing,
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: height(10)),
      //                 Divider(
      //                   height: 1.2,
      //                   thickness: 1.1,
      //                   color: Theme.of(context)
      //                       .colorScheme
      //                       .primary
      //                       .withOpacity(0.5),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
