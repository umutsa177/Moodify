import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/auth_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _initializeAuth();
  }

  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isGoogleLoading => _status == AuthStatus.isGoogleLoading;
  bool get isFacebookLoading => _status == AuthStatus.isFacebookLoading;
  bool get isEmailLoading => _status == AuthStatus.isEmailLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  final SupabaseClient _supabase = Supabase.instance.client;

  // Listen to auth status
  void _initializeAuth() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (session != null && event == AuthChangeEvent.signedIn) {
        _currentUser = session.user;
        _status = AuthStatus.authenticated;
        _errorMessage = null;
      } else if (event == AuthChangeEvent.signedOut) {
        _currentUser = null;
        _status = AuthStatus.unauthenticated;
        _errorMessage = null;
      }
      notifyListeners();
    });

    // Check initial auth status
    final session = _supabase.auth.currentSession;
    if (session != null) {
      _currentUser = session.user;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
  }

  // Google Login
  Future<void> signInWithGoogle() async {
    try {
      _status = AuthStatus.isGoogleLoading;
      _errorMessage = null;
      notifyListeners();

      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: StringConstant.supabaseRedirectUri,
        scopes: 'email profile',
      );

      // Auth state change listener otomatik olarak durumu güncelleyecek
    } on AuthException catch (error) {
      _status = AuthStatus.error;
      log(error.message);
      _errorMessage = _getLocalizedErrorMessage(error.message);
      notifyListeners();
    } on Exception catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
      notifyListeners();
    }
  }

  // Facebook login
  Future<void> signInWithFacebook() async {
    try {
      _status = AuthStatus.isFacebookLoading;
      _errorMessage = null;
      notifyListeners();

      await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: StringConstant.supabaseRedirectUri,
        scopes: 'email,public_profile',
        queryParams: {
          'display': 'popup',
        },
      );
    } on AuthException catch (error) {
      _status = AuthStatus.error;
      log(error.message);
      _errorMessage = _getLocalizedErrorMessage(error.message);
      notifyListeners();
    } on Exception catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
      notifyListeners();
    }
  }

  // Email login
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      _status = AuthStatus.isEmailLoading;
      _errorMessage = null;
      notifyListeners();

      await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (error) {
      _status = AuthStatus.error;
      log(error.message);
      _errorMessage = _getLocalizedErrorMessage(error.message);
      notifyListeners();
    } on Exception catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'An error occurred while signing out';
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _currentUser != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Customize error message
  String _getLocalizedErrorMessage(String error) {
    if (error.toLowerCase().contains('invalid')) {
      return 'Invalid credentials. Please try again';
    } else if (error.toLowerCase().contains('network')) {
      return 'Please check your internet connection';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Request timed out. Please try again';
    }
    return 'An error occurred. Please try again';
  }
}
