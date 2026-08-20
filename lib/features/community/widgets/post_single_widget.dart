import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../models/post/post_model.dart';

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
                  icon: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 30),
                  ),
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
          if (media.isNotEmpty)
            SizedBox(
              height: height(220),
              child: PageView.builder(
                itemCount: media.length,
                itemBuilder: (context, index) => CachedNetworkImage(
                  imageUrl: ApiService.resolveUrl(media[index].mediaUrl) ?? '',
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
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
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
