import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateController extends Notifier<String?> {
  @override
  build() {
    return null;
  }

  void updateUserId(String? userId) {
    state = userId;
  }
}

final authStateControllerProvider =
    NotifierProvider<AuthStateController, String?>(() {
      return AuthStateController();
    });
