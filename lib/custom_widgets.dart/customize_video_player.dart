import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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

  /// Stacked expand control + Chewie’s built-in fullscreen would show twice;
  /// we hide Chewie’s control and open [PortraitFullScreenVideoPage] instead.
  bool get _stackedCoverWithControls =>
      widget.showControls && widget.fit == BoxFit.cover;

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
        allowFullScreen:
            widget.allowFullScreen && !_stackedCoverWithControls,
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

  Future<void> _openPortraitFullScreen() async {
    if (!_stackedCoverWithControls || !widget.allowFullScreen) return;
    await _videoController.pause();
    if (!mounted) return;
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder:
            (_) => PortraitFullScreenVideoPage(
              videoSource: widget.videoSource,
              isAsset: widget.isAsset,
              initialPosition: _videoController.value.position,
              contentDurationHint: widget.contentDurationHint,
              looping: widget.looping,
            ),
      ),
    );
    if (!mounted) return;
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
                              if (widget.allowFullScreen &&
                                  _stackedCoverWithControls)
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Material(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: _openPortraitFullScreen,
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

/// Portrait, immersive full-screen for MP4/network (single expand control; mirrors
/// [VideoOfWeekEmbed] route UX). Chewie fullscreen is disabled to avoid duplicates.
class PortraitFullScreenVideoPage extends StatefulWidget {
  const PortraitFullScreenVideoPage({
    super.key,
    required this.videoSource,
    required this.isAsset,
    this.initialPosition = Duration.zero,
    this.contentDurationHint,
    this.looping = true,
  });

  final String videoSource;
  final bool isAsset;
  final Duration initialPosition;
  final Duration? contentDurationHint;
  final bool looping;

  @override
  State<PortraitFullScreenVideoPage> createState() =>
      _PortraitFullScreenVideoPageState();
}

class _PortraitFullScreenVideoPageState extends State<PortraitFullScreenVideoPage> {
  late VideoPlayerController _video;
  ChewieController? _chewie;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _boot();
  }

  Future<void> _boot() async {
    try {
      _video =
          widget.isAsset
              ? VideoPlayerController.asset(widget.videoSource)
              : VideoPlayerController.networkUrl(Uri.parse(widget.videoSource));
      await _video.initialize();
      await _warmDurationIfNeeded();
      if (widget.initialPosition > Duration.zero) {
        await _video.seekTo(widget.initialPosition);
      }
      if (!mounted) return;
      _chewie = ChewieController(
        videoPlayerController: _video,
        autoPlay: true,
        looping: widget.looping,
        showControls: true,
        allowFullScreen: false,
      );
      setState(() => _ready = true);
    } catch (e, st) {
      log('PortraitFullScreenVideoPage._boot: $e\n$st');
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _warmDurationIfNeeded() async {
    if (_video.value.duration > Duration.zero) return;

    Future<void> waitWhile(bool Function() condition) async {
      final deadline = DateTime.now().add(const Duration(milliseconds: 2000));
      while (condition() && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    final previousVolume = _video.value.volume;
    await _video.setVolume(0);
    try {
      await _video.play();
      await waitWhile(() => _video.value.duration == Duration.zero);

      final hint = widget.contentDurationHint;
      if (hint != null &&
          hint > Duration.zero &&
          _video.value.duration == Duration.zero) {
        await _video.seekTo(
          Duration(milliseconds: hint.inMilliseconds ~/ 2),
        );
        await Future<void>.delayed(const Duration(milliseconds: 120));
        await waitWhile(() => _video.value.duration == Duration.zero);
        await _video.seekTo(Duration.zero);
      }
    } finally {
      await _video.pause();
      await _video.seekTo(Duration.zero);
      await _video.setVolume(previousVolume);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.restoreSystemUIOverlays();
    _chewie?.dispose();
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_ready && _chewie != null)
              LayoutBuilder(
                builder: (context, c) {
                  final maxW = c.maxWidth;
                  final maxH = c.maxHeight;
                  final sz = _video.value.size;
                  final vw = sz.width;
                  final vh = sz.height;
                  if (vw <= 0 || vh <= 0) {
                    return Center(
                      child: SizedBox(
                        width: maxW,
                        height: maxH,
                        child: Chewie(controller: _chewie!),
                      ),
                    );
                  }
                  return Center(
                    child: SizedBox(
                      width: maxW,
                      height: maxH,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: vw,
                          height: vh,
                          child: Chewie(controller: _chewie!),
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white70),
              ),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
