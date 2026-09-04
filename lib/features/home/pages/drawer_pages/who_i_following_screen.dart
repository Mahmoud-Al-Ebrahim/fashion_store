import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/async_view.dart';
import '../../../../app/widgets/button.dart';
import '../../../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../models/store/store_model.dart';
import '../../../store/pages/store_screen.dart';

/// "Stores I follow", backed by `StoreFollower/GetStoreFollowByUser`.
///
/// Unfollowing here uses the same toggle endpoint as the store page, and the
/// bloc re-fetches this list after every toggle, so the two stay in step.
class WhoIFollowingScreen extends StatefulWidget {
  const WhoIFollowingScreen({super.key});

  @override
  State<WhoIFollowingScreen> createState() => _WhoIFollowingScreenState();
}

class _WhoIFollowingScreenState extends State<WhoIFollowingScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() =>
      context.read<StoreFollowerBloc>().add(GetFollowedStoresEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.profileFollowing.tr()),
      ),
      body: BlocBuilder<StoreFollowerBloc, StoreFollowerState>(
        buildWhen: (p, c) =>
            p.getFollowedStoresStatus != c.getFollowedStoresStatus ||
            p.followedStores != c.followedStores ||
            p.toggleStoreFollowStatus != c.toggleStoreFollowStatus,
        builder: (context, state) {
          final busy =
              state.toggleStoreFollowStatus == ToggleStoreFollowStatus.loading;
          return AsyncView(
            isLoading:
                state.getFollowedStoresStatus ==
                    GetFollowedStoresStatus.loading &&
                state.followedStores.isEmpty,
            isFailure:
                state.getFollowedStoresStatus ==
                GetFollowedStoresStatus.failure,
            isEmpty:
                state.getFollowedStoresStatus ==
                    GetFollowedStoresStatus.success &&
                state.followedStores.isEmpty,
            errorMessage: state.errorMessage,
            emptyText: LK.followingEmpty.tr(),
            onRetry: _load,
            child: RefreshIndicator(
              onRefresh: () async => _load(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                itemCount: state.followedStores.length,
                separatorBuilder: (_, __) => SizedBox(height: height(12)),
                itemBuilder: (context, index) => _FollowedStoreTile(
                  store: state.followedStores[index],
                  busy: busy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FollowedStoreTile extends StatelessWidget {
  final StoreModel store;
  final bool busy;

  const _FollowedStoreTile({required this.store, required this.busy});

  @override
  Widget build(BuildContext context) {
    final logo = ApiService.resolveUrl(store.logo);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.pushPage(StoreScreen(store: store)),
      child: Container(
        padding: EdgeInsets.all(width(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD3D3E4)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFEAEAF2),
              backgroundImage: logo != null
                  ? CachedNetworkImageProvider(logo)
                  : null,
              child: logo == null ? const Icon(Icons.storefront) : null,
            ),
            SizedBox(width: width(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: height(2)),
                  Text(
                    store.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: width(8)),
            busy
                ? SizedBox(
                    width: width(70),
                    height: height(30),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : GestureDetector(
                    // Same toggle the store page uses; the bloc refreshes
                    // this list on success so the row disappears.
                    onTap: () => context.read<StoreFollowerBloc>().add(
                      ToggleStoreFollowEvent(storeId: store.id),
                    ),
                    child: const FollowButton(isFollowing: true),
                  ),
          ],
        ),
      ),
    );
  }
}
