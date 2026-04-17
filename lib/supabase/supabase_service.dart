import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexi_play/exceptions/auth_exception.dart' as ae;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabaseClient = Supabase.instance.client;

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<void> login({required String email, required String password}) async {
    throw ae.AuthException('Login not implemented yet');
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    throw ae.AuthException('Sign up not implemented yet');
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());
