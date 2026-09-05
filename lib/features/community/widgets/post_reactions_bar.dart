import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/session.dart';
import '../../../models/post/post_model.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';

/// The six reaction types `enReactionType` accepts, in the order they are
/// offered, with the emoji that stands for each.
const Map<String, String> kReactionEmojis = {
  'Like': '👍',
  'Love': '❤️',
  'Haha': '😄',
  'Wow': '😮',
  'Sad': '😢',
  'Angry': '😠',
};

/// Reaction summary and picker for one post.
///
/// The API has carried six reaction types and a per-type breakdown
/// (`postReactions`) all along, but the card showed one lump total and a
/// single heart, and the only way to pick a type was a long-press nobody
/// would guess at. This shows which reactions a post actually got - each
/// type with its own count - and lets any of the six be chosen or taken
/// back.
class PostReactionsBar extends StatelessWidget {
  const PostReactionsBar({super.key, required this.post});

  final PostModel post;

  int get _total => post.postReactions.fold<int>(0, (sum, r) => sum + r.count);

  /// Counts keyed by type, including the types nobody picked, in the
  /// canonical order.
  Map<String, int> get _counts {
    final counts = {for (final type in kReactionEmojis.keys) type: 0};
    for (final summary in post.postReactions) {
      // An unknown type from a newer server build is ignored rather than
      // crashing the card, but it still counts toward the total.
      if (counts.containsKey(summary.reactionType)) {
        counts[summary.reactionType] = summary.count;
      }
    }
    return counts;
  }

  /// Types that actually have reactions, most popular first.
  List<MapEntry<String, int>> get _present {
    final present = _counts.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return present;
  }

  /// `POST PostReaction` is a toggle: sending the type already recorded
  /// removes it, sending a different one switches to it.
  Future<void> _react(BuildContext context, String reactionType) async {
    if (!await requireAuth(
      context,
      onSignIn: () => HelperFunctions.navigateToPageAndPopAll(
        context,
        const SignInScreen(),
        true,
      ),
    )) {
      return;
    }
    if (!context.mounted) return;
    context.read<PostBloc>().add(
      TogglePostReactionEvent(
        postId: post.id,
        reactionType: reactionType,
        storeId: post.storeId,
      ),
    );
  }

  /// All six types with their counts, and a tap target on each.
  ///
  /// This is both the breakdown and the picker: seeing that a post has four
  /// laughs and wanting to add a fifth is the same gesture.
  Future<void> _openBreakdown(BuildContext context) async {
    final counts = _counts;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(width(20), 0, width(20), height(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LK.communityAllReactions.tr(),
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: height(4)),
              Text(
                _total == 0
                    ? LK.communityNoReactions.tr()
                    : '$_total ${LK.communityReactions.tr()}',
                style: Theme.of(
                  sheetContext,
                ).textTheme.bodySmall!.copyWith(color: Colors.grey),
              ),
              SizedBox(height: height(10)),
              ...kReactionEmojis.entries.map((entry) {
                final count = counts[entry.key] ?? 0;
                final mine = post.myReaction == entry.key;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 26),
                  ),
                  title: Text(
                    LK.reactionKey(entry.key).tr(),
                    style: TextStyle(
                      fontWeight: mine ? FontWeight.w700 : FontWeight.w400,
                      color: mine
                          ? Theme.of(sheetContext).colorScheme.primary
                          : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$count',
                        style: Theme.of(sheetContext).textTheme.bodyMedium,
                      ),
                      if (mine) ...[
                        SizedBox(width: width(8)),
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Theme.of(sheetContext).colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(entry.key),
                );
              }),
            ],
          ),
        ),
      ),
    );
    if (picked != null && context.mounted) await _react(context, picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = post.myReaction;
    final present = _present;

    return Row(
      children: [
        // My own reaction, or an invitation to leave one. Tap is the plain
        // "Like" everyone expects; long-press opens the full set, same as
        // tapping the summary.
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _react(context, mine ?? 'Like'),
          onLongPress: () => _openBreakdown(context),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(8),
              vertical: height(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mine != null ? (kReactionEmojis[mine] ?? '👍') : '🤍',
                  style: const TextStyle(fontSize: 20),
                ),
                SizedBox(width: width(6)),
                Text(
                  mine != null
                      ? LK.reactionKey(mine).tr()
                      : LK.communityReact.tr(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: mine != null
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: mine != null ? theme.colorScheme.primary : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: width(6)),

        // What everyone else picked: the emoji of each type present, then
        // the total. Tapping opens the breakdown, which doubles as the
        // picker.
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _openBreakdown(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width(6),
                vertical: height(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...present.map(
                    (entry) => Padding(
                      padding: EdgeInsetsDirectional.only(end: width(2)),
                      child: Text(
                        kReactionEmojis[entry.key]!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  if (present.isNotEmpty) SizedBox(width: width(4)),
                  Flexible(
                    child: Text(
                      _total == 0 ? LK.communityNoReactions.tr() : '$_total',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
