import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:plexi_play/pages/upload_page.dart';
import 'package:plexi_play/supabase/auth_controller.dart';
import 'package:plexi_play/supabase/supabase_service.dart';
import 'package:plexi_play/supabase/video_delete_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/videos.dart';
import '../theme/neo_theme.dart';
import '../widgets/post_card.dart';
import '../widgets/neo_back_button.dart';
import 'login_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late String currentUsername;

  void getAuthState() {
    final supabaseClient = Supabase.instance.client;
    setState(() {
      currentUsername =
          supabaseClient.auth.currentUser?.userMetadata?['username'] ??
          'Profile';
    });
  }

  @override
  void initState() {
    getAuthState();
    super.initState();
  }

  void _handleLogout() {
    ref.read(authControllerProvider.notifier).signOut();
  }

  void _deletePost(String id) {
    ref.read(videoDeleteControllerProvider.notifier).deleteVideo(id);
  }

  void _editPost(Videos video) {
    // navigate to upload page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPage(video: video)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logging out...'),
            backgroundColor: Colors.orangeAccent,
            duration: Duration(seconds: 1),
          ),
        );
      } else if (next.hasValue) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    });

    ref.listen(videoDeleteControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (error, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting video: $error'),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        loading: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Deleting video...'),
              backgroundColor: Colors.orangeAccent,
              duration: Duration(milliseconds: 200),
            ),
          );
        },
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video deleted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        },
      );
    });
    return Scaffold(
      backgroundColor: NeoTheme.white,
      appBar: AppBar(
        leading: Row(
          children: [const SizedBox(width: 20), const NeoBackButton()],
        ),
        leadingWidth: 64,
        title: Text(
          currentUsername,
          style: const TextStyle(
            color: NeoTheme.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: NeoTheme.green,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(color: NeoTheme.black, height: NeoTheme.borderThick),
        ),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedLogout01,
              color: NeoTheme.black,
              strokeWidth: 2,
            ),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: NeoTheme.black,
        onRefresh: () async {
          ref.invalidate(videosStreamProvider);
        },
        child: ref
            .watch(videosStreamProvider(true))
            .when(
              data: (videos) {
                if (videos.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 500,
                        child: Center(
                          child: Text(
                            'No videos yet!',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 8, bottom: 40),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final post = videos[index];
                          return PostCard(
                            video: post,
                            isProfileView: true,
                            onDelete: () => _deletePost(post.id),
                            onEdit: () => _editPost(post),
                          );
                        }, childCount: videos.length),
                      ),
                    ),
                  ],
                );
              },
              loading: () => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: NeoTheme.black),
                    ),
                  ),
                ],
              ),
              error: (error, stack) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: Text(
                        'Error: $error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: NeoTheme.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
