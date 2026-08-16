import 'package:fashion_store/models/dummy/stories_posts_fake_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/screen_util.dart';
import '../widgets/posts_section.dart';
import '../widgets/stories_section.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
    bool isUser = true; //AuthServiceLocator.instance.role == TypeUser.user;
    // widget.communityBloc.add(GetStoriesEvent(onSuccess: () {}, reset: !isUser));
    // widget.communityBloc.add(GetPostsEvent(onSuccess: () {}, reset: !isUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // BlocBuilder<CommunityBloc, CommunityState>(
          //   buildWhen:
          //       (p, c) =>
          //           p.storiesPagination.paginationStatus !=
          //           c.storiesPagination.paginationStatus,
          //   builder: (context, state) {
          //     if (!state.storiesPagination.isSuccess &&
          //         state.storiesPagination.items.isEmpty) {
          //       return StoriesShimmer();
          //     }
          //     if(state.storiesPagination.items.isEmpty){
          //       return Center(
          //           child: const NoData(
          //             heightt: 100,
          //             imageHeight: 80,
          //             text: "لايوجد ستوريات",
          //           ));
          //     }
          StoriesSection(stories: storiesFakeData),
          //     );
          //   },
          // ),
          SizedBox(height: height(30)),
          Expanded(
            child:
                // BlocBuilder<CommunityBloc, CommunityState>(
                //   buildWhen:
                //       (p, c) =>
                //           p.postsPagination.paginationStatus !=
                //               c.postsPagination.paginationStatus ||
                //           p.addPostState != c.addPostState ||
                //           p.deletePostOrStoryState != c.deletePostOrStoryState,
                //   builder: (context, state) {
                //     if (!state.postsPagination.isSuccess &&
                //         state.postsPagination.items.isEmpty) {
                //       return PostsShimmer();
                //     }
                //     if(state.postsPagination.items.isEmpty){
                //       return Center(
                //           child: const NoData(
                //             heightt: 400,
                //             text: "لايوجد منشورات",
                //           ));
                //     }
                PostsSection(posts: postsFakeData),
          ),
          //     },
          //   ),
          // ),
          SizedBox(height: height(20)),
        ],
      ),
    );
  }
}
