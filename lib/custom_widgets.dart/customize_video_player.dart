import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:developer';

class CustomVideoPlayer extends StatefulWidget {
  final String videoSource;
  final bool isAsset;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowFullScreen;
  final double? height;
  final double? width;
  final BoxFit fit;

  const CustomVideoPlayer({
    super.key,
    required this.videoSource,
    this.isAsset = false,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.allowFullScreen = true,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoController =
          widget.isAsset
              ? VideoPlayerController.asset(widget.videoSource)
              : VideoPlayerController.networkUrl(Uri.parse(widget.videoSource));
      await _videoController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        allowFullScreen: widget.allowFullScreen,
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      log("Video Initialization Error: $e");
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 300,
      width: widget.width ?? double.infinity,
      child:
          _isInitialized && _chewieController != null
              ? widget.showControls
                  ? Chewie(controller: _chewieController!)
                  : LayoutBuilder(
                    builder: (context, constraints) {
                      final videoSize = _videoController.value.size;
                      return ClipRect(
                        child: FittedBox(
                          fit: widget.fit,
                          child: SizedBox(
                            width: videoSize.width,
                            height: videoSize.height,
                            child: VideoPlayer(_videoController),
                          ),
                        ),
                      );
                    },
                  )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
