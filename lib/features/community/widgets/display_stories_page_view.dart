import 'package:chewie/chewie.dart';
import 'package:fashion_store/features/community/widgets/single_story_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../models/stories_response_model.dart';

class DisplayStoriesPageView extends StatefulWidget {
  const DisplayStoriesPageView({
    super.key,
    required this.collectionIndex,
    this.fromMyOwnStories = false,
    required this.stories,
  });

  final List<Story> stories;
  final int collectionIndex;

  final bool fromMyOwnStories;

  @override
  State<DisplayStoriesPageView> createState() => _DisplayStoriesPageViewState();
}

class _DisplayStoriesPageViewState extends State<DisplayStoriesPageView> {
  final PageController _pageController = PageController();
  final List<StoryItem> stories = [];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var story in stories) {
      story.dispose();
    }
    super.dispose();
  }

  List<Story> originalStories = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      content: Stack(
        children: [
          // BlocBuilder<CommunityBloc, CommunityState>(
          //   buildWhen:
          //       (p, c) => p.deletePostOrStoryState != c.deletePostOrStoryState,
          // listener: (context, state) {
          //   originalStories =
          //       widget.collectionIndex == -1
          //           ? (state.ownerStory?.stories ?? [])
          //           : state
          //                   .storiesPagination
          //                   .items[widget.collectionIndex]
          //                   .stories ??
          //               [];
          //   if (stories.isNotEmpty) {
          //     stories.removeWhere(
          //       (item) =>
          //           originalStories.indexWhere((s) => s.id == item.id) == -1,
          //     );
          //     return;
          //   }
          //   originalStories.forEach((item) {
          //     bool isVideo = item.thumbnailUrl != null;
          //     String url = item.mediaUrl!;
          //     String id = item.id!;
          //     stories.add(
          //       isVideo
          //           ? StoryItem.video(
          //             id,
          //             url,
          //             widget.collectionIndex,
          //             item.text,
          //           )
          //           : StoryItem.image(
          //             id,
          //             url,
          //             widget.collectionIndex,
          //             item.text,
          //           ),
          //     );
          //   });
          // },
          // builder: (context, state) {
          getChild(),
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: height(35),
                  width: width(35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset("assets/svg/cancel.svg"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getChild() {
    //
    // originalStories =
    // widget.collectionIndex == -1
    //     ? (state.ownerStory?.stories ?? [])
    //     : state
    //     .storiesPagination
    //     .items[widget.collectionIndex]
    //     .stories ??
    //     [];
    //
    // stories.clear();
    for (var item in widget.stories) {
      bool isVideo = item.thumbnailUrl != null;
      String url = item.mediaUrl!;
      String id = item.id!;
      stories.add(
        isVideo
            ? StoryItem.video(id, url, widget.collectionIndex, item.text)
            : StoryItem.image(id, url, widget.collectionIndex, item.text),
      );
    }

    return
    // state.deletePostOrStoryState.isLoading
    //   ? Center(child: SizedBox(
    //   height: height(400),
    //   child: MinBaytyLoader()))
    SizedBox(
      height: height(400),
      width: 1.sw,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.stories.length,
        onPageChanged: (index) {
          setState(() {
            // Pause previous video
            if (stories[currentIndex].isVideo) {
              stories[currentIndex].pause();
            }
            currentIndex = index;
            // Play new video
            if (stories[currentIndex].isVideo) {
              stories[currentIndex].play();
            }
          });
        },
        itemBuilder: (context, index) {
          return SingleStoryWidget(
            story: stories[index],
            reactions: widget.stories[index].reactions!,
            fromMyOwnStories: widget.fromMyOwnStories,
          );
        },
      ),
    );
  }
}

class StoryItem {
  final String id;
  final String url;
  final bool isVideo;
  final int collectionIndex;
  final String? text;
  VideoPlayerController? _videoController;
  ChewieController? chewieController;

  StoryItem._(this.url, this.isVideo, this.id, this.collectionIndex, this.text);

  factory StoryItem.image(
    String id,
    String url,
    int collectionIndex,
    String? text,
  ) => StoryItem._(url, false, id, collectionIndex, text);

  factory StoryItem.video(
    String id,
    String url,
    int collectionIndex,
    String? text,
  ) {
    final item = StoryItem._(url, true, id, collectionIndex, text);
    item._videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    item.chewieController = ChewieController(
      videoPlayerController: item._videoController!,
      autoPlay: false,
      looping: false,
      allowFullScreen: false,
      allowMuting: true,
      showControls: true,
    );
    return item;
  }

  void play() {
    _videoController?.play();
  }

  void pause() {
    _videoController?.pause();
  }

  void dispose() {
    _videoController?.dispose();
    chewieController?.dispose();
  }
}
