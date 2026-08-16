// ---------------- WhoAmITab ----------------
import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/screen_util.dart';
import '../../store_top_side/image_top_side.dart';
import 'column_layer_for_store_dashboard/column_layer_for_store_dashboard.dart';

class WhoAmITabForStoreDashboard extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const WhoAmITabForStoreDashboard({
    super.key,
    // required this.storeBloc,
    required this.storeId,
  });

  @override
  State<WhoAmITabForStoreDashboard> createState() =>
      _WhoAmITabForStoreDashboardState();
}

class _WhoAmITabForStoreDashboardState
    extends State<WhoAmITabForStoreDashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // widget.storeBloc.add(StoreWhoAmIEvent(storeId: widget.storeId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return BlocSelector<
    //   StoreBloc,
    //   StoreState,
    //   BlocStateData<StoreWhoAmIModel>
    // >(
    //   selector: (state) => state.storeWhoAmIState,
    //   builder: (context, state) {
    //     return BlocStateDataBuilder(
    //       data: state,
    //       onFailed: Center(
    //         child: NoData(heightt: 400, text: state.message ?? "حدث خطأ ما!"),
    //       ),
    //       onLoading: WhoAmIShimmer(),
    //       onSuccess: (state) {
    //         return RefreshIndicator(
    //           onRefresh: () async {
    //             widget.storeBloc.add(
    //               StoreWhoAmIEvent(storeId: widget.storeId),
    //             );
    //           },
    //           child:
              return Stack(
                children: [
                  ColumnLayerForStoreDashboard(storeWhoAmIModel: fakeStoreInfo),
                  Positioned(
                    top: height(20),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ImageTopSide(
                        heightWidth: 82,
                        imageUrl: fakeStoreInfo.logoUrl ?? "",
                      ),
                    ),
                  ),
                ],
              );
  }
}
