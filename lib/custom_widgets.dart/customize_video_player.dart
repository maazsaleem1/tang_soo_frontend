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

  /// When the engine still reports [Duration.zero] after [initialize], a short
  /// muted decode pass (and optional seek using this hint) fixes duration/position
  /// for Chewie (avoids 00:00 / 00:00 and a stuck progress thumb).
  final Duration? contentDurationHint;

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
    this.contentDurationHint,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  /// Last duration (ms) we treated as “published” to the UI. When the engine
  /// reports 0 first then a real duration later, we rebuild once so Chewie’s
  /// timer/scrubber aren’t stuck on 00:00.
  int _publishedDurationMs = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _onPlaybackUpdated() {
    if (!mounted) return;
    final d = _videoController.value.duration.inMilliseconds;
    if (d <= 0) return;
    // First time duration becomes valid after mount (fixes flaky 00:00).
    if (_publishedDurationMs <= 0) {
      _publishedDurationMs = d;
      setState(() {});
    }
  }

  Future<void> _initializePlayer() async {
    try {
      _videoController =
          widget.isAsset
              ? VideoPlayerController.asset(widget.videoSource)
              : VideoPlayerController.networkUrl(Uri.parse(widget.videoSource));
      await _videoController.initialize();

      await _ensureDurationAndTimeline();

      _publishedDurationMs = _videoController.value.duration.inMilliseconds;

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        allowFullScreen: widget.allowFullScreen,
      );

      _videoController.addListener(_onPlaybackUpdated);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      log("Video Initialization Error: $e");
    }
  }

  /// Some assets report `duration == Duration.zero` until the first decode;
  /// Chewie then divides by zero (broken scrubber + 00:00 / 00:00).
  Future<void> _ensureDurationAndTimeline() async {
    if (!_videoController.value.isInitialized) return;

    Future<void> waitWhile(bool Function() condition) async {
      final deadline = DateTime.now().add(const Duration(milliseconds: 2000));
      while (condition() && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    Future<void> warmDecodeMuted() async {
      final previousVolume = _videoController.value.volume;
      await _videoController.setVolume(0);
      try {
        await _videoController.play();
        await waitWhile(() => _videoController.value.duration == Duration.zero);

        final hint = widget.contentDurationHint;
        if (hint != null &&
            hint > Duration.zero &&
            _videoController.value.duration == Duration.zero) {
          await _videoController.seekTo(
            Duration(milliseconds: hint.inMilliseconds ~/ 2),
          );
          await Future<void>.delayed(const Duration(milliseconds: 120));
          await waitWhile(
            () => _videoController.value.duration == Duration.zero,
          );
          await _videoController.seekTo(Duration.zero);
        }
      } finally {
        await _videoController.pause();
        await _videoController.seekTo(Duration.zero);
        await _videoController.setVolume(previousVolume);
      }
    }

    if (_videoController.value.duration > Duration.zero) {
      if (!widget.autoPlay) {
        await _videoController.pause();
        await _videoController.seekTo(Duration.zero);
      }
      // seekTo(0) can briefly clear duration on some devices — recover.
      if (_videoController.value.duration > Duration.zero) {
        return;
      }
    }

    await warmDecodeMuted();
  }

  @override
  void dispose() {
    _videoController.removeListener(_onPlaybackUpdated);
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
                  ? (widget.fit == BoxFit.cover
                      ? LayoutBuilder(
                        builder: (context, constraints) {
                          // OverflowBox + scale broke hit-testing (±10s skips felt dead).
                          // FittedBox applies the same transform to geometry and taps.
                          final ar = _videoController.value.aspectRatio;
                          final safeAr = ar > 0 ? ar : 16 / 9;
                          final w = constraints.maxWidth;
                          final h = w / safeAr;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRect(
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    clipBehavior: Clip.hardEdge,
                                    child: SizedBox(
                                      width: w,
                                      height: h,
                                      child: Chewie(
                                        controller: _chewieController!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.allowFullScreen)
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Material(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        _chewieController?.enterFullScreen();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      )
                      : Chewie(controller: _chewieController!))
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
