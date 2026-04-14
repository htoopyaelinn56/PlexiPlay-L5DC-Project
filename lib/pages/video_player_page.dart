import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/neo_theme.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String username;
  final String description;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.description,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Update the UI once the video is initialized
        _controller.setLooping(true);
        _controller.play(); // Auto-play when opened
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player Area
            GestureDetector(
              onTap: _togglePlay,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: NeoTheme.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_controller.value.isInitialized)
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    else
                      const CircularProgressIndicator(color: NeoTheme.green),

                    // Play/Pause Overlay Icon
                    if (!_isPlaying && _controller.value.isInitialized)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: NeoTheme.pink,
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: NeoTheme.black,
                          size: 48,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Floating Back Button
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NeoTheme.white,
                    border: Border.all(
                      color: NeoTheme.black,
                      width: NeoTheme.borderThick,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: NeoTheme.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
