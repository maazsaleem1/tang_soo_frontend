import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// In-app YouTube playback via [youtube_player_flutter] (IFrame API).
///
/// Fullscreen uses a separate route so the player truly fills the screen; the
/// package's [FullScreenButton] is avoided because it forces landscape.
class VideoOfWeekEmbed extends StatefulWidget {
  const VideoOfWeekEmbed({
    super.key,
    required this.videoUrl,
    required this.height,
    required this.width,
  });

  final String videoUrl;
  final double height;
  final double width;

  @override
  State<VideoOfWeekEmbed> createState() => _VideoOfWeekEmbedState();
}

class _VideoOfWeekEmbedState extends State<VideoOfWeekEmbed> {
  static const _barColors = ProgressBarColors(
    playedColor: Color(0xFF01708A),
    handleColor: Color(0xFF01708A),
    bufferedColor: Colors.white24,
    backgroundColor: Colors.white12,
  );

  YoutubePlayerController? _controller;

  /// Inline [YoutubePlayer] is removed while the full-screen route is open so
  /// only one player attaches to [YoutubePlayerController] at a time.
  bool _playerDetachedForFullScreen = false;

  @override
  void initState() {
    super.initState();
    final id = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (id != null && id.length == 11) {
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: true,
          controlsVisibleAtStart: false,
        ),
      );
    }
  }

  Future<void> _openPortraitFullScreen() async {
    final c = _controller;
    if (c == null || !mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);

    setState(() => _playerDetachedForFullScreen = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (!mounted) return;

    await navigator.push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder:
            (ctx) => _YoutubePortraitFullScreenPage(
              controller: c,
              barColors: _barColors,
            ),
      ),
    );

    if (!mounted) return;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.restoreSystemUIOverlays();
    setState(() => _playerDetachedForFullScreen = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    if (c == null) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: const ColoredBox(
          color: Colors.black87,
          child: Center(
            child: Icon(Icons.play_circle_outline, color: Colors.white54),
          ),
        ),
      );
    }

    if (_playerDetachedForFullScreen) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const ColoredBox(color: Colors.black),
      );
    }

    final aspect = widget.width / widget.height;

    return YoutubePlayer(
      controller: c,
      width: widget.width,
      aspectRatio: aspect,
      showVideoProgressIndicator: true,
      progressIndicatorColor: const Color(0xFF01708A),
      progressColors: _barColors,
      bottomActions: [
        const SizedBox(width: 14.0),
        const CurrentPosition(),
        const SizedBox(width: 8.0),
        const ProgressBar(isExpanded: true, colors: _barColors),
        const RemainingDuration(),
        const PlaybackSpeedButton(),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          icon: const Icon(Icons.fullscreen, color: Colors.white, size: 22),
          onPressed: _openPortraitFullScreen,
        ),
      ],
    );
  }
}

class _YoutubePortraitFullScreenPage extends StatefulWidget {
  const _YoutubePortraitFullScreenPage({
    required this.controller,
    required this.barColors,
  });

  final YoutubePlayerController controller;
  final ProgressBarColors barColors;

  @override
  State<_YoutubePortraitFullScreenPage> createState() =>
      _YoutubePortraitFullScreenPageState();
}

class _YoutubePortraitFullScreenPageState
    extends State<_YoutubePortraitFullScreenPage> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            if (w <= 0 || h <= 0) {
              return const SizedBox.shrink();
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: YoutubePlayer(
                    controller: widget.controller,
                    width: w,
                    aspectRatio: w / h,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: const Color(0xFF01708A),
                    progressColors: widget.barColors,
                    bottomActions: [
                      const SizedBox(width: 14.0),
                      const CurrentPosition(),
                      const SizedBox(width: 8.0),
                      ProgressBar(isExpanded: true, colors: widget.barColors),
                      const RemainingDuration(),
                      const PlaybackSpeedButton(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        icon: const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
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
            );
          },
        ),
      ),
    );
  }
}
