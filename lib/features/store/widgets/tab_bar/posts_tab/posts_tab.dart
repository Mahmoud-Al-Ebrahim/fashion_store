import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/widgets/async_view.dart';
import '../../../../../blocs/post_bloc/post_bloc.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/screen_util.dart';
import '../../../../community/widgets/post_single_widget.dart';

/// "Posts" tab - the store's feed from `Post/GetAll/{storeId}`, reusing the
/// community post card so reactions behave identically everywhere.
class PostsTab extends StatelessWidget {
  final int storeId;

  const PostsTab({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return AsyncView(
          isLoading: state.getAllPostsStatus == GetAllPostsStatus.loading,
          isFailure: state.getAllPostsStatus == GetAllPostsStatus.failure,
          isEmpty: state.posts.isEmpty,
          errorMessage: state.errorMessage,
          emptyText: LK.storeNoPosts.tr(),
          onRetry: () =>
              context.read<PostBloc>().add(GetAllPostsEvent(storeId: storeId)),
          child: ListView.separated(
            padding: EdgeInsets.all(width(16)),
            itemCount: state.posts.length,
            separatorBuilder: (_, __) => SizedBox(height: height(16)),
            itemBuilder: (context, index) =>
                PostSingleWidget(post: state.posts[index]),
          ),
        );
      },
    );
  }
}
