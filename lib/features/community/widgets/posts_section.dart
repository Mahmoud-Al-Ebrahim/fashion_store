import 'package:fashion_store/features/community/widgets/post_single_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/screen_util.dart';
import '../../../models/posts_response_model.dart';
import 'add_post_dialog.dart';

class PostsSection extends StatefulWidget {
  const PostsSection({super.key, required this.posts});

  final List<PostModel> posts;

  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
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
    //   ).add(GetPostsEvent(onSuccess: () {}));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: height(20),
      children: [
        // if(AuthServiceLocator.instance.role != TypeUser.user)
        //   BlocBuilder<CommunityBloc, CommunityState>(
        //     buildWhen: (p, c) => p.addPostState != c.addPostState,
        //     builder: (context, state) {
        //       return state.addPostState.isLoading
        //           ? Center(child: MinBaytyLoader())
        //           :
        // InkWell(
        //   onTap: () async {
        //     showDialog(context: context, builder: (_) => AddPostDialog());
        //   },
        //   child: Container(
        //     width: 1.sw - 50,
        //     height: height(40),
        //     decoration: BoxDecoration(
        //       color: Colors.orange.shade100,
        //       borderRadius: BorderRadius.circular(20),
        //       border: Border.all(color: Color(0x38666A7A)),
        //     ),
        //     child: Stack(
        //       children: [
        //         const Center(
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(Icons.add, size: 40, color: Colors.deepOrange),
        //               Text("إضافة منشور جديد"),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsetsGeometry.symmetric(horizontal: width(20)),
            itemBuilder: (context, index) {
              return PostSingleWidget(post: widget.posts[index]);
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                indent: 20,
                endIndent: 20,
                color: Color(0xffC9E3D1),
              ),
            ),
            itemCount: widget.posts.length,
          ),
        ),
      ],
    );
  }
}
