import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/service/auth_service.dart';
import 'package:moodify/core/service/profile_service.dart';
import 'package:moodify/product/enum/auth_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthService, ProfileService, User, Session, File])
void main() {
  late MockAuthService mockAuthService;
  late MockProfileService mockProfileService;
  late MockUser mockUser;
  late MockSession mockSession;
  late AuthProvider authProvider;

  setUp(() {
    mockAuthService = MockAuthService();
    mockProfileService = MockProfileService();
    mockUser = MockUser();
    mockSession = MockSession();

    // Default setup
    when(mockAuthService.authStateChanges).thenAnswer(
      (_) => const Stream<AuthState>.empty(),
    );
    when(mockAuthService.currentSession).thenReturn(null);
  });

  group('AuthProvider Initialization Tests', () {
    test(
      'should initialize with unauthenticated status when no session',
      () async {
        when(mockAuthService.currentSession).thenReturn(null);
        when(mockAuthService.authStateChanges).thenAnswer(
          (_) => const Stream<AuthState>.empty(),
        );

        authProvider = AuthProvider(
          authService: mockAuthService,
          profileService: mockProfileService,
        );

        await Future<void>.delayed(Duration.zero);

        expect(authProvider.status, AuthStatus.unauthenticated);
        expect(authProvider.currentUser, isNull);
        expect(authProvider.userProfile, isNull);
      },
    );

    test(
      'should initialize with authenticated status when session exists',
      () async {
        when(mockSession.user).thenReturn(mockUser);
        when(mockUser.id).thenReturn('123');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockAuthService.currentSession).thenReturn(mockSession);
        when(mockAuthService.authStateChanges).thenAnswer(
          (_) => const Stream<AuthState>.empty(),
        );

        const testProfile = UserProfile(
          id: '123',
          email: 'test@example.com',
          username: 'TestUser',
        );

        when(
          mockProfileService.loadProfile('123', 'test@example.com'),
        ).thenAnswer((_) async => testProfile);

        authProvider = AuthProvider(
          authService: mockAuthService,
          profileService: mockProfileService,
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(authProvider.status, AuthStatus.authenticated);
        expect(authProvider.currentUser, mockUser);
      },
    );
  });

  group('Google Sign In Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should set loading status during google sign in', () async {
      when(
        mockAuthService.signInWithGoogle(any),
      ).thenAnswer((_) async => Future.delayed(const Duration(seconds: 1)));

      final future = authProvider.signInWithGoogle();

      await Future<void>.delayed(Duration.zero);
      expect(authProvider.status, AuthStatus.isGoogleLoading);

      await future;
    });

    test('should handle google sign in success', () async {
      when(mockAuthService.signInWithGoogle(any)).thenAnswer((_) async {
        return;
      });

      await authProvider.signInWithGoogle();

      verify(mockAuthService.signInWithGoogle(any)).called(1);
    });

    test('should handle google sign in error', () async {
      when(
        mockAuthService.signInWithGoogle(any),
      ).thenThrow(const AuthException('Google sign in failed'));

      await authProvider.signInWithGoogle();

      expect(authProvider.status, AuthStatus.error);
      expect(authProvider.errorMessage, isNotNull);
    });
  });

  group('Facebook Sign In Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should set loading status during facebook sign in', () async {
      when(
        mockAuthService.signInWithFacebook(any),
      ).thenAnswer((_) async => Future.delayed(const Duration(seconds: 1)));

      final future = authProvider.signInWithFacebook();

      await Future<void>.delayed(Duration.zero);
      expect(authProvider.status, AuthStatus.isFacebookLoading);

      await future;
    });

    test('should handle facebook sign in success', () async {
      when(mockAuthService.signInWithFacebook(any)).thenAnswer((_) async {
        return;
      });

      await authProvider.signInWithFacebook();

      verify(mockAuthService.signInWithFacebook(any)).called(1);
    });

    test('should handle facebook sign in error', () async {
      when(
        mockAuthService.signInWithFacebook(any),
      ).thenThrow(const AuthException('Facebook sign in failed'));

      await authProvider.signInWithFacebook();

      expect(authProvider.status, AuthStatus.error);
      expect(authProvider.errorMessage, isNotNull);
    });
  });

  group('Email Sign Up Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should set loading status during email sign up', () async {
      when(
        mockAuthService.signUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
          redirectUri: anyNamed('redirectUri'),
        ),
      ).thenAnswer((_) async => Future.delayed(const Duration(seconds: 1)));

      final future = authProvider.signUpWithEmail('test@test.com', 'password');

      await Future<void>.delayed(Duration.zero);
      expect(authProvider.status, AuthStatus.isEmailLoading);

      await future;
    });

    test('should handle email sign up success', () async {
      when(
        mockAuthService.signUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
          redirectUri: anyNamed('redirectUri'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      await authProvider.signUpWithEmail('test@test.com', 'password');

      verify(
        mockAuthService.signUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
          redirectUri: anyNamed('redirectUri'),
        ),
      ).called(1);
    });

    test('should handle email sign up error', () async {
      when(
        mockAuthService.signUpWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
          redirectUri: anyNamed('redirectUri'),
        ),
      ).thenThrow(const AuthException('Sign up failed'));

      await authProvider.signUpWithEmail('test@test.com', 'password');

      expect(authProvider.status, AuthStatus.error);
      expect(authProvider.errorMessage, isNotNull);
    });
  });

  group('Email Sign In Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should set loading status during email sign in', () async {
      when(
        mockAuthService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => Future.delayed(const Duration(seconds: 1)));

      final future = authProvider.signInWithEmail('test@test.com', 'password');

      await Future<void>.delayed(Duration.zero);
      expect(authProvider.status, AuthStatus.isEmailLoading);

      await future;
    });

    test('should handle email sign in success', () async {
      when(
        mockAuthService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      await authProvider.signInWithEmail('test@test.com', 'password');

      verify(
        mockAuthService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).called(1);
    });

    test('should handle email sign in error', () async {
      when(
        mockAuthService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(const AuthException('Invalid credentials'));

      await authProvider.signInWithEmail('test@test.com', 'wrong');

      expect(authProvider.status, AuthStatus.error);
      expect(authProvider.errorMessage, contains('Invalid credentials'));
    });
  });

  group('Sign Out Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should clear user data on sign out', () async {
      when(mockAuthService.signOut()).thenAnswer((_) async {
        return;
      });

      await authProvider.signOut();

      expect(authProvider.status, AuthStatus.unauthenticated);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.userProfile, isNull);
      verify(mockAuthService.signOut()).called(1);
    });

    test('should handle sign out error', () async {
      when(mockAuthService.signOut()).thenThrow(Exception('Sign out failed'));

      await authProvider.signOut();

      expect(authProvider.status, AuthStatus.error);
      expect(authProvider.errorMessage, isNotNull);
    });
  });

  group('Profile Update Tests', () {
    setUp(() {
      when(mockUser.id).thenReturn('123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockSession.user).thenReturn(mockUser);
      when(mockAuthService.currentSession).thenReturn(mockSession);

      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should update profile successfully', () async {
      const updatedProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'NewUsername',
      );

      when(
        mockProfileService.updateProfile(
          userId: anyNamed('userId'),
          username: anyNamed('username'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      when(
        mockProfileService.loadProfile('123', 'test@example.com'),
      ).thenAnswer((_) async => updatedProfile);

      final result = await authProvider.updateProfile(username: 'NewUsername');

      expect(result, true);
      verify(
        mockProfileService.updateProfile(
          userId: anyNamed('userId'),
          username: anyNamed('username'),
        ),
      ).called(1);
    });

    test('should return false when update fails', () async {
      when(
        mockProfileService.updateProfile(
          userId: anyNamed('userId'),
          username: anyNamed('username'),
        ),
      ).thenThrow(Exception('Update failed'));

      final result = await authProvider.updateProfile(username: 'NewUsername');

      expect(result, false);
    });

    test('should return false when user is not authenticated', () async {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );

      final result = await authProvider.updateProfile(username: 'NewUsername');

      expect(result, false);
      verifyNever(
        mockProfileService.updateProfile(
          userId: anyNamed('userId'),
          username: anyNamed('username'),
        ),
      );
    });
  });

  group('Avatar Upload Tests', () {
    late MockFile mockFile;

    setUp(() {
      mockFile = MockFile();
      when(mockUser.id).thenReturn('123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockSession.user).thenReturn(mockUser);
      when(mockAuthService.currentSession).thenReturn(mockSession);

      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should upload avatar successfully', () async {
      const avatarUrl = 'https://example.com/avatar.jpg';
      const updatedProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: avatarUrl,
      );

      when(
        mockProfileService.uploadAvatar(
          userId: anyNamed('userId'),
          imageFile: anyNamed('imageFile'),
        ),
      ).thenAnswer((_) async => avatarUrl);

      when(
        mockProfileService.updateProfile(
          userId: anyNamed('userId'),
          avatarUrl: anyNamed('avatarUrl'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      when(
        mockProfileService.loadProfile('123', 'test@example.com'),
      ).thenAnswer((_) async => updatedProfile);

      final result = await authProvider.uploadAvatar(mockFile);

      expect(result, true);
      verify(
        mockProfileService.uploadAvatar(
          userId: anyNamed('userId'),
          imageFile: anyNamed('imageFile'),
        ),
      ).called(1);
    });

    test('should return false when upload fails', () async {
      when(
        mockProfileService.uploadAvatar(
          userId: anyNamed('userId'),
          imageFile: anyNamed('imageFile'),
        ),
      ).thenThrow(Exception('Upload failed'));

      final result = await authProvider.uploadAvatar(mockFile);

      expect(result, false);
    });

    test('should return false when user is not authenticated', () async {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );

      final result = await authProvider.uploadAvatar(mockFile);

      expect(result, false);
      verifyNever(
        mockProfileService.uploadAvatar(
          userId: anyNamed('userId'),
          imageFile: anyNamed('imageFile'),
        ),
      );
    });
  });

  group('Avatar Delete Tests', () {
    setUp(() {
      when(mockUser.id).thenReturn('123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockSession.user).thenReturn(mockUser);
      when(mockAuthService.currentSession).thenReturn(mockSession);

      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should delete avatar successfully', () async {
      const updatedProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      when(mockProfileService.deleteAvatar(any)).thenAnswer((_) async {
        return;
      });
      when(
        mockProfileService.updateProfile(
          userId: anyNamed('userId'),
          clearAvatar: anyNamed('clearAvatar'),
        ),
      ).thenAnswer((_) async {
        return;
      });
      when(
        mockProfileService.loadProfile('123', 'test@example.com'),
      ).thenAnswer((_) async => updatedProfile);

      final result = await authProvider.deleteAvatar();

      expect(result, true);
      verify(mockProfileService.deleteAvatar(any)).called(1);
    });

    test('should return false when delete fails', () async {
      when(
        mockProfileService.deleteAvatar(any),
      ).thenThrow(Exception('Delete failed'));

      final result = await authProvider.deleteAvatar();

      expect(result, false);
    });
  });

  group('Password Change Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should change password successfully', () async {
      when(mockAuthService.changePassword(any)).thenAnswer((_) async {
        return;
      });

      final result = await authProvider.changePassword('newPassword123');

      expect(result, true);
      verify(mockAuthService.changePassword('newPassword123')).called(1);
    });

    test('should return false when password change fails', () async {
      when(
        mockAuthService.changePassword(any),
      ).thenThrow(Exception('Password change failed'));

      final result = await authProvider.changePassword('newPassword123');

      expect(result, false);
      expect(authProvider.errorMessage, 'Password change failed');
    });
  });

  group('Account Delete Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should delete account successfully', () async {
      when(mockAuthService.deleteAccount()).thenAnswer((_) async {
        return;
      });

      final result = await authProvider.deleteAccount();

      expect(result, true);
      expect(authProvider.status, AuthStatus.unauthenticated);
      expect(authProvider.currentUser, isNull);
      verify(mockAuthService.deleteAccount()).called(1);
    });

    test('should return false when account deletion fails', () async {
      when(
        mockAuthService.deleteAccount(),
      ).thenThrow(Exception('Delete failed'));

      final result = await authProvider.deleteAccount();

      expect(result, false);
      expect(authProvider.errorMessage, 'Account deletion failed');
    });
  });

  group('Provider Check Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should check if email provider', () {
      when(mockAuthService.isEmailProvider()).thenReturn(true);

      final result = authProvider.isEmailProvider();

      expect(result, true);
      verify(mockAuthService.isEmailProvider()).called(1);
    });

    test('should check if google provider', () {
      when(mockAuthService.isGoogleProvider()).thenReturn(true);

      final result = authProvider.isGoogleProvider();

      expect(result, true);
      verify(mockAuthService.isGoogleProvider()).called(1);
    });

    test('should check if facebook provider', () {
      when(mockAuthService.isFacebookProvider()).thenReturn(true);

      final result = authProvider.isFacebookProvider();

      expect(result, true);
      verify(mockAuthService.isFacebookProvider()).called(1);
    });
  });

  group('Error Handling Tests', () {
    setUp(() {
      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should clear error message', () {
      authProvider.clearError();

      expect(authProvider.errorMessage, isNull);
    });

    test('should localize network error message', () async {
      when(
        mockAuthService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(const AuthException('Network error occurred'));

      await authProvider.signInWithEmail('test@test.com', 'password');

      expect(
        authProvider.errorMessage,
        contains('Please check your internet connection'),
      );
    });

    test('should localize timeout error message', () async {
      when(
        mockAuthService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(const AuthException('Request timeout'));

      await authProvider.signInWithEmail('test@test.com', 'password');

      expect(authProvider.errorMessage, contains('Request timed out'));
    });
  });

  group('Profile Refresh Tests', () {
    setUp(() {
      when(mockUser.id).thenReturn('123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockSession.user).thenReturn(mockUser);
      when(mockAuthService.currentSession).thenReturn(mockSession);

      authProvider = AuthProvider(
        authService: mockAuthService,
        profileService: mockProfileService,
      );
    });

    test('should refresh profile successfully', () async {
      const refreshedProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'RefreshedUser',
      );

      when(
        mockProfileService.loadProfile('123', 'test@example.com'),
      ).thenAnswer((_) async => refreshedProfile);

      await authProvider.refreshProfile();

      verify(
        mockProfileService.loadProfile('123', 'test@example.com'),
      ).called(1);
    });

    test('should handle refresh error gracefully', () async {
      when(
        mockProfileService.loadProfile('123', 'test@example.com'),
      ).thenThrow(Exception('Refresh failed'));

      await authProvider.refreshProfile();

      // Should not throw error
    });
  });
}
