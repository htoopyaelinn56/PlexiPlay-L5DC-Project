import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/auth_exception.dart' as ae;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class SupabaseService {
  static final supabaseClient = sb.Supabase.instance.client;

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userData = supabaseClient.auth.currentUser;
      log(
        'User data after login: ${userData?.email}, ${userData?.id}, ${userData?.userMetadata}',
      );
    } on sb.AuthException catch (e) {
      throw ae.AuthException(e.message);
    } catch (e) {
      throw ae.AuthException('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      final userData = supabaseClient.auth.currentUser;
      log(
        'User data after sign up: ${userData?.email}, ${userData?.id}, ${userData?.userMetadata}',
      );
    } on sb.AuthException catch (e) {
      throw ae.AuthException(e.message);
    } catch (e) {
      throw ae.AuthException('An unexpected error occurred. Please try again.');
    }
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());
