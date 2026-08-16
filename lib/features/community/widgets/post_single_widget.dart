import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/widgets/button.dart';
import '../../../core/screen_util.dart';
import '../../../models/posts_response_model.dart';
import '../../store/widgets/store_top_side/image_top_side.dart';

class PostSingleWidget extends StatefulWidget {
  const PostSingleWidget({super.key, required this.post});

  final PostModel post;

  @override
  State<PostSingleWidget> createState() => _PostSingleWidgetState();
}

class _PostSingleWidgetState extends State<PostSingleWidget> {
  bool isFollowed = false;

  final List<String> emojis = ["💖", "🔥", "👍"];
  final List<int> reactions = [];
  final List<String> reactionTypes = ["love", "fire", "like"];

  late final String storeId;

  String? myReaction;

  @override
  void initState() {
    super.initState();
    storeId = widget.post.store!.id!;
    isFollowed = widget.post.isFollowed ?? false;
    myReaction = widget.post.hasReacted;
    reactions.add(widget.post.reactions?.love ?? 0);
    reactions.add(widget.post.reactions?.fire ?? 0);
    reactions.add(widget.post.reactions?.like ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: width(10),
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageTopSide(
                  heightWidth: 50,
                  imageUrl: widget.post.store!.logoUrl!,
                ),
                Text(
                  widget.post.store!.name.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            // BlocSelector<
            //   CommunityBloc,
            //   CommunityState,
            //   BlocStateData<Unit>?
            // >(
            //   selector: (state) => state.changeFollowingStatus[storeId],
            //   builder: (context, followState) {
            //     final isLoading = followState?.isLoading ?? false;
            //     final isFailed = followState?.isFailed ?? false;
            //     if (isLoading) {
            //       isFollowed = !isFollowed;
            //     }
            //     if (isFailed) {
            //       isFollowed = !isFollowed;
            //     }
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
                    // // ✅ إذا في توكن → نفذ الحدث
                    // context.read<CommunityBloc>().add(
                    //   ChangeFollowingStatusEvent(
                    //     storeId: storeId,
                    //     onSuccess: () {
                    //       // context.read<StoreBloc>().add(
                    //       //   StoreUpperSectionEvent(
                    //       //     storeId: widget.storeId,
                    //       //   ),
                    //       // );
                    //     },
                    //   ),
                    // );
                  },
                  child: FollowButton(isFollowing: isFollowed),
                )
          ],
        ),
        SizedBox(height: height(15)),
        if (widget.post.text != null) ...{
          Text(
            widget.post.text.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        },
        SizedBox(height: height(15)),
        if (widget.post.mediaUrl != null) ...{
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: CachedNetworkImage(
              imageUrl: widget.post.mediaUrl!,
              height: height(170),
              width: 1.sw,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: height(220),
                      width: width(140),
                      color: Colors.white,
                    ),
                  ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          SizedBox(height: height(10)),
        },
        // BlocListener<CommunityBloc, CommunityState>(
        //   listenWhen:
        //       (p, c) =>
        //           p.reactToPostOrStory[widget.post.id] !=
        //           c.reactToPostOrStory[widget.post.id],
        //   listener: (context, state) {
        //     if (state.reactToPostOrStory[widget.post.id]?.isSuccess ?? false) {
        //       myReaction = state.reactToPostOrStory[widget.post.id]!.data;
        //       if (myReaction != null) {
        //         reactions[reactionTypes.indexWhere(
        //           (item) => item == myReaction,
        //         )]++;
        //       }
        //     }
        //   },
        //   child: BlocSelector<
        //     CommunityBloc,
        //     CommunityState,
        //     BlocStateData<String?>?
        //   >(
        //     selector: (state) => state.reactToPostOrStory[widget.post.id],
        //     builder: (context, state) {
        //       final isLoading = state?.isLoading ?? false;
        //
        //       if (isLoading) {
        //         return SizedBox(
        //           width: 70,
        //           height: 30,
        //           child: Center(child: MinBaytyLoader()),
        //         );
        //       }
        //
        //       return
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                      (index) => InkWell(
                        onTap: () {
                          if (myReaction != null) {
                            reactions[reactionTypes.indexWhere(
                              (item) => item == myReaction,
                            )]--;
                          }
                          // BlocProvider.of<CommunityBloc>(context).add(
                          //   ReactToPostOrStoryEvent(
                          //     params: ReactToPostOrStoryParams(
                          //       id: widget.post.id!,
                          //       type: reactionTypes[index],
                          //       isForPosts: true,
                          //     ),
                          //     isForRemovePreviousReact:
                          //         myReaction == reactionTypes[index],
                          //     onSuccess: () {},
                          //   ),
                          // );
                        },
                        child: Container(
                          width: width(60),
                          height: height(30),
                          decoration: BoxDecoration(
                            color:
                                myReaction == reactionTypes[index]
                                    ? Color(0xffF27D72)
                                    : Color(0x1FF27D72),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text("${reactions[index]} ${emojis[index]}"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // if (widget.post.store?.id ==
                  //     AuthServiceLocator.instance.storeId)
                  //   Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           BlocProvider.of<CommunityBloc>(context).add(
                  //             DeletePostOrStoryEvent(
                  //               params: DeletePostOrStoryParams(
                  //                 id: widget.post.id!,
                  //                 isForPost: true,
                  //               ),
                  //               onSuccess: () {},
                  //             ),
                  //           );
                  //         },
                  //         child: Icon(
                  //           Icons.delete_outline_outlined,
                  //           size: 20,
                  //           color: Color(0xffD93F3F),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                ],
              )
      ],
    );
  }
}
