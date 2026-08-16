import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/screen_util.dart';

class ShowAllPhotoOrReelWidget extends StatefulWidget {
  final String url;

  const ShowAllPhotoOrReelWidget({super.key, required this.url});

  @override
  State<ShowAllPhotoOrReelWidget> createState() =>
      _ShowAllPhotoOrReelWidgetState();
}

class _ShowAllPhotoOrReelWidgetState extends State<ShowAllPhotoOrReelWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _isVideo = _checkIfVideo(widget.url);

    if (_isVideo) {
      _videoController =
      VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: false,
            allowMuting: true,
            showControlsOnInitialize: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              bufferedColor:
              Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          );
          setState(() {});
        });
    }
  }

  bool _checkIfVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith(".mp4") ||
        lower.endsWith(".mov") ||
        lower.endsWith(".webm");
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _isVideo
                ? (_chewieController != null &&
                _videoController!.value.isInitialized)
                ? SizedBox(
              height: height(500),
              width: double.infinity,
              child: Chewie(controller: _chewieController!),
            )
                : const Center(child: CircularProgressIndicator())
                : _buildImageWithShimmer(widget.url),
          ),

          // زر الإغلاق
          Positioned(
            top: -20,
            right: 0,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithShimmer(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      height: height(500),
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height(500),
            width: double.infinity,
            color: Colors.white,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
