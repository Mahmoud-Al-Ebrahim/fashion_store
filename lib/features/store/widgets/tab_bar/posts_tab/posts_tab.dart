// ---------------- PostsTab ----------------
import 'package:fashion_store/features/store/widgets/tab_bar/posts_tab/photo_and_reels/photo_section/photo_section.dart';
import 'package:fashion_store/features/store/widgets/tab_bar/posts_tab/photo_and_reels/reels_section/reels_section.dart';
import 'package:fashion_store/features/store/widgets/tab_bar/posts_tab/photo_or_reels_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/screen_util.dart';

class PostsTab extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const PostsTab({
    super.key,
    required this.storeId,
  });

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool type = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return BlocBuilder<PostsTabCubit, PostsTabType>(
    //   builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: height(15)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhotoOrReelsCard(
                    text: 'الصور',
                    icon: "assets/svg/photo.svg",
                    isSelected: !type , //state == PostsTabType.photos,
                    onTap:
                        () {
                          setState(() {
                            type = false;
                          });
                          // context.read<PostsTabCubit>().selectTab(
                          //   PostsTabType.photos,
                          // )
                        },
                  ),
                  SizedBox(width: width(28)),
                  PhotoOrReelsCard(
                    text: "الفيديو",
                    icon: "assets/svg/Video.svg",
                    isSelected: type , //state == PostsTabType.videos,
                    onTap:
                        () {
                      setState(() {
                        type = true;
                      });
                          // context.read<PostsTabCubit>().selectTab(
                          //   PostsTabType.videos,
                          // ),
                        }
                  ),
                ],
              ),
              SizedBox(height: height(20)),
              Expanded(
                child:
                    !type
                        ? PhotosSection(
                          storeId: widget.storeId,
                          // storeBloc: widget.storeBloc,
                        )
                        : ReelsSection(
                          // storeBloc: widget.storeBloc,
                          storeId: widget.storeId,
                        ),
              ),
            ],
          ),
        );
  }
}
