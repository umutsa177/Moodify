import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/service/auth_service.dart';
import 'package:moodify/core/service/profile_service.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/auth_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
    ProfileService? profileService,
  }) : _authService = authService ?? AuthService(),
       _profileService = profileService ?? ProfileService() {
    _initializeAuth();
  }

  final AuthService _authService;
  final ProfileService _profileService;

  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _errorMessage;
  UserProfile? _userProfile;

  // Getters
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  UserProfile? get userProfile => _userProfile;
  bool get isGoogleLoading => _status == AuthStatus.isGoogleLoading;
  bool get isFacebookLoading => _status == AuthStatus.isFacebookLoading;
  bool get isEmailLoading => _status == AuthStatus.isEmailLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Initialize auth listener
  void _initializeAuth() {
    _authService.authStateChanges.listen(_handleAuthStateChange);

    final session = _authService.currentSession;
    if (session != null) {
      _currentUser = session.user;
      _status = AuthStatus.authenticated;
      unawaited(_loadUserProfile());
    } else {
      _status = AuthStatus.unauthenticated;
    }
  }

  // Handle auth state changes
  Future<void> _handleAuthStateChange(AuthState data) async {
    final event = data.event;
    final session = data.session;
    if (session != null && event == AuthChangeEvent.signedIn) {
      _currentUser = session.user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;

      // Load profile
      await _loadUserProfile();

      // If there is no profile, create a new one
      if (_userProfile == null) {
        await _createInitialProfile();
      }
      notifyListeners();
    } else if (event == AuthChangeEvent.signedOut) {
      _currentUser = null;
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Load user profile
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      // First upload user profile
      _userProfile = await _profileService.loadProfile(
        _currentUser!.id,
        _currentUser!.email!,
      );

      // If not exist, create a new one
      if (_userProfile == null) {
        await _createInitialProfile();
      }

      if (kDebugMode) log('Profile loaded: ${_userProfile?.toJson()}');
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) log('Error loading profile: $e');
    }
  }

  // Create initial profile
  Future<void> _createInitialProfile() async {
    if (_currentUser == null) return;

    try {
      if (kDebugMode) log('User metadata: ${_currentUser!.userMetadata}');

      final metadata = _profileService.extractMetadata(
        _currentUser!.userMetadata,
        _currentUser,
      );

      _userProfile = await _profileService.createProfile(
        userId: _currentUser!.id,
        email: _currentUser!.email!,
        username: metadata['username'],
        avatarUrl: metadata['avatarUrl'],
      );
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) log('Error creating profile: $e');
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? username,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return false;
    try {
      await _profileService.updateProfile(
        userId: _currentUser!.id,
        username: username,
        avatarUrl: avatarUrl,
      );
      // Reload profile
      await refreshProfile();
      return true;
    } on Exception catch (e) {
      if (kDebugMode) log('Error updating profile: $e');
      return false;
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    await _executeAuth(
      AuthStatus.isGoogleLoading,
      () => _authService.signInWithGoogle(StringConstant.supabaseRedirectUri),
    );
  }

  // Facebook Sign In
  Future<void> signInWithFacebook() async {
    await _executeAuth(
      AuthStatus.isFacebookLoading,
      () => _authService.signInWithFacebook(StringConstant.supabaseRedirectUri),
    );
  }

  // Email Sign Up
  Future<void> signUpWithEmail(String email, String password) async {
    await _executeAuth(
      AuthStatus.isEmailLoading,
      () => _authService.signUpWithEmail(
        email: email,
        password: password,
        redirectUri: StringConstant.supabaseRedirectUri,
      ),
    );
  }

  // Email Sign In
  Future<void> signInWithEmail(String email, String password) async {
    await _executeAuth(
      AuthStatus.isEmailLoading,
      () => _authService.signInWithEmail(email: email, password: password),
    );
  }

  // Change Password
  Future<bool> changePassword(String newPassword) async {
    try {
      await _authService.changePassword(newPassword);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) log('Error changing password: $e');
      _errorMessage = 'Password change failed';
      notifyListeners();
      return false;
    }
  }

  // Delete Account
  Future<bool> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      _currentUser = null;
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      if (kDebugMode) log('Error deleting account: $e');
      _errorMessage = 'Account deletion failed';
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      _userProfile = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    } on Exception catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'An error occurred while signing out';
      notifyListeners();
    }
  }

  // Upload avatar
  Future<bool> uploadAvatar(File imageFile) async {
    if (_currentUser == null) return false;

    try {
      // Upload photo
      final avatarUrl = await _profileService.uploadAvatar(
        userId: _currentUser!.id,
        imageFile: imageFile,
      );

      if (kDebugMode) log('Avatar uploaded successfully: $avatarUrl');

      // Update profile
      await _profileService.updateProfile(
        userId: _currentUser!.id,
        avatarUrl: avatarUrl,
      );

      if (kDebugMode) log('Profile updated in database');

      // Add delaying
      await Future.delayed(const Duration(milliseconds: 800), () {});

      // Fetch updated profile
      _userProfile = await _profileService.loadProfile(
        _currentUser!.id,
        _currentUser!.email!,
      );

      if (kDebugMode) {
        log('Profile reloaded: avatarUrl=${_userProfile?.avatarUrl}');
        log('Profile updatedAt: ${_userProfile?.updatedAt}');
      }

      notifyListeners();

      return true;
    } on Exception catch (e) {
      if (kDebugMode) log('Error uploading avatar: $e');
      return false;
    }
  }

  // Delete avatar
  Future<bool> deleteAvatar() async {
    if (_currentUser == null) return false;

    try {
      await _profileService.deleteAvatar(_currentUser!.id);

      await _profileService.updateProfile(
        userId: _currentUser!.id,
        clearAvatar: true,
      );

      // Fetch updated profile from database
      await _loadUserProfile();
      return true;
    } on Exception catch (e) {
      if (kDebugMode) log('Error deleting avatar: $e');
      return false;
    }
  }

  Future<void> refreshProfile() async {
    if (_currentUser == null) return;
    try {
      _userProfile = await _profileService.loadProfile(
        _currentUser!.id,
        _currentUser!.email!,
      );
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) log('Error refreshing profile: $e');
    }
  }

  // Check if email provider
  bool isEmailProvider() => _authService.isEmailProvider();

  // Check if google provider
  bool isGoogleProvider() => _authService.isGoogleProvider();

  // Check if facebook provider
  bool isFacebookProvider() => _authService.isFacebookProvider();

  // Execute auth operation
  Future<void> _executeAuth(
    AuthStatus loadingStatus,
    Future<void> Function() operation,
  ) async {
    try {
      _status = loadingStatus;
      _errorMessage = null;
      notifyListeners();

      await operation();
    } on AuthException catch (error) {
      _status = AuthStatus.error;
      if (kDebugMode) log(error.message);
      _errorMessage = _getLocalizedErrorMessage(error.message);
      notifyListeners();
    } on Exception catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'An error occurred. Please try again';
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _currentUser != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Get localized error message
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
