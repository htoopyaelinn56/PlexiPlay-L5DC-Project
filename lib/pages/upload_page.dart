import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plexi_play/supabase/video_upload_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_text_field.dart';
import '../widgets/neo_back_button.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  final _descriptionController = TextEditingController();
  File? _selectedVideo;
  File? _selectedThumbnail;
  String? uploadStatus;

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
      final tempFile = File(video.path);
      final videoSize = await tempFile.length();
      if (videoSize > 30 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video size must be 30MB or less.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedVideo = tempFile;
      });
    }
  }

  Future<String> _uploadFileToSupabase(File file, String folder) async {
    final supabase = Supabase.instance.client;
    final url = await supabase.storage
        .from(folder)
        .upload(file.path.split('/').last, file);
    return url;
  }

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final tempFile = File(image.path);
      final thumbnailSize = await tempFile.length();
      if (thumbnailSize > 3 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thumbnail size must be 3MB or less.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedThumbnail = tempFile;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_selectedVideo == null ||
        _selectedThumbnail == null ||
        _descriptionController.text.trim().isEmpty) {
      final errorMessage = () {
        if (_selectedVideo == null &&
            _selectedThumbnail == null &&
            _descriptionController.text.trim().isEmpty) {
          return 'Please select a video, a thumbnail, and provide a caption.';
        } else if (_selectedThumbnail == null &&
            _descriptionController.text.trim().isEmpty) {
          return 'Please select a thumbnail and provide a caption.';
        } else if (_selectedVideo == null &&
            _descriptionController.text.trim().isEmpty) {
          return 'Please select a video and provide a caption.';
        } else if (_selectedVideo == null && _selectedThumbnail == null) {
          return 'Please select a video and a thumbnail.';
        } else if (_selectedVideo == null) {
          return 'Please select a video.';
        } else if (_selectedThumbnail == null) {
          return 'Please select a thumbnail.';
        } else {
          return 'Please provide a caption.';
        }
      }();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      setState(() {
        uploadStatus = 'Compressing video...';
      });
      // This solves the full-download buffering issue from Supabase!
      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        _selectedVideo!.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null && compressedVideo.file != null) {
        setState(() {
          uploadStatus = 'Uploading thumbnail...';
        });
        final uploadedThumbnailUrl = await _uploadFileToSupabase(
          _selectedThumbnail!,
          'images',
        );

        setState(() {
          uploadStatus = 'Uploading video...';
        });
        final uploadedVideoUrl = await _uploadFileToSupabase(
          File(compressedVideo.file!.path),
          'videos',
        );

        ref
            .read(videoUploadControllerProvider.notifier)
            .uploadVideo(
              title: _descriptionController.text.trim(),
              thumbnailUrl: uploadedThumbnailUrl,
              videoUrl: uploadedVideoUrl,
            );
      }
    } catch (e, st) {
      log('$e $st', name: 'UploadPage._uploadVideo');
      if (mounted) {
        setState(() {
          uploadStatus = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong during uploading.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(videoUploadControllerProvider, (prev, next) {
      if (next.isLoading) {
        setState(() {
          uploadStatus = 'Uploading...';
        });
      } else if (next.hasError) {
        setState(() {
          uploadStatus = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next.hasValue) {
        if (mounted) {
          setState(() {
            uploadStatus = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    });
    return Scaffold(
      backgroundColor: NeoTheme.cream,
      appBar: AppBar(
        leading: Row(
          children: [const SizedBox(width: 20), const NeoBackButton()],
        ),
        leadingWidth: 64,
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
                      onTap: _pickVideo,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedVideo01,
                                size: 40,
                                color: NeoTheme.black,
                                strokeWidth: 2,
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
                      onTap: _pickThumbnail,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedImage01,
                                size: 40,
                                color: NeoTheme.black,
                                strokeWidth: 2,
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
              NeoButton(
                text: uploadStatus ?? 'UPLOAD',
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
