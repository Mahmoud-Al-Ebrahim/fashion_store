import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../widgets/post_single_widget.dart';

/// Community feed - posts from every store, newest first.
///
/// Stories were removed from the product; this page is now purely the post
/// feed. Because the backend only serves posts per store, the feed is
/// assembled from the store list (see `GetCommunityFeedEvent`).
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
    final stores = context.read<StoreBloc>().state.stores;
    if (stores.isEmpty) {
      context.read<StoreBloc>().add(GetAllStoresEvent());
    } else {
      _loadFeed();
    }
  }

  void _loadFeed() {
    final stores = context.read<StoreBloc>().state.stores;
    context.read<PostBloc>().add(
      GetCommunityFeedEvent(storeIds: stores.map((s) => s.id).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<StoreBloc, StoreState>(
        listenWhen: (p, c) => p.stores != c.stores,
        listener: (context, state) {
          if (state.stores.isNotEmpty) _loadFeed();
        },
        child: BlocBuilder<PostBloc, PostState>(
          buildWhen: (p, c) =>
              p.getCommunityFeedStatus != c.getCommunityFeedStatus ||
              p.communityFeed != c.communityFeed,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async => _loadFeed(),
              child: AsyncView(
                isLoading:
                    state.getCommunityFeedStatus == GetCommunityFeedStatus.loading,
                isFailure:
                    state.getCommunityFeedStatus == GetCommunityFeedStatus.failure,
                isEmpty: state.getCommunityFeedStatus ==
                        GetCommunityFeedStatus.success &&
                    state.communityFeed.isEmpty,
                errorMessage: state.errorMessage,
                emptyText: LK.communityNoPosts.tr(),
                onRetry: _loadFeed,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(width(16)),
                  itemCount: state.communityFeed.length,
                  separatorBuilder: (_, __) => SizedBox(height: height(16)),
                  itemBuilder: (context, index) =>
                      PostSingleWidget(post: state.communityFeed[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
