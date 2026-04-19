import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class NoteCreateController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  void createNote({
    required String videoId,
    required String note,
    required String timestamp,
  }) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncLoading();
      await supabaseService.addNotes(
        videoId: videoId,
        note: note,
        timestamp: timestamp,
      );
      ref.invalidate(notesStreamProvider(videoId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final noteCreateControllerProvider =
    AsyncNotifierProvider<NoteCreateController, void>(
      () => NoteCreateController(),
    );
