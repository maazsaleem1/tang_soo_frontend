import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// In-app YouTube playback via [youtube_player_flutter] (IFrame API).
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
  YoutubePlayerController? _controller;
  bool _wasFullScreen = false;

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
      _controller!.addListener(_onYoutubeControllerUpdate);
    }
  }

  void _onYoutubeControllerUpdate() {
    final c = _controller;
    if (c == null || !mounted) return;

    final fs = c.value.isFullScreen;
    if (fs == _wasFullScreen) return;
    _wasFullScreen = fs;

    if (fs) {
      Future.microtask(() {
        if (!mounted) return;
        final stillFs = _controller?.value.isFullScreen ?? false;
        if (!stillFs) return;

        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

        final screen = MediaQuery.sizeOf(context);
        _controller?.fitHeight(screen);
      });
    } else {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.restoreSystemUIOverlays();

      Future.microtask(() {
        if (!mounted) return;
        _controller?.fitHeight(Size(widget.width, widget.height));
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onYoutubeControllerUpdate);
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.restoreSystemUIOverlays();
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

    final aspect = widget.width / widget.height;

    return YoutubePlayer(
      controller: c,
      width: widget.width,
      aspectRatio: aspect,
      showVideoProgressIndicator: true,
      progressIndicatorColor: const Color(0xFF01708A),
      progressColors: const ProgressBarColors(
        playedColor: Color(0xFF01708A),
        handleColor: Color(0xFF01708A),
        bufferedColor: Colors.white24,
        backgroundColor: Colors.white12,
      ),
    );
  }
}
