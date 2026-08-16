import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:fashion_store/core/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../models/stories_response_model.dart';
import 'display_stories_page_view.dart';

class SingleStoryWidget extends StatefulWidget {
  const SingleStoryWidget({
    super.key,
    required this.story,
    required this.reactions,
    this.hasReaction,
    this.fromMyOwnStories = false,
  });

  final bool fromMyOwnStories;

  final StoryItem story;
  final Reactions reactions;
  final String? hasReaction;

  @override
  State<SingleStoryWidget> createState() => _SingleStoryWidgetState();
}

class _SingleStoryWidgetState extends State<SingleStoryWidget> {
  final List<String> emojis = ["💖", "🔥", "👍"];
  final List<int> reactions = [];
  final List<String> reactionTypes = ["love", "fire", "like"];

  String? myReaction;

  @override
  void initState() {
    reactions.add(widget.reactions.love ?? 0);
    reactions.add(widget.reactions.fire ?? 0);
    reactions.add(widget.reactions.like ?? 0);
    myReaction = widget.hasReaction;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.story.isVideo) ...{
          FutureBuilder(
            future: widget.story.chewieController!.videoPlayerController
                .initialize(),
            builder: (context, asyncSnapshot) {
              return widget.story.chewieController != null &&
                      widget
                          .story
                          .chewieController!
                          .videoPlayerController
                          .value
                          .isInitialized
                  ? Expanded(
                      child: Chewie(controller: widget.story.chewieController!),
                    )
                  : SizedBox(
                      height: height(300),
                      child: Center(
                        child: FittedBox(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    );
            },
          ),
        } else ...{
          CachedNetworkImage(
            imageUrl: widget.story.url,
            fit: BoxFit.cover,
            width: 1.sw - 20,
            height: height(300),
          ),
        },
        SizedBox(height: height(10)),
        if (widget.story.text != null && widget.story.text != '') ...{
          Text(widget.story.text!, style: context.textTheme.bodySmall),
          SizedBox(height: height(10)),
        },
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(right: width(10)),
              child: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (index) => InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      // so this is my own story , i will not react to it
                      if (widget.story.collectionIndex == -1) {
                        showMessage("لايمكنك التفاعل مع ستورياتك الخاصة");
                        return;
                      }
                      if (myReaction != null) {
                        reactions[reactionTypes.indexWhere(
                          (item) => item == myReaction,
                        )]--;
                      }
                      // BlocProvider.of<CommunityBloc>(context).add(
                      //   ReactToPostOrStoryEvent(
                      //     params: ReactToPostOrStoryParams(
                      //       id: widget.story.id,
                      //       type: reactionTypes[index],
                      //       isForPosts: false,
                      //     ),
                      //     isForRemovePreviousReact:
                      //     myReaction == reactionTypes[index],
                      //     onSuccess: () {},
                      //   ),
                      // );
                    },
                    child: Container(
                      width: width(60),
                      height: height(30),
                      decoration: BoxDecoration(
                        color: myReaction == reactionTypes[index]
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
            ),
            if (widget.fromMyOwnStories)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // BlocProvider.of<CommunityBloc>(context).add(
                      //   DeletePostOrStoryEvent(
                      //     params: DeletePostOrStoryParams(
                      //       id: widget.story.id,
                      //     ),
                      //     onSuccess: () {},
                      //   ),
                      // );
                    },
                    child: Icon(
                      Icons.delete_outline_outlined,
                      size: 30,
                      color: Color(0xffD93F3F),
                    ),
                  ),
                  SizedBox(width: width(10)),
                ],
              ),
          ],
        ),
        // BlocListener<CommunityBloc, CommunityState>(
        //   listenWhen:
        //       (p, c) =>
        //           p.reactToPostOrStory[widget.story.id] !=
        //           c.reactToPostOrStory[widget.story.id],
        //   listener: (context, state) {
        //     if (state.reactToPostOrStory[widget.story.id]?.isSuccess ?? false) {
        //       myReaction = state.reactToPostOrStory[widget.story.id]!.data;
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
        //     selector: (state) => state.reactToPostOrStory[widget.story.id],
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
        //       return Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.only(right: width(10)),
        //             child: Row(
        //               spacing: 10,
        //               mainAxisSize: MainAxisSize.min,
        //               children: List.generate(
        //                 3,
        //                 (index) => InkWell(
        //                   highlightColor: Colors.transparent,
        //                   splashColor: Colors.transparent,
        //                   onTap: () {
        //                     // so this is my own story , i will not react to it
        //                     if (widget.story.collectionIndex == -1) {
        //                       showFlushBar(context, "لايمكنك التفاعل مع ستورياتك الخاصة");
        //                       return;
        //                     }
        //                     if (myReaction != null) {
        //                       reactions[reactionTypes.indexWhere(
        //                         (item) => item == myReaction,
        //                       )]--;
        //                     }
        //                     BlocProvider.of<CommunityBloc>(context).add(
        //                       ReactToPostOrStoryEvent(
        //                         params: ReactToPostOrStoryParams(
        //                           id: widget.story.id,
        //                           type: reactionTypes[index],
        //                           isForPosts: false,
        //                         ),
        //                         isForRemovePreviousReact:
        //                             myReaction == reactionTypes[index],
        //                         onSuccess: () {},
        //                       ),
        //                     );
        //                   },
        //                   child: Container(
        //                     width: width(60),
        //                     height: height(30),
        //                     decoration: BoxDecoration(
        //                       color:
        //                           myReaction == reactionTypes[index]
        //                               ? Color(0xffF27D72)
        //                               : Color(0x1FF27D72),
        //                       borderRadius: BorderRadius.circular(12),
        //                     ),
        //                     child: Center(
        //                       child: Text(
        //                         "${reactions[index]} ${emojis[index]}",
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           if (widget.fromMyOwnStories)
        //             Row(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 InkWell(
        //                   onTap: () {
        //                     BlocProvider.of<CommunityBloc>(context).add(
        //                       DeletePostOrStoryEvent(
        //                         params: DeletePostOrStoryParams(
        //                           id: widget.story.id,
        //                         ),
        //                         onSuccess: () {},
        //                       ),
        //                     );
        //                   },
        //                   child: Icon(
        //                     Icons.delete_outline_outlined,
        //                     size: 30,
        //                     color: Color(0xffD93F3F),
        //                   ),
        //                 ),
        //                 SizedBox(width: width(10),)
        //               ],
        //             ),
        //         ],
        //       );
        //     },
        //   ),
        // ),
        SizedBox(height: height(10)),
      ],
    );
  }
}
