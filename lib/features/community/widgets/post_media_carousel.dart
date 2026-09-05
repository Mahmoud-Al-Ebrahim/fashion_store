import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../models/post/post_model.dart';
import '../../shop/pages/image_viewer_page.dart';

/// Every photo on a post, swipeable, with a "2 / 5" counter.
///
/// A post can carry several images but the card only ever showed one - the
/// community feed swiped silently with nothing to say there was more, and
/// the store owner's own list rendered `postMedias.first` and stopped. The
/// counter (and the dots under it) are what make the rest discoverable.
///
/// Shared by both lists so they cannot drift apart again.
class PostMediaCarousel extends StatefulWidget {
  const PostMediaCarousel({
    super.key,
    required this.postId,
    required this.media,
    required this.height,
    this.borderRadius,
  });

  final int postId;
  final List<PostMediaModel> media;
  final double height;

  /// Applied when the carousel sits flush against a card's top corners.
  final BorderRadius? borderRadius;

  @override
  State<PostMediaCarousel> createState() => _PostMediaCarouselState();
}

class _PostMediaCarouselState extends State<PostMediaCarousel> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Unique per post *and* per position: the same photo can legitimately
  /// appear twice, and two live Heroes sharing a tag is an error.
  String _heroTag(int index) => 'post-${widget.postId}-media-$index';

  @override
  Widget build(BuildContext context) {
    final media = widget.media;
    if (media.isEmpty) return const SizedBox.shrink();

    final carousel = SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: media.length,
            onPageChanged: (index) => setState(() => _current = index),
            itemBuilder: (context, index) {
              final url = ApiService.resolveUrl(media[index].mediaUrl) ?? '';
              return GestureDetector(
                // Full screen with zoom, same as a product photo.
                onTap: url.isEmpty
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ImageViewerPage(
                            imageUrl: url,
                            heroTag: _heroTag(index),
                          ),
                        ),
                      ),
                child: Hero(
                  tag: _heroTag(index),
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

          // A single photo needs neither a counter nor dots.
          if (media.length > 1) ...[
            PositionedDirectional(
              top: height(10),
              end: width(10),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width(8),
                  vertical: height(3),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  // Written left-to-right in both languages: "2 / 5" is a
                  // fraction, and mirroring it reads as 5 of 2.
                  LK.communityMediaCounter.tr(
                    namedArgs: {
                      'current': '${_current + 1}',
                      'total': '${media.length}',
                    },
                  ),
                  textDirection: ui.TextDirection.ltr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: height(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(media.length, (index) {
                  final selected = index == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: width(2)),
                    width: selected ? width(16) : width(6),
                    height: height(6),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );

    final radius = widget.borderRadius;
    return radius == null
        ? carousel
        : ClipRRect(borderRadius: radius, child: carousel);
  }
}
