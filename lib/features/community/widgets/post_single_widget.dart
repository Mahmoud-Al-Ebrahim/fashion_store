import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../models/post/post_model.dart';
import '../../../models/store/store_model.dart';
import '../../shop/pages/image_viewer_page.dart';
import '../../store/pages/store_screen.dart';

/// Reaction types the API accepts, with the emoji shown in the picker.
const Map<String, String> kReactionEmojis = {
  'Like': '👍',
  'Love': '❤️',
  'Haha': '😄',
  'Wow': '😮',
  'Sad': '😢',
  'Angry': '😠',
};

/// A single community/store post: media carousel, content, reaction summary
/// and a long-press reaction picker. Tapping toggles a plain "Like".
class PostSingleWidget extends StatelessWidget {
  final PostModel post;

  const PostSingleWidget({super.key, required this.post});

  int get _totalReactions =>
      post.postReactions.fold<int>(0, (sum, r) => sum + r.count);

  void _react(BuildContext context, String reactionType) {
    context.read<PostBloc>().add(
      TogglePostReactionEvent(
        postId: post.id,
        reactionType: reactionType,
        storeId: post.storeId,
      ),
    );
  }

  Future<void> _pickReaction(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(20),
          vertical: height(24),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: kReactionEmojis.entries
              .map(
                (entry) => IconButton(
                  iconSize: 34,
                  onPressed: () => Navigator.of(sheetContext).pop(entry.key),
                  icon: Text(entry.value, style: const TextStyle(fontSize: 30)),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (picked != null && context.mounted) _react(context, picked);
  }

  @override
  Widget build(BuildContext context) {
    final media = post.postMedias;
    final myReaction = post.myReaction;

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
            SizedBox(
              height: height(220),
              child: PageView.builder(
                itemCount: media.length,
                itemBuilder: (context, index) {
                  final url =
                      ApiService.resolveUrl(media[index].mediaUrl) ?? '';
                  return GestureDetector(
                    // Full screen with zoom, same as a product photo.
                    onTap: url.isEmpty
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImageViewerPage(
                                imageUrl: url,
                                heroTag: 'post-media-$url',
                              ),
                            ),
                          ),
                    child: Hero(
                      tag: 'post-media-$url',
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) =>
                            Container(color: const Color(0xFFEAEAF2)),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFFEAEAF2),
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                    GestureDetector(
                      onTap: () => _react(context, myReaction ?? 'Like'),
                      onLongPress: () => _pickReaction(context),
                      child: Row(
                        children: [
                          Text(
                            myReaction != null
                                ? (kReactionEmojis[myReaction] ?? '👍')
                                : '🤍',
                            style: const TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: width(6)),
                          Text(
                            '$_totalReactions ${LK.communityReactions.tr()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
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
