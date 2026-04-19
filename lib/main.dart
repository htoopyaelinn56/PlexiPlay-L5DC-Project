import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plexi_play/local_db/downloaded_videos.dart';
import 'package:plexi_play/local_db/isar_provider.dart';
import 'package:plexi_play/pages/feed_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';

const supabaseUrl = 'https://buxwwrqglfqvdncxhgcp.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1eHd3cnFnbGZxdmRuY3hoZ2NwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1Mzc0MjMsImV4cCI6MjA5MjExMzQyM30.mQUlr1kuEukeNMndy_HYgwkUrlAB1R6-_CjkXog3gbM';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialze Supabase
  // url and anonKey should be gitignore,
  // but since this is for university project, I'm hardcoding them here for simplicity
  Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Initialize Flutter Downloader
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.openAsync(
    schemas: [DownloadedVideosSchema],
    directory: dir.path,
  );

  final container = ProviderContainer(
    overrides: [isarProvider.overrideWithValue(isar)],
  );

  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  User? currentUser;

  void getAuthState() {
    final supabaseClient = Supabase.instance.client;
    setState(() {
      currentUser = supabaseClient.auth.currentUser;
    });
    log(
      'User exists: ${currentUser != null}, going to ${currentUser == null ? 'LoginPage' : 'FeedPage'}',
    );
  }

  @override
  void initState() {
    super.initState();
    getAuthState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlexiPlay',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF6E9),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: currentUser == null ? const LoginPage() : const FeedPage(),
    );
  }
}
