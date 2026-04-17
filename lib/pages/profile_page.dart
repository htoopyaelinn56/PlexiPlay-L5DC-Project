import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/neo_theme.dart';
import '../widgets/post_card.dart';
import '../widgets/neo_back_button.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy profile posts
  final List<Map<String, String>> _myPosts = [
    {
      'videoUrl':
          'https://wbeifzoolcvpmsmgnskm.supabase.co/storage/v1/object/public/videos/2026-04-14-16-13-22-622.mp4',
      'username': 'MyUsername',
      'description': 'This is my first test video on PlexiPlay! 🚀',
    },
    {
      'videoUrl':
          'https://wbeifzoolcvpmsmgnskm.supabase.co/storage/v1/object/public/videos/2026-04-14-16-13-22-622.mp4',
      'username': 'MyUsername',
      'description': 'Exploring Neo-brutalism vibes with this awesome player.',
    },
  ];

  void _handleLogout() {
    // Navigate back to logic, clearing the stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _deletePost(int index) {
    setState(() {
      _myPosts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post deleted!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _hidePost(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post hidden from your profile.'),
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.white,
      appBar: AppBar(
        leading: Row(
          children: [const SizedBox(width: 20), const NeoBackButton()],
        ),
        leadingWidth: 64,
        title: Text(
          widget.username,
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
      body: _myPosts.isEmpty
          ? const Center(
              child: Text(
                'No videos yet!',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 40),
              itemCount: _myPosts.length,
              itemBuilder: (context, index) {
                final post = _myPosts[index];
                return PostCard(
                  videoUrl: post['videoUrl']!,
                  username: post['username']!,
                  description: post['description']!,
                  isProfileView: true,
                  onDelete: () => _deletePost(index),
                  onHide: () => _hidePost(index),
                );
              },
            ),
    );
  }
}
