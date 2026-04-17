import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/neo_theme.dart';
import '../widgets/post_card.dart';
import 'upload_page.dart';
import 'profile_page.dart';
import 'downloaded_videos_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoTheme.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: NeoTheme.black, width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: NeoTheme.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'PlexiPlay',
              style: TextStyle(
                color: NeoTheme.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedBookDownload,
              color: NeoTheme.black,
              strokeWidth: 2,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadedVideosPage(),
                ),
              );
            },
            tooltip: 'Downloads',
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUserAccount,
              color: NeoTheme.black,
              strokeWidth: 2,
            ),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfilePage(username: 'Me (Demo User)'),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: NeoTheme.black, height: 3),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCard(
                videoUrl:
                    'https://wbeifzoolcvpmsmgnskm.supabase.co/storage/v1/object/public/videos/2026-04-14-16-13-22-622.mp4',
                username: 'User_${index + 1}',
                description:
                    'Check out this cool bee hovering around! Nature is always incredible. 🐝🌿 #Nature #NeoBrutalism',
              ),
              childCount: 5,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 120), // Extra space at the bottom
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPage()),
          );
        },
        backgroundColor: NeoTheme.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: NeoTheme.black,
            width: NeoTheme.borderThick,
          ),
        ),
        elevation: 0,
        highlightElevation: 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add_rounded, color: NeoTheme.black, size: 32),
        ),
      ),
    );
  }
}
