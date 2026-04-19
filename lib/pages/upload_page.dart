import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plexi_play/main.dart';
import 'package:plexi_play/supabase/video_upload_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../supabase/videos.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_text_field.dart';
import '../widgets/neo_back_button.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key, this.video});

  // for editing, but just title
  final Videos? video;

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
    if (widget.video != null) {
      _descriptionController.text = widget.video!.title;
    }
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
    if (widget.video != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot edit the video. Please only edit the caption.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
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
    final uuid = const Uuid().v4();
    final fileName = '${uuid}_${file.path.split('/').last}';

    final storageUrl = '$supabaseUrl/storage/v1/object/$folder/$fileName';
    final accessToken = supabase.auth.currentSession?.accessToken ?? '';
    final anonKey = supabaseAnonKey;

    final dio = Dio();

    final response = await dio.post(
      storageUrl,
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      }),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'apikey': anonKey,
          'x-upsert': 'true',
        },
      ),
      onSendProgress: (sent, total) {
        if (total > 0) {
          if (folder == 'videos') {
            setState(() {
              uploadStatus =
                  'Uploading video... ${(sent / total * 100).toStringAsFixed(0)}%';
            });
          } else {
            setState(() {
              uploadStatus =
                  'Uploading thumbnail... ${(sent / total * 100).toStringAsFixed(0)}%';
            });
          }
        }
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return '$supabaseUrl/storage/v1/object/public/$folder/$fileName';
    } else {
      throw Exception('Upload failed: ${response.statusCode}');
    }
  }

  Future<void> _pickThumbnail() async {
    if (widget.video != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot edit the image. Please only edit the caption.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
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
        _selectedVideo!,
        'videos',
      );

      ref
          .read(videoUploadControllerProvider.notifier)
          .uploadVideo(
            title: _descriptionController.text.trim(),
            thumbnailUrl: uploadedThumbnailUrl,
            videoUrl: uploadedVideoUrl,
          );
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

  Future<void> _editVideo() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a caption.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref
        .read(videoUploadControllerProvider.notifier)
        .editVideo(
          id: widget.video!.id,
          title: _descriptionController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.video != null;
    ref.listen(videoUploadControllerProvider, (prev, next) {
      if (next.isLoading) {
        setState(() {
          uploadStatus = isEdit ? 'Editing...' : 'Uploading...';
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
            SnackBar(
              content: Text(
                'Video ${isEdit ? 'edited' : 'uploaded'} successfully!',
              ),
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
          children: [
            const SizedBox(width: 20),
            NeoBackButton(
              onTap: () {
                if (uploadStatus != null) {
                  // Prevent navigating back while upload is in progress
                  // show 'Please wait for the upload to finish' message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please wait for the upload to finish.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        leadingWidth: 64,
        backgroundColor: NeoTheme.white,
        centerTitle: false,
        title: Text(
          isEdit ? 'EDIT POST' : 'NEW POST',
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
                          color: _selectedVideo != null || isEdit
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
                                _selectedVideo != null || isEdit
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
                          color: _selectedThumbnail != null || isEdit
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
                                _selectedThumbnail != null || isEdit
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
                text: uploadStatus ?? (isEdit ? 'EDIT' : 'UPLOAD'),
                backgroundColor: NeoTheme.pink,
                onPressed: isEdit ? _editVideo : _uploadVideo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
