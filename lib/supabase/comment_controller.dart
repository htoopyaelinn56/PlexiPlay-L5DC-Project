import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/custom_exception.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class CommentController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  void addComment({required String videoId, required String comment}) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncLoading();
      await supabaseService.addComment(videoId: videoId, comment: comment);
      ref.invalidate(commentsStreamProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      if (e is CustomException) {
        state = AsyncError(e.message, st);
        return;
      }
      state = AsyncError(e, st);
    }
  }
}

final commentControllerProvider =
    AsyncNotifierProvider<CommentController, void>(() => CommentController());
