import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/supabase/note_create_controller.dart';
import 'package:video_player/video_player.dart';
import '../supabase/supabase_service.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_back_button.dart';
import '../widgets/add_note_dialog.dart';
import '../widgets/notes_list_dialog.dart';

class VideoPlayerPage extends ConsumerStatefulWidget {
  final String videoUrl;
  final String username;
  final String description;
  final bool isLocalFile;
  final String videoId;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.description,
    this.isLocalFile = false,
    required this.videoId,
  });

  @override
  ConsumerState<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends ConsumerState<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.isLocalFile
              ? VideoPlayerController.file(
                  File(widget.videoUrl),
                  videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                )
              : VideoPlayerController.networkUrl(
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(notesStreamProvider);
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

  void _showNotesListDialog() {
    _controller.pause();
    setState(() => _isPlaying = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NotesListDialog(
          videoId: widget.videoId,
          onClose: () {
            Navigator.pop(context);
            _controller.play();
            setState(() => _isPlaying = true);
          },
        );
      },
    );
  }

  void _showNoteDialog() {
    final timestamp = _formatDuration(_controller.value.position);
    _controller.pause();
    setState(() => _isPlaying = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddNoteDialog(
          timestamp: timestamp,
          onClose: () {
            Navigator.pop(context);
            _controller.play();
            setState(() => _isPlaying = true);
          },
          onSave: (note) {
            Navigator.pop(context);
            _controller.play();
            setState(() => _isPlaying = true);
            ref
                .read(noteControllerProvider.notifier)
                .createNote(
                  videoId: widget.videoId,
                  note: note,
                  timestamp: timestamp,
                );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(noteControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        loading: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saving note...'),
              backgroundColor: Colors.orangeAccent,
              duration: Duration(seconds: 1),
            ),
          );
        },
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note saved!'),
              backgroundColor: NeoTheme.green,
              duration: Duration(seconds: 1),
            ),
          );
        },
      );
    });
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
            const Positioned(top: 16, left: 16, child: NeoBackButton()),

            // Add Note / View Notes Buttons
            if (_controller.value.isInitialized)
              Positioned(
                bottom: 110,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // View Notes Button
                    GestureDetector(
                      onTap: _showNotesListDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: NeoTheme.green,
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
                              Icons.list_alt_rounded,
                              color: NeoTheme.black,
                              size: 24,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Notes',
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
                    const SizedBox(width: 12),
                    // Add Note Button
                    GestureDetector(
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
                  ],
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

