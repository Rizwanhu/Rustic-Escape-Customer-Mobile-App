//auth_service.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seproject/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  final SupabaseService supabaseService;

  AuthService(this.supabaseService);

  Future<void> logout() async {
    await supabaseService.client.auth.signOut();
  }
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  final SupabaseClient _client = Supabase.instance.client;

  bool get isLoggedIn => _client.auth.currentUser != null;

  SupabaseClient get client => _client;

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _client.auth.signOut();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('User cancelled Google sign-in');
        return;
      }

      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception('Missing Google ID token');

      final result = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      if (result.user != null) {
        print('✅ Google sign-in successful');
        notifyListeners();
      } else {
        print('❌ Supabase sign-in failed');
      }
    } catch (e) {
      print('🔴 Error during Google sign-in: $e');
      rethrow;
    }
  }
}