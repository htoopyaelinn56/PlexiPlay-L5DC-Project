import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class AuthController extends AsyncNotifier<void> {
  @override
  build() {}

  void signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      await supabaseService.signUp(
        email: email,
        password: password,
        username: email,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});
