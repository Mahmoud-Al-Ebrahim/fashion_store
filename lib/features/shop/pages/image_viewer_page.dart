import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Full-screen image with pinch-to-zoom and pan.
///
/// Opened from the product gallery so a shopper can inspect fabric, stitching
/// and colour up close - the detail that decides a clothing purchase is
/// rarely visible at thumbnail size.
class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({super.key, required this.imageUrl, this.heroTag});

  final String imageUrl;

  /// Shared with the thumbnail so the image flies into place.
  final Object? heroTag;

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage>
    with SingleTickerProviderStateMixin {
  final _controller = TransformationController();
  late final AnimationController _animation;
  Animation<Matrix4>? _reset;

  static const double _doubleTapScale = 2.5;

  @override
  void initState() {
    super.initState();
    _animation =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220),
        )..addListener(() {
          if (_reset != null) _controller.value = _reset!.value;
        });
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Double tap zooms toward the point touched, or back out if already
  /// zoomed - the gesture people expect from any photo viewer.
  void _handleDoubleTap(TapDownDetails details) {
    final current = _controller.value;
    final zoomedIn = current.getMaxScaleOnAxis() > 1.01;

    final Matrix4 target;
    if (zoomedIn) {
      target = Matrix4.identity();
    } else {
      final position = details.localPosition;
      target = Matrix4.identity()
        ..translate(
          -position.dx * (_doubleTapScale - 1),
          -position.dy * (_doubleTapScale - 1),
        )
        ..scale(_doubleTapScale);
    }

    _reset = Matrix4Tween(
      begin: current,
      end: target,
    ).animate(CurvedAnimation(parent: _animation, curve: Curves.easeOut));
    _animation.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.contain,
      placeholder: (_, __) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      errorWidget: (_, __, ___) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white54,
          size: 48,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onDoubleTapDown: _handleDoubleTap,
        // InteractiveViewer swallows the double tap itself, so the handler
        // above needs an explicit (empty) onDoubleTap to fire.
        onDoubleTap: () {},
        child: InteractiveViewer(
          transformationController: _controller,
          minScale: 1,
          maxScale: 5,
          child: Center(
            child: widget.heroTag == null
                ? image
                : Hero(tag: widget.heroTag!, child: image),
          ),
        ),
      ),
    );
  }
}
