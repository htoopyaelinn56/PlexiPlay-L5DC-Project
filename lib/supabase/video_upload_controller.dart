import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/custom_exception.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class VideoUploadController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> uploadVideo({
    required String title,
    required String thumbnailUrl,
    required String videoUrl,
  }) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncValue.loading();
      await supabaseService.uploadVideo(
        title: title,
        thumbnailUrl: thumbnailUrl,
        videoUrl: videoUrl,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      if (e is CustomException) {
        state = AsyncValue.error(e.message, st);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> editVideo({required String id, required String title}) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncValue.loading();
      await supabaseService.editVideo(id: id, title: title);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      if (e is CustomException) {
        state = AsyncValue.error(e.message, st);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }
}

final videoUploadControllerProvider =
    AsyncNotifierProvider<VideoUploadController, void>(
      () => VideoUploadController(),
    );
