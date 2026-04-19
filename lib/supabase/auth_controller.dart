import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/auth_exception.dart';
import 'package:plexi_play/supabase/auth_state_controller.dart';
import 'package:plexi_play/supabase/supabase_service.dart';

class AuthController extends AsyncNotifier<void> {
  @override
  build() {}

  void signUpOrLogin({
    required String email,
    required String password,
    required String username,
    required bool isLogin,
  }) async {
    state = const AsyncLoading();
    try {
      final supabaseService = ref.read(supabaseServiceProvider);

      if (isLogin) {
        await supabaseService.login(email: email, password: password);
      } else {
        await supabaseService.signUp(
          email: email,
          password: password,
          username: username,
        );
      }

      ref
          .read(authStateControllerProvider.notifier)
          .updateUserId(SupabaseService.supabaseClient.auth.currentUser?.id);

      state = const AsyncData(null);
    } catch (e, st) {
      log('Error during sign up: $e, ${e.runtimeType}');
      if (e is AuthException) {
        state = AsyncError(e.message, st);
      } else {
        state = AsyncError('Something went wrong', st);
      }
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      await supabaseService.signOut();
      ref.read(authStateControllerProvider.notifier).updateUserId(null);
      state = const AsyncData(null);
    } catch (e, st) {
      log('Error during sign out: $e, ${e.runtimeType}');
      state = AsyncError('Something went wrong with logging out', st);
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});
