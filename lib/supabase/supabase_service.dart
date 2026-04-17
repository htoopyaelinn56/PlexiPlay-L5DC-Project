import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabaseClient = Supabase.instance.client;

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<void> login({required String email, required String password}) async {}

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    throw AuthException('Sign up not implemented yet');
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());
