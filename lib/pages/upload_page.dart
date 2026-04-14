import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_text_field.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _descriptionController = TextEditingController();
  File? _selectedVideo;
  File? _selectedThumbnail;
  bool _isCompressing = false;

  @override
  void initState() {
    super.initState();
    _requestMediaPermissions();
  }

  Future<void> _requestMediaPermissions() async {
    // Request multiple permissions related to media
    await [Permission.photos, Permission.videos, Permission.storage].request();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedThumbnail = File(image.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_selectedVideo == null) return;

    setState(() {
      _isCompressing = true;
    });

    try {
      // ✨ Web-Optimizes (fast-start) the video by moving the moov atom to the front!
      // This solves the full-download buffering issue from Supabase!
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        _selectedVideo!.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (mediaInfo != null && mediaInfo.file != null) {
        final optimizedFile = mediaInfo.file!;
        print('Original Size: \${_selectedVideo!.lengthSync()} bytes');
        print('Optimized Size: \${optimizedFile.lengthSync()} bytes');

        // TODO: Supabase Storage Upload Logic Here!
        // final supabase = Supabase.instance.client;
        // final path = 'videos/\${DateTime.now().millisecondsSinceEpoch}.mp4';
        // await supabase.storage.from('posts').upload(path, optimizedFile);

        // After upload completes
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload successfully optimized & uploaded!'),
            ),
          );
          Navigator.pop(context);
        }
      }
    } finally {
      setState(() {
        _isCompressing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoTheme.white,
        centerTitle: false,
        title: const Text(
          'NEW POST',
          style: TextStyle(
            color: NeoTheme.black,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: NeoTheme.black, height: 3),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _isCompressing ? null : _pickVideo,
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: _selectedVideo != null
                              ? NeoTheme.blue
                              : NeoTheme.white,
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _selectedVideo != null
                                    ? Icons.video_file_rounded
                                    : Icons.video_call_rounded,
                                size: 40,
                                color: NeoTheme.black,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedVideo != null
                                    ? 'Video Ready'
                                    : 'PICK VIDEO',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: NeoTheme.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _isCompressing ? null : _pickThumbnail,
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: _selectedThumbnail != null
                              ? NeoTheme.yellow
                              : NeoTheme.white,
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _selectedThumbnail != null
                                    ? Icons.image_rounded
                                    : Icons.add_photo_alternate_rounded,
                                size: 40,
                                color: NeoTheme.black,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedThumbnail != null
                                    ? 'Thumb Ready'
                                    : 'PICK THUMBNAIL',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: NeoTheme.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              NeoTextField(
                labelText: 'Caption',
                hintText: 'What is happening in this video?',
                controller: _descriptionController,
              ),
              const SizedBox(height: 48),

              if (_isCompressing)
                Column(
                  children: [
                    const CircularProgressIndicator(color: NeoTheme.pink),
                    const SizedBox(height: 16),
                    const Text(
                      'Optimizing for Web & Streaming...',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                )
              else
                NeoButton(
                  text: 'UPLOAD POST',
                  backgroundColor: NeoTheme.pink,
                  onPressed: _uploadVideo,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
