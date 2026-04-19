import 'package:plexi_play/exceptions/custom_exception.dart';

class VideoUploadException implements CustomException {
  VideoUploadException(this.message);

  @override
  final String message;
}