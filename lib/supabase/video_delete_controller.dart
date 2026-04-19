import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class VideoDeleteController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    throw UnimplementedError();
  }

  Future<void> deleteVideo(String videoId) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncLoading();
      await supabaseService.deletePost(videoId: videoId);
      state = const AsyncData(null);
      ref.invalidate(videosStreamProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final videoDeleteControllerProvider =
    AsyncNotifierProvider<VideoDeleteController, void>(
      () => VideoDeleteController(),
    );
