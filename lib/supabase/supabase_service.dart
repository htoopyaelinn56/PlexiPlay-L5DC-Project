import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/auth_exception.dart' as ae;
import 'package:plexi_play/exceptions/video_upload_expection.dart';
import 'package:plexi_play/supabase/auth_state_controller.dart';
import 'package:plexi_play/supabase/videos.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'comments.dart';
import 'notes.dart';

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
            .select('*, profiles(username), videos_likes(liked_by)');

        if (forProfile && userId != null) {
          query = query.eq('created_by', userId);
        }

        final response = await query.order('created_at', ascending: false);

        if (!controller.isClosed) {
          controller.add(
            (response as List<dynamic>).map((video) {
              final likes =
                  (video['videos_likes'] as List<dynamic>?) ?? const [];
              final likedByCurrentUser =
                  userId != null &&
                  likes.any((like) => like['liked_by'] == userId);

              return Videos(
                id: video['id'] as String,
                username: video['profiles']['username'] as String? ?? 'Unknown',
                createdAt: DateTime.parse(
                  video['created_at'] as String,
                ).toLocal(),
                title: video['title'] as String? ?? '',
                thumbnailUrl: video['thumbnail_url'] as String? ?? '',
                videoUrl: video['video_url'] as String? ?? '',
                likeCount: video['like_count'] as int? ?? 0,
                likedByCurrentUser: likedByCurrentUser,
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
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.all,
              schema: 'public',
              table: 'videos_likes',
              callback: (payload) {
                log('❤️ [$channelName] likes event: ${payload.eventType}');
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
        'thumbnail_url': thumbnailUrl,
        'video_url': videoUrl,
        'created_by': userId,
      });
    } catch (e) {
      log('Error uploading video: $e');
      throw VideoUploadException('Failed to upload video. Please try again.');
    }
  }

  Future<void> editVideo({required String id, required String title}) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      await supabaseClient
          .from('videos')
          .update({'title': title})
          .eq('id', id)
          .eq('created_by', userId);
    } catch (e) {
      log('Error editing video: $e');
      throw VideoUploadException('Failed to edit video. Please try again.');
    }
  }

  Future<void> likeOrDislike({
    required String videoId,
    required bool like,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      if (like) {
        await supabaseClient.from('videos_likes').insert({
          'video_id': videoId,
          'liked_by': userId,
        });
      } else {
        await supabaseClient
            .from('videos_likes')
            .delete()
            .eq('video_id', videoId)
            .eq('liked_by', userId);
      }

      // also get count from like of that video and write to videos like_count column
      final likeCountResponse = await supabaseClient
          .from('videos_likes')
          .count()
          .eq('video_id', videoId);

      final likeCount = likeCountResponse as int? ?? 0;

      // Update the like_count in the videos table
      await supabaseClient
          .from('videos')
          .update({'like_count': likeCount})
          .eq('id', videoId);
    } catch (e) {
      log('Error liking/disliking video: $e');
      throw VideoUploadException(
        'Failed to ${like ? 'like' : 'dislike'} video. Please try again.',
      );
    }
  }

  Stream<List<Comments>> getComments(String videoId) {
    final channelName =
        'comments_video_${videoId}_${DateTime.now().millisecondsSinceEpoch}';

    late StreamController<List<Comments>> controller;
    sb.RealtimeChannel? channel;

    Future<void> fetchComments() async {
      try {
        final response = await supabaseClient
            .from('comments')
            .select('*, profiles(username)')
            .eq('video_id', videoId)
            .order('created_at', ascending: true);

        if (!controller.isClosed) {
          controller.add(
            (response as List<dynamic>).map((comment) {
              return Comments(
                id: comment['id'] as String,
                userId: comment['user_id'] as String,
                username:
                    comment['profiles']['username'] as String? ?? 'Unknown',
                videoId: comment['video_id'] as String,
                comment: comment['comment'] as String,
                createdAt: DateTime.parse(
                  comment['created_at'] as String,
                ).toLocal(),
              );
            }).toList(),
          );
        }
      } catch (e) {
        log('Error fetching comments: $e');
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    controller = StreamController<List<Comments>>(
      onListen: () async {
        await fetchComments();

        channel = supabaseClient
            .channel(channelName)
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.all,
              schema: 'public',
              table: 'comments',
              filter: sb.PostgresChangeFilter(
                type: sb.PostgresChangeFilterType.eq,
                column: 'video_id',
                value: videoId,
              ),
              callback: (payload) {
                log('💬 [$channelName] event: ${payload.eventType}');
                fetchComments();
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

  Future<void> addComment({
    required String videoId,
    required String comment,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      await supabaseClient.from('comments').insert({
        'video_id': videoId,
        'comment': comment,
        'user_id': userId,
      });
    } catch (e) {
      log('Error adding comment: $e');
      throw VideoUploadException('Failed to add comment. Please try again.');
    }
  }

  Future<void> deletePost({required String videoId}) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      // get thumbnail url and video url of that video and delete from storage
      final response = await supabaseClient
          .from('videos')
          .select('thumbnail_url, video_url')
          .eq('id', videoId)
          .eq('created_by', userId)
          .single();

      final thumbnailUrl = response['thumbnail_url'] as String?;
      final videoUrl = response['video_url'] as String?;

      if (thumbnailUrl != null) {
        final thumbnailPath = thumbnailUrl.split('/').last;
        await supabaseClient.storage.from('images').remove([thumbnailPath]);
      }

      if (videoUrl != null) {
        final videoPath = videoUrl.split('/').last;
        await supabaseClient.storage.from('videos').remove([videoPath]);
      }

      await supabaseClient
          .from('videos')
          .delete()
          .eq('id', videoId)
          .eq('created_by', userId);
    } catch (e) {
      log('Error deleting video: $e');
      throw VideoUploadException('Failed to delete video. Please try again.');
    }
  }

  Stream<List<Notes>> getNotesForVideo(String videoId) {
    final channelName =
        'notes_video_${videoId}_${DateTime.now().millisecondsSinceEpoch}';

    late StreamController<List<Notes>> controller;
    sb.RealtimeChannel? channel;

    final userId = supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    Future<void> fetchNotes() async {
      try {
        final response = await supabaseClient
            .from('notes')
            .select('*, profiles(username)')
            .eq('video_id', videoId)
            .eq('created_by', userId)
            .order('created_at', ascending: true);

        if (!controller.isClosed) {
          controller.add(
            (response as List<dynamic>).map((note) {
              return Notes(
                id: note['id'].toString(),
                createdBy: note['created_by'] as String,
                videoId: note['video_id'] as String,
                note: note['note'] as String,
                createdAt: DateTime.parse(
                  note['created_at'] as String,
                ).toLocal(),
                timestamp: note['timestamp'] as String,
              );
            }).toList(),
          );
        }
      } catch (e) {
        log('Error fetching notes: $e');
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    controller = StreamController<List<Notes>>(
      onListen: () async {
        await fetchNotes();

        channel = supabaseClient
            .channel(channelName)
            .onPostgresChanges(
              event: sb.PostgresChangeEvent.all,
              schema: 'public',
              table: 'notes',
              filter: sb.PostgresChangeFilter(
                type: sb.PostgresChangeFilterType.eq,
                column: 'video_id',
                value: videoId,
              ),
              callback: (payload) {
                log('📝 [$channelName] event: ${payload.eventType}');
                fetchNotes();
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

  Future<void> addNotes({
    required String videoId,
    required String note,
    required String timestamp,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      await supabaseClient.from('notes').insert({
        'video_id': videoId,
        'note': note,
        'timestamp': timestamp,
        'created_by': userId,
      });
    } catch (e) {
      log('Error adding note: $e');
      throw VideoUploadException('Failed to add note. Please try again.');
    }
  }

  Future<void> editNote({required int noteId, required String note}) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      await supabaseClient
          .from('notes')
          .update({'note': note})
          .eq('id', noteId)
          .eq('created_by', userId);
    } catch (e) {
      log('Error editing note: $e');
      throw VideoUploadException('Failed to edit note. Please try again.');
    }
  }

  Future<void> deleteNote({required int noteId}) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ae.AuthException('User not authenticated');
    }

    try {
      await supabaseClient
          .from('notes')
          .delete()
          .eq('id', noteId)
          .eq('created_by', userId);
    } catch (e) {
      log('Error deleting note: $e');
      throw VideoUploadException('Failed to delete note. Please try again.');
    }
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());

final videosStreamProvider = StreamProvider.family<List<Videos>, bool>((
  ref,
  forProfile,
) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  ref.watch(
    authStateControllerProvider,
  ); // Watch userId to trigger refresh when it changes
  return supabaseService.getVideos(forProfile);
});

final commentsStreamProvider = StreamProvider.family<List<Comments>, String>((
  ref,
  videoId,
) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  ref.watch(
    authStateControllerProvider,
  ); // Watch userId to trigger refresh when it changes
  return supabaseService.getComments(videoId);
});

final notesStreamProvider = StreamProvider.family<List<Notes>, String>((
  ref,
  videoId,
) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  ref.watch(
    authStateControllerProvider,
  ); // Watch userId to trigger refresh when it changes
  return supabaseService.getNotesForVideo(videoId);
});
