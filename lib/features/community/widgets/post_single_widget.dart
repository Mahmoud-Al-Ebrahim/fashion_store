import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../models/post/post_model.dart';
import '../../../models/store/store_model.dart';
import '../../store/pages/store_screen.dart';
import 'post_media_carousel.dart';
import 'post_reactions_bar.dart';

/// A single community/store post: media carousel, content, and the reaction
/// summary/picker.
class PostSingleWidget extends StatelessWidget {
  final PostModel post;

  const PostSingleWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final media = post.postMedias;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD3D3E4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Who posted this. The post payload only carries `storeId`, so the
          // name and logo come from the store list the feed already loaded
          // to know which stores to pull posts from - no extra request.
          _StoreHeader(storeId: post.storeId),
          if (media.isNotEmpty)
            PostMediaCarousel(
              postId: post.id,
              media: media,
              height: height(220),
            ),
          Padding(
            padding: EdgeInsets.all(width(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.content.isNotEmpty)
                  Text(
                    post.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                SizedBox(height: height(10)),
                Row(
                  children: [
                    Expanded(child: PostReactionsBar(post: post)),
                    SizedBox(width: width(8)),
                    Text(
                      '${post.createdAt.year}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Store identity strip at the top of a post, tappable through to the store.
class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      buildWhen: (p, c) => p.stores != c.stores,
      builder: (context, state) {
        StoreModel? store;
        for (final candidate in state.stores) {
          if (candidate.id == storeId) {
            store = candidate;
            break;
          }
        }
        if (store == null) return const SizedBox.shrink();

        final logo = ApiService.resolveUrl(store.logo) ?? '';
        final resolved = store;
        return InkWell(
          onTap: () => context.pushPage(StoreScreen(store: resolved)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(14),
              vertical: height(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: width(18),
                  backgroundColor: const Color(0xFFEAEAF2),
                  backgroundImage: logo.isEmpty
                      ? null
                      : CachedNetworkImageProvider(logo),
                  child: logo.isEmpty
                      ? const Icon(Icons.storefront_outlined, size: 18)
                      : null,
                ),
                SizedBox(width: width(10)),
                Expanded(
                  child: Text(
                    resolved.storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
