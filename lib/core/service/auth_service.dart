import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseClient get supabase => _supabase;
  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Google Login
  Future<void> signInWithGoogle(String redirectUri) async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUri,
      scopes: 'email profile',
    );
  }

  // Facebook Login
  Future<void> signInWithFacebook(String redirectUri) async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: redirectUri,
      scopes: 'email,public_profile',
      queryParams: {'display': 'popup'},
    );
  }

  // Email Sign Up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String redirectUri,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: redirectUri,
    );
  }

  // Email Sign In
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Change Password
  Future<void> changePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Delete Account
  Future<void> deleteAccount() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null && kDebugMode) log('No user logged in');

    // Delete user from auth (cascade delete profiles and saved_videos)
    await _supabase.rpc<void>('delete_user');
  }

  // Check if user is email provider
  bool isEmailProvider() {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final provider = user.appMetadata['provider'] == 'email';

    final providersData = user.appMetadata['providers'];
    final providers = providersData is List && providersData.contains('email');

    return provider || providers;
  }

  // Check if user is Google provider
  bool isGoogleProvider() {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final provider = user.appMetadata['provider'] == 'google';

    final providersData = user.appMetadata['providers'];
    final providers = providersData is List && providersData.contains('google');

    return provider || providers;
  }

  // Check if user is Facebook provider
  bool isFacebookProvider() {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final provider = user.appMetadata['provider'] == 'facebook';

    final providersData = user.appMetadata['providers'];
    final providers =
        providersData is List && providersData.contains('facebook');

    return provider || providers;
  }
}
