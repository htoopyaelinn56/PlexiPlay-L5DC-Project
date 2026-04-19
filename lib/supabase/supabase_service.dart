import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/auth_exception.dart' as ae;
import 'package:plexi_play/exceptions/video_upload_expection.dart';
import 'package:plexi_play/supabase/auth_state_controller.dart';
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

  Stream<List<Videos>> getVideos(bool forProfile) {
    final userId = supabaseClient.auth.currentUser?.id;
    // Unique name per stream instance — avoids collision
    final channelName =
        'videos_${forProfile ? 'profile_${userId ?? 'anon'}' : 'all'}_${DateTime.now().millisecondsSinceEpoch}';

    late StreamController<List<Videos>> controller;
    sb.RealtimeChannel? channel;

    Future<void> fetchVideos() async {
      try {
        var query = supabaseClient
            .from('videos')
            .select('*, profiles(username)');

        if (forProfile && userId != null) {
          query = query.eq('created_by', userId);
        }

        final response = await query.order('created_at', ascending: false);

        if (!controller.isClosed) {
          controller.add(
            (response as List<dynamic>).map((video) {
              return Videos(
                id: video['id'] as String,
                username: video['profiles']['username'] as String? ?? 'Unknown',
                createdAt: DateTime.parse(
                  video['created_at'] as String,
                ).toLocal(),
                title: video['title'] as String? ?? '',
                thumbnailUrl: video['thumbnail_url'] as String? ?? '',
                videoUrl: video['video_url'] as String? ?? '',
              );
            }).toList(),
          );
        }
      } catch (e) {
        log('Error fetching videos: $e');
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    controller = StreamController<List<Videos>>(
      onListen: () async {
        await fetchVideos();

        channel = supabaseClient
            .channel(channelName)
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.all,
              schema: 'public',
              table: 'videos',
              callback: (payload) {
                log('🔥 [$channelName] event: ${payload.eventType}');
                fetchVideos();
              },
            )
            .subscribe((status, [error]) {
              log('📶 [$channelName] status: $status');
              if (error != null) log('❌ [$channelName] error: $error');
            });
      },
      onCancel: () async {
        log('🧹 Removing channel: $channelName');
        if (channel != null) {
          await supabaseClient.removeChannel(channel!);
        }
        await controller.close();
      },
    );

    return controller.stream;
  }

  Future<void> uploadVideo({
    required String title,
    required String thumbnailUrl,
    required String videoUrl,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      await supabaseClient.from('videos').insert({
        'title': title,
        'thumbnail_url':
            'https://buxwwrqglfqvdncxhgcp.supabase.co/storage/v1/object/public/$thumbnailUrl',
        'video_url':
            'https://buxwwrqglfqvdncxhgcp.supabase.co/storage/v1/object/public/$videoUrl',
        'created_by': userId,
      });
    } catch (e) {
      log('Error uploading video: $e');
      throw VideoUploadException('Failed to upload video. Please try again.');
    }
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());

final videosStreamProvider = StreamProvider<List<Videos>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  ref.watch(
    authStateControllerProvider,
  ); // Watch userId to trigger refresh when it changes
  return supabaseService.getVideos(false);
});

final profileVideosStreamProvider = StreamProvider<List<Videos>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  ref.watch(
    authStateControllerProvider,
  ); // Watch userId to trigger refresh when it changes
  return supabaseService.getVideos(true);
});
