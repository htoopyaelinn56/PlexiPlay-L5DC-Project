import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/post_card.dart';

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: NeoTheme.black, height: 3),
        ),
      ),
      body: ListView.builder(
        itemCount: 5, // Just to show a few dummy posts
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        itemBuilder: (context, index) {
          // Switch to an HLS streaming URL which plays instantly while downloading chunks
          return PostCard(
            videoUrl:
                'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
            username: 'User_${index + 1}',
            description:
                'Check out this cool bee hovering around! Nature is always incredible. 🐝🌿 #Nature #NeoBrutalism',
          );
        },
      ),
    );
  }
}
