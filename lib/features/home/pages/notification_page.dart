import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../store/widgets/store_app_bar.dart';
import '../widgets/notification/notification_card.dart';

class NotificationPage extends StatefulWidget {
  static String name = "NotificationPage";
  static String route = "/NotificationPage";

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin<NotificationPage> {
  static const _pageSize = 10;
  // final PagingController<int, Notifi> _pagingController = PagingController(
  //   firstPageKey: 1,
  // );
  //
  // late HomeAndProductBloc homeAndProductBloc;
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
    //   NotificationEvent(
    //     params: NotificationParams(
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
    // homeAndProductBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: StoreAppBar(title: "الإشعارات"),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return NotificationCard();
        },
      ),

      // BlocListener<HomeAndProductBloc, HomeAndProductState>(
      //   listener: (context, state) {
      //     final notifState = state.notificationState;
      //     _isLoadingPage = false;
      //
      //     if (notifState.isSuccess) {
      //       final newItems = notifState.data?.items ?? [];
      //       final isLastPage = newItems.length < _pageSize;
      //
      //       // ✅ منع التكرار
      //       final existingIds =
      //           _pagingController.itemList?.map((e) => e.id).toSet() ?? {};
      //       final uniqueNewItems = newItems
      //           .where((notif) => !existingIds.contains(notif.id))
      //           .toList();
      //
      //       if (isLastPage) {
      //         _pagingController.appendLastPage(uniqueNewItems);
      //       } else {
      //         final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
      //         _pagingController.appendPage(uniqueNewItems, nextPageKey);
      //       }
      //     } else if (notifState.isFailed) {
      //       _pagingController.error =
      //           notifState.message ?? "حدث خطأ أثناء تحميل الإشعارات";
      //     }
      //   },
      //   child: RefreshIndicator(
      //     onRefresh: () async => _resetPagination(),
      //     child: PagedListView<int, Notifi>(
      //       pagingController: _pagingController,
      //       padding: const EdgeInsets.all(12),
      //
      //       builderDelegate: PagedChildBuilderDelegate<Notifi>(
      //
      //         firstPageProgressIndicatorBuilder: (_) =>
      //          Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)),
      //         newPageProgressIndicatorBuilder: (_) =>
      //             Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)),
      //         firstPageErrorIndicatorBuilder: (_) => NoData(
      //           heightt: height(650),
      //           text: "يبدو انك فقدت الاتصال بالانترنت يرجى المحاولة لاحقا",
      //           isInternet: true,
      //         ),
      //         noItemsFoundIndicatorBuilder: (_) => const NoData(
      //           heightt: 500,
      //           text: "لا توجد إشعارات حالياً",
      //         ),
      //         itemBuilder: (context, item, index) {
      //           return NotificationCard(notifi: item,);
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
