import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class NoteController extends AsyncNotifier<void> {
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

  void editNote({
    required int noteId,
    required String note,
    required String videoId,
  }) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncLoading();
      await supabaseService.editNote(noteId: noteId, note: note);
      ref.invalidate(notesStreamProvider(videoId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void deleteNote({required int noteId, required String videoId}) async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      state = const AsyncLoading();
      await supabaseService.deleteNote(noteId: noteId);
      ref.invalidate(notesStreamProvider(videoId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final noteControllerProvider = AsyncNotifierProvider<NoteController, void>(
  () => NoteController(),
);
