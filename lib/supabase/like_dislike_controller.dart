import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class LikeDislikeController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  void likeOrDislike({required String videoId, required bool like}) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncValue.loading();
      await supabaseService.likeOrDislike(videoId: videoId, like: like);
      state = const AsyncValue.data(null);
      ref.invalidate(videosStreamProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final likeDislikeControllerProvider =
    AsyncNotifierProvider<LikeDislikeController, void>(
      () => LikeDislikeController(),
    );
