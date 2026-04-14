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
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(widget.videoUrl),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..initialize().then((_) {
            setState(() {}); // Update the UI once the video is initialized
            _controller.setLooping(true);
            _controller.setVolume(_isMuted ? 0.0 : 1.0);
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

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  void _showNoteDialog() {
    final timestamp = _formatDuration(_controller.value.position);
    _controller.pause();
    setState(() => _isPlaying = false);

    final noteController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NeoTheme.blue,
              border: Border.all(
                color: NeoTheme.black,
                width: NeoTheme.borderThick,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: NeoTheme.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Note at $timestamp',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: NeoTheme.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: NeoTheme.black,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _controller.play();
                        setState(() => _isPlaying = true);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: NeoTheme.white,
                    border: Border.all(color: NeoTheme.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
                    ],
                  ),
                  child: TextField(
                    controller: noteController,
                    maxLines: 3,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      hintText: 'Type your awesome thoughts...',
                      hintStyle: TextStyle(fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Save to Supabase
                        Navigator.pop(context);
                        _controller.play();
                        setState(() => _isPlaying = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Note saved at $timestamp!',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeoTheme.black,
                              ),
                            ),
                            backgroundColor: NeoTheme.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: NeoTheme.black, width: 2),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: NeoTheme.yellow,
                          border: Border.all(color: NeoTheme.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Save Note',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: NeoTheme.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player Area
            GestureDetector(
              onTap: _togglePlay,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
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

            // Add Note Button
            if (_controller.value.isInitialized)
              Positioned(
                bottom: 110,
                right: 16,
                child: GestureDetector(
                  onTap: _showNoteDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: NeoTheme.yellow,
                      border: Border.all(
                        color: NeoTheme.black,
                        width: NeoTheme.borderThick,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: NeoTheme.black,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.edit_note_rounded,
                          color: NeoTheme.black,
                          size: 24,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Add Note',
                          style: TextStyle(
                            color: NeoTheme.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Video Controls Overlay
            if (_controller.value.isInitialized)
              Positioned(
                bottom: 32,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: NeoTheme.white,
                    border: Border.all(
                      color: NeoTheme.black,
                      width: NeoTheme.borderThick,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: NeoTheme.black, offset: Offset(4, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Play/Pause button
                      GestureDetector(
                        onTap: _togglePlay,
                        child: Icon(
                          _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: NeoTheme.black,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Seek Bar
                      Expanded(
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: NeoTheme.pink,
                            bufferedColor: Colors.black26,
                            backgroundColor: Colors.black12,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Timestamp
                      ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: _controller,
                        builder: (context, value, child) {
                          final position = _formatDuration(value.position);
                          final duration = _formatDuration(value.duration);
                          return Text(
                            '$position / $duration',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: NeoTheme.black,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),

                      // Audio Mute/Unmute toggle
                      GestureDetector(
                        onTap: _toggleMute,
                        child: Icon(
                          _isMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          color: NeoTheme.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
