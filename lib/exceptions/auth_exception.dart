import 'package:plexi_play/exceptions/custom_exception.dart';

class AuthException implements CustomException {
  AuthException(this.message);

  @override
  final String message;
}
