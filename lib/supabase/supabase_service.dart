import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabaseClient = Supabase.instance.client;

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<void> loginOrSignUp(String email, String password) async {}
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());
