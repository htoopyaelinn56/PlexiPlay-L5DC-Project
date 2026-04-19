import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:plexi_play/local_db/downloaded_videos.dart';
import 'package:plexi_play/local_db/isar_provider.dart';

class DownloadedVideosRepository {
  final Isar isar;

  DownloadedVideosRepository({required this.isar});

  Future<void> saveOfflineVideos({
    required String filePath,
    required String title,
    required String thumbnailUrl,
    required String videoUrl,
    required String author,
    required String videoId,
  }) async {
    await isar.writeAsync((isar) {
      final newVideo = DownloadedVideos(
        id: isar.downloadedVideos.autoIncrement(),
        filePath: filePath,
        title: title,
        thumbnailUrl: thumbnailUrl,
        videoUrl: videoUrl,
        author: author,
        videoId: videoId,
      );
      isar.downloadedVideos.put(newVideo);
    });
  }

  Stream<List<DownloadedVideos>> getOfflineVideos() async* {
    final videosStream = isar.downloadedVideos.where().watch(
      fireImmediately: true,
    );
    yield* videosStream;
  }

  Future<DownloadedVideos?> getVideoByPath(String filePath) async {
    final result = await isar.downloadedVideos
        .where()
        .filePathEqualTo(filePath)
        .findFirstAsync();
    return result;
  }
}

final downloadedVideosRepositoryProvider = Provider((ref) {
  final isar = ref.watch(isarProvider);
  return DownloadedVideosRepository(isar: isar);
});

final downloadedVideosStreamProvider = StreamProvider((ref) {
  final repository = ref.watch(downloadedVideosRepositoryProvider);
  return repository.getOfflineVideos();
});
