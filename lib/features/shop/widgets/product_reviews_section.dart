import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/text_field.dart';
import '../../../blocs/comment_bloc/comment_bloc.dart';
import '../../../blocs/rating_bloc/rating_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/session.dart';
import '../../../core/utils/show_message.dart';
import '../../admin/widgets/confirm_dialog.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';

/// Star rating + comment thread for a product.
///
/// Ratings come from `Rating/AddRating` + `Rating/GetProductRatingByUser`
/// (the endpoint returns only *your* score, so the row shows what you gave).
/// Comments are the full `Comment/*` CRUD - you can edit and delete your own.
class ProductReviewsSection extends StatefulWidget {
  final int productId;

  const ProductReviewsSection({super.key, required this.productId});

  @override
  State<ProductReviewsSection> createState() => _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends State<ProductReviewsSection> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(
      GetProductCommentsEvent(productId: widget.productId),
    );
    if (Session.isSignedIn) {
      context.read<RatingBloc>().add(
        GetProductRatingByUserEvent(productId: widget.productId),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<bool> _ensureSignedIn() => requireAuth(
    context,
    onSignIn: () => HelperFunctions.navigateToPageAndPopAll(
      context,
      const SignInScreen(),
      true,
    ),
  );

  Future<void> _rate(int value) async {
    if (!await _ensureSignedIn()) return;
    if (!mounted) return;
    context.read<RatingBloc>().add(
      AddRatingEvent(productId: widget.productId, ratingValue: value),
    );
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    if (!await _ensureSignedIn()) return;
    if (!mounted) return;
    context.read<CommentBloc>().add(
      AddCommentEvent(productId: widget.productId, content: text),
    );
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _editComment(int commentId, String current) async {
    final controller = TextEditingController(text: current);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LK.commonEdit.tr()),
        content: AuthTextField(
          controller: controller,
          hintText: LK.productAddComment.tr(),
          maxLines: 3,
          validator: (_) => null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LK.commonCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LK.commonSave.tr()),
          ),
        ],
      ),
    );
    if (saved != true || !mounted) return;
    context.read<CommentBloc>().add(
      UpdateCommentEvent(
        commentId: commentId,
        content: controller.text.trim(),
        productId: widget.productId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ownership drives the edit/delete menu. Works for every role - the
    // id comes from the JWT, which is saved on every login.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- rating ----------
        Text(
          LK.productRateIt.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: height(10)),
        BlocConsumer<RatingBloc, RatingState>(
          listenWhen: (p, c) => p.addRatingStatus != c.addRatingStatus,
          listener: (context, state) {
            if (state.addRatingStatus == AddRatingStatus.success) {
              showMessage(LK.productRatingSaved.tr(), hasError: false);
            } else if (state.addRatingStatus == AddRatingStatus.failure) {
              showMessage(state.errorMessage);
            }
          },
          builder: (context, state) {
            return Row(
              children: List.generate(5, (index) {
                final value = index + 1;
                final filled = value <= state.userRating;
                return IconButton(
                  padding: EdgeInsets.symmetric(horizontal: width(2)),
                  constraints: const BoxConstraints(),
                  onPressed: () => _rate(value),
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: filled ? Colors.amber : Colors.grey,
                    size: 30,
                  ),
                );
              }),
            );
          },
        ),
        SizedBox(height: height(20)),

        // ---------- comments ----------
        Text(
          LK.productComments.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: height(10)),
        Row(
          children: [
            Expanded(
              child: AuthTextField(
                controller: _commentController,
                hintText: LK.productAddComment.tr(),
                validator: (_) => null,
                onFieldSubmitted: (_) => _submitComment(),
              ),
            ),
            IconButton(
              onPressed: _submitComment,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: height(10)),
        BlocConsumer<CommentBloc, CommentState>(
          listenWhen: (p, c) =>
              p.commentTransactionStatus != c.commentTransactionStatus,
          listener: (context, state) {
            if (state.commentTransactionStatus ==
                CommentTransactionStatus.failure) {
              showMessage(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state.getProductCommentsStatus ==
                GetProductCommentsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.comments.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: height(10)),
                child: Text(
                  LK.productNoComments.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
            return Column(
              children: state.comments.map((comment) {
                final mine = Session.owns(comment.userId);
                final photo = ApiService.resolveUrl(comment.userImage);
                return Container(
                  margin: EdgeInsets.only(bottom: height(10)),
                  padding: EdgeInsets.all(width(12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAF2).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFFEAEAF2),
                        backgroundImage: photo != null
                            ? CachedNetworkImageProvider(photo)
                            : null,
                        child: photo == null
                            ? const Icon(Icons.person, size: 18)
                            : null,
                      ),
                      SizedBox(width: width(10)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.userFullName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(height: height(2)),
                            Text(
                              comment.text,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (mine)
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_vert, size: 18),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              _editComment(comment.commentId, comment.text);
                            } else {
                              final ok = await confirmDialog(
                                context,
                                title: LK.commonDelete.tr(),
                              );
                              if (!ok || !context.mounted) return;
                              context.read<CommentBloc>().add(
                                DeleteCommentEvent(
                                  commentId: comment.commentId,
                                  productId: widget.productId,
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(LK.commonEdit.tr()),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                LK.commonDelete.tr(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
