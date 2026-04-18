import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/auth_exception.dart' as ae;
import 'package:plexi_play/supabase/videos.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class SupabaseService {
  static final supabaseClient = sb.Supabase.instance.client;

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userData = supabaseClient.auth.currentUser;
      log(
        'User data after login: ${userData?.email}, ${userData?.id}, ${userData?.userMetadata}',
      );
    } on sb.AuthException catch (e) {
      throw ae.AuthException(e.message);
    } catch (e) {
      throw ae.AuthException('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      final userData = supabaseClient.auth.currentUser;
      log(
        'User data after sign up: ${userData?.email}, ${userData?.id}, ${userData?.userMetadata}',
      );
    } on sb.AuthException catch (e) {
      throw ae.AuthException(e.message);
    } catch (e) {
      throw ae.AuthException('An unexpected error occurred. Please try again.');
    }
  }

  Stream<List<Videos>> getVideos() async* {
    // Listen to changes on the videos table
    final stream = supabaseClient.from('videos').stream(primaryKey: ['id']);

    // Yield the joined data every time there's an update
    await for (final _ in stream) {
      final response = await supabaseClient
          .from('videos')
          .select('*, profiles(username)')
          .order('created_at', ascending: false);

      yield (response as List<dynamic>).map((video) {
        return Videos(
          id: video['id'] as String,
          username: video['profiles']['username'] as String? ?? 'Unknown',
          createdAt: DateTime.parse(video['created_at'] as String).toLocal(),
          title: video['title'] as String? ?? '',
          thumbnailUrl: video['thumbnail_url'] as String? ?? '',
          videoUrl: video['video_url'] as String? ?? '',
        );
      }).toList();
    }
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());

final videosStreamProvider = StreamProvider<List<Videos>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.getVideos();
});
