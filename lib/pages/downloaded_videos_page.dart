import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:plexi_play/local_db/downloaded_videos.dart';
import 'package:plexi_play/local_db/downloaded_videos_repository.dart';
import 'package:plexi_play/pages/video_player_page.dart';
import 'package:plexi_play/theme/neo_theme.dart';
import 'package:plexi_play/widgets/neo_back_button.dart';

class DownloadedVideosPage extends ConsumerWidget {
  const DownloadedVideosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsyncValue = ref.watch(downloadedVideosStreamProvider);

    return Scaffold(
      backgroundColor: NeoTheme.cream,
      appBar: AppBar(
        leading: Row(
          children: [const SizedBox(width: 20), const NeoBackButton()],
        ),
        leadingWidth: 64,
        title: const Text(
          'Downloads',
          style: TextStyle(
            color: NeoTheme.black,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        backgroundColor: NeoTheme.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeoTheme.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: NeoTheme.black, height: 3),
        ),
      ),
      body: videosAsyncValue.when(
        data: (videos) {
          if (videos.isEmpty) {
            return const Center(
              child: Text(
                'No downloaded videos yet.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: NeoTheme.black,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];

              return GestureDetector(
                onTap: () {
                  navigateToPlayer(video, context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: NeoTheme.boxDecoration(color: NeoTheme.yellow),
                  child: ListTile(
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: NeoTheme.black, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: NeoTheme.white,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    title: Text(
                      video.title.isEmpty ? 'Untitled Video' : video.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: NeoTheme.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      video.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: NeoTheme.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedPlayCircle,
                        secondaryColor: Colors.blue,
                        strokeWidth: 2,
                        size: 32,
                      ),
                      onPressed: () async {
                        navigateToPlayer(video, context);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: NeoTheme.black),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading downloads:\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void navigateToPlayer(DownloadedVideos video, BuildContext context) {
    final localFilePath = video.filePath;
    final exists = File(localFilePath).existsSync();
    log('Checking file at $localFilePath: exists=$exists');
    if (exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            videoUrl: localFilePath,
            isLocalFile: true,
            username: video.author,
            description: video.title,
            videoId: video.videoId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video file not found'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
