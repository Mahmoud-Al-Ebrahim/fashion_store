import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../core/screen_util.dart';
import 'image_top_side.dart';
import 'store_name_and_stars_top_side.dart';

class StoreTopSide extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const StoreTopSide({
    super.key,
    // required this.storeBloc,
    required this.storeId,
  });

  @override
  State<StoreTopSide> createState() => _StoreTopSideState();
}

class _StoreTopSideState extends State<StoreTopSide> {
  @override
  void initState() {
    // widget.storeBloc.add(
    //   StoreUpperSectionEvent(storeId: widget.storeId),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocSelector<
    //   StoreBloc,
    //   StoreState,
    //   BlocStateData<StoreUpperModel>
    // >(
    //   selector: (state) => state.storeUpperState,
    //   builder: (context, state) {
    //     return BlocStateDataBuilder(
    //       data: state,
    //       onFailed: TopSideShimmer(),
    //       onLoading: TopSideShimmer(),
    //       onSuccess: (state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(13)),
      child: Row(
        children: [
          ImageTopSide(
            heightWidth: 55,
            imageUrl: fakeStoreHeader.profileImage!,
            // state!.profileImage ?? '',
          ),
          SizedBox(width: width(10)),
          StoreNameAndStarsTopSide(
            storeName: fakeStoreHeader.name!,
            //'Adidas', //state.name ?? "___",
            followingNumber: fakeStoreHeader.followersCount!,
            //state.followersCount ?? 0,
            isFollowing: false,
            // state.isFollowed ?? false,
            rating: 3.7, // state.rating ?? 0,
          ),
          Spacer(),
          //AuthServiceLocator.instance.role == TypeUser.user
          if (true) ...{
            // BlocSelector<
            //     StoreBloc,
            //     StoreState,
            //     BlocStateData<FollowStoreModel>?
            // >(
            //   selector:
            //       (state) => state.followStoreStates[widget.storeId],
            //   builder: (context, followState) {
            //     final isLoading = followState?.isLoading ?? false;
            //     final isCurrentlyFollowing = followState?.data?.isFollowing ?? state.isFollowed ?? false;
            //
            //     if (isLoading) {
            //       return SizedBox(
            //         width: 70,
            //         height: 30,
            //         child: Center(
            //           child: CircularProgressIndicator(strokeWidth: 2),
            //         ),
            //       );
            //     }
            //
            //     return
            GestureDetector(
              onTap: () {
                // ✅ تحقق من التوكن أولاً
                // if (AuthServiceLocator.instance.token == null ||
                //     AuthServiceLocator.instance.token!.isEmpty) {
                //   showFlushBar(
                //     context,
                //     "يرجى تسجيل الدخول اولا لتتمكن من المتابعة",
                //   );
                //   return;
                // }

                // ✅ إذا في توكن → نفذ الحدث
                // context.read<StoreBloc>().add(
                //   FollowStoreEvent(
                //     storeId: widget.storeId,
                //     onSuccess: () {
                //       // context.read<StoreBloc>().add(
                //       //   StoreUpperSectionEvent(
                //       //     storeId: widget.storeId,
                //       //   ),
                //       // );
                //     }, currentFollowStatus: isCurrentlyFollowing,
                //   ),
                // );
              },
              child: FollowButton(
                isFollowing: false, //isCurrentlyFollowing ,
              ),
            ),
          },
        ],
      ),
    );
  }
}
