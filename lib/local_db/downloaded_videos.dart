import 'package:isar_plus/isar_plus.dart';

part 'downloaded_videos.g.dart';

@collection
class DownloadedVideos {
  final int id;

  final String filePath;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String author;

  // supabase uuid
  final String videoId;

  DownloadedVideos({
    required this.id,
    required this.filePath,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.author,
    required this.videoId,
  });
}
