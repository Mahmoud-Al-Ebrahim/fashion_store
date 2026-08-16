import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../models/stories_response_model.dart';
import 'display_stories_page_view.dart';

class StoriesSection extends StatefulWidget {
  const StoriesSection({super.key, required this.stories, this.ownerStory});

  final List<OwnerStory> stories;

  final OwnerStory? ownerStory;

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(_paginationListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_paginationListener);
    scrollController.dispose();
  }

  void _paginationListener() {
    // if (scrollController.offset >=
    //     (scrollController.position.maxScrollExtent * 0.7)) {
    //   BlocProvider.of<CommunityBloc>(
    //     context,
    //   ).add(GetStoriesEvent(onSuccess: () {}));
    // }
  }

  @override
  Widget build(BuildContext context) {
    bool isUser = true; //AuthServiceLocator.instance.role == TypeUser.user;

    final stories = List.of(widget.stories);
    stories.removeWhere((item) => item.stories?.isEmpty ?? true);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: height(112),
        child: Row(
          children: [
            // if(AuthServiceLocator.instance.role != TypeUser.user)
            //   BlocBuilder<CommunityBloc, CommunityState>(
            //     buildWhen: (p, c) => p.addStoryState != c.addStoryState,
            //     builder: (context, state) {
            //       return state.addStoryState.isLoading
            //           ? Center(child: MinBaytyLoader())
            //           :
            //       InkWell(
            //         onTap: () async {
            //           showDialog(
            //             context: context,
            //             builder: (_) =>
            //                 BlocProvider.value(
            //                   value: BlocProvider.of<CommunityBloc>(context),
            //                   child: SelectStoryAndNoteDialog(),
            //                 ),
            //           );
            //         },
            //         child: Container(
            //           width: width(105),
            //           decoration: BoxDecoration(
            //             color: Colors.orange.shade100,
            //             borderRadius: BorderRadius.circular(20),
            //             border: Border.all(color: Color(0x38666A7A)),
            //           ),
            //           child: Stack(
            //             children: [
            //               const Center(
            //                 child: Icon(
            //                   Icons.add,
            //                   size: 40,
            //                   color: Colors.deepOrange,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            SizedBox(width: 12),
            if (widget.ownerStory != null) ...{
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder:
                        (_) =>
                        DisplayStoriesPageView(
                          collectionIndex: -1,
                          fromMyOwnStories: true,
                          stories: widget.ownerStory!.stories ?? [],
                        ),
                  );
                },
                child: Container(
                  width: width(105),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0x38666A7A)),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.ownerStory!.stories![0].thumbnailUrl ??
                            widget.ownerStory!.stories![0].mediaUrl!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Color(0x522B2F3F), Color(0xC22B2F3F)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xffF9F5F0),
                                  width: 0.5,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.ownerStory!.store!.logoUrl ??
                                        widget
                                            .ownerStory!
                                            .store!
                                            .mainImage ??
                                        '',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width(80),
                              child: Text(
                                widget.ownerStory!.store!.name!,
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
            },
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.stories.length,
                controller: scrollController,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final story = widget.stories[index];

                  return InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder:
                            (_) =>
                            DisplayStoriesPageView(
                              collectionIndex: index,
                              stories: story.stories ?? [],
                            ),
                      );
                    },
                    child: Container(
                      width: width(105),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0x38666A7A)),
                        image: DecorationImage(
                          image: NetworkImage(
                            story.stories![0].thumbnailUrl ??
                                story.stories![0].mediaUrl!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0x522B2F3F),
                                    Color(0xC22B2F3F),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xffF9F5F0),
                                      width: 0.5,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        story.store!.logoUrl ??
                                            story.store!.mainImage ??
                                            '',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width(80),
                                  child: Text(
                                    story.store!.name!,
                                    style: context.textTheme.labelMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
