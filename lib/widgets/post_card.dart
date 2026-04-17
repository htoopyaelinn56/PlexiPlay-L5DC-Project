import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:plexi_play/local_db/downloaded_videos_repository.dart';
import '../theme/neo_theme.dart';
import '../pages/video_player_page.dart';
import '../pages/comments_page.dart';

class PostCard extends ConsumerStatefulWidget {
  final String videoUrl;
  final String username;
  final String description;
  final bool isProfileView;
  final VoidCallback? onDelete;
  final VoidCallback? onHide;

  const PostCard({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.description,
    this.isProfileView = false,
    this.onDelete,
    this.onHide,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _isLiked = false;

  void _openVideo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          videoUrl: widget.videoUrl,
          username: widget.username,
          description: widget.description,
        ),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _openComments() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CommentsPage(originalPostUsername: widget.username),
      ),
    );
  }

  Future<void> _downloadVideo() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting Download...'),
        backgroundColor: NeoTheme.green,
      ),
    );

    // Request storage permissions
    if (Platform.isAndroid) {
      await Permission.manageExternalStorage.request();
    }

    try {
      final Directory? downloadsDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (downloadsDir != null) {
        final savedDir = downloadsDir.path;
        final fileName = widget.videoUrl.split('/').last.split('?').first;
        final path = '$savedDir/$fileName';

        final downloadedVideoRepository = ref.read(
          downloadedVideosRepositoryProvider,
        );

        final file = await downloadedVideoRepository.getVideoByPath(path);

        if (file != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video already downloaded!'),
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
        } else {
          await FlutterDownloader.enqueue(
            url: widget.videoUrl,
            savedDir: savedDir,
            fileName: fileName,
            saveInPublicStorage: false,
            showNotification: true,
            openFileFromNotification: true,
          );
          await downloadedVideoRepository.saveOfflineVideos(
            filePath: path,
            title: widget.description,
            thumbnailUrl: '',
            videoUrl: widget.videoUrl,
            author: widget.username,
          );
        }
      }
    } catch (e, st) {
      log('Download error: $e', stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: NeoTheme.boxDecoration(
        color: NeoTheme.white,
        borderRadius: NeoTheme.radiusMain,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (User info)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: NeoTheme.yellow,
                    border: Border.all(
                      color: NeoTheme.black,
                      width: NeoTheme.borderThick,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.username.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (widget.isProfileView)
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: NeoTheme.black,
                    ),
                    onSelected: (value) {
                      if (value == 'hide') {
                        widget.onHide?.call();
                      } else if (value == 'delete') {
                        widget.onDelete?.call();
                      }
                    },
                    color: Colors.white,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'hide',
                            child: Text(
                              'Hide Post',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(
                              'Delete Post',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                  ),
              ],
            ),
          ),

          // Video Player Area
          GestureDetector(
            onTap: _openVideo,
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: NeoTheme.black.withAlpha(
                  26,
                ), // Background color for video area
                border: const Border.symmetric(
                  horizontal: BorderSide(
                    color: NeoTheme.black,
                    width: NeoTheme.borderThick,
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://example.com/video_thumbnail.jpg',
                    color: Colors.black26,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: NeoTheme.black.withAlpha(10));
                    },
                  ),

                  // Play Overlay Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NeoTheme.pink,
                      border: Border.all(
                        color: NeoTheme.black,
                        width: NeoTheme.borderThick,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: NeoTheme.black, offset: Offset(3, 3)),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: NeoTheme.black,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Actions Area (Like, Comment)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Like Button
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isLiked ? NeoTheme.pink : NeoTheme.white,
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: NeoTheme.black,
                              size: 24,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'LIKE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Comment Button
                    GestureDetector(
                      onTap: _openComments,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NeoTheme.blue,
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: NeoTheme.black,
                              size: 24,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'COMMENT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Download Button
                    GestureDetector(
                      onTap: _downloadVideo,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NeoTheme.green,
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.download_rounded,
                              color: NeoTheme.black,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
