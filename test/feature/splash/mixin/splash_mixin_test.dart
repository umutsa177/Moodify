import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/splash/view/splash_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/auth_status.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_mixin_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  // Setup SharedPreferences mock for all tests
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockAuthProvider = MockAuthProvider();

    // Mock SharedPreferences to avoid MissingPluginException
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestApp() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(
        home: SplashView(),
        onGenerateRoute: AppRouter.routes,
      ),
    );
  }

  group('SplashMixin Tests', () {
    testWidgets(
      'checkAuth should navigate to mood selection when authenticated',
      (tester) async {
        // Arrange
        when(mockAuthProvider.isAuthenticated).thenReturn(true);
        when(mockAuthProvider.status).thenReturn(AuthStatus.authenticated);
        when(mockAuthProvider.errorMessage).thenReturn(null);
        when(mockAuthProvider.isGoogleLoading).thenReturn(false);
        when(mockAuthProvider.isFacebookLoading).thenReturn(false);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Assert - The app should attempt to navigate
        verify(mockAuthProvider.isAuthenticated).called(greaterThan(0));
      },
    );

    testWidgets(
      'checkAuth should show error snackbar when auth status is error',
      (tester) async {
        // Arrange
        const errorMessage = 'Authentication failed';
        when(mockAuthProvider.isAuthenticated).thenReturn(false);
        when(mockAuthProvider.status).thenReturn(AuthStatus.error);
        when(mockAuthProvider.errorMessage).thenReturn(errorMessage);
        when(mockAuthProvider.isGoogleLoading).thenReturn(false);
        when(mockAuthProvider.isFacebookLoading).thenReturn(false);
        when(mockAuthProvider.clearError()).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestApp());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.text(StringConstant.okey), findsOneWidget);
      },
    );

    testWidgets('should clear error when snackbar action is pressed', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Authentication failed';
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.error);
      when(mockAuthProvider.errorMessage).thenReturn(errorMessage);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);
      when(mockAuthProvider.clearError()).thenReturn(null);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap the OK button in snackbar
      await tester.tap(find.text(StringConstant.okey));
      await tester.pump();

      // Assert
      verify(mockAuthProvider.clearError()).called(1);
    });

    testWidgets('should not show snackbar when there is no error', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('should not navigate when not authenticated', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Assert - Should stay on splash screen
      expect(find.text(StringConstant.splashTitle), findsOneWidget);
    });

    testWidgets('should handle authentication state changes', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Change auth status
      when(mockAuthProvider.isAuthenticated).thenReturn(true);
      when(mockAuthProvider.status).thenReturn(AuthStatus.authenticated);
      mockAuthProvider.notifyListeners();

      await tester.pump();

      // Assert
      verify(mockAuthProvider.isAuthenticated).called(greaterThan(0));
    });

    testWidgets('should verify widget is mounted before navigation', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(true);
      when(mockAuthProvider.status).thenReturn(AuthStatus.authenticated);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // The checkAuth method checks if mounted before navigation
      // This test ensures no errors are thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle error message being null', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.error);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert - No snackbar should be shown when errorMessage is null
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('should display correct snackbar styling', (tester) async {
      // Arrange
      const errorMessage = 'Test error';
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.error);
      when(mockAuthProvider.errorMessage).thenReturn(errorMessage);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);
      when(mockAuthProvider.clearError()).thenReturn(null);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text(StringConstant.okey), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, isNotNull);
    });
  });

  group('SplashMixin Deep Link Tests', () {
    testWidgets('should initialize app links on init', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Assert - Widget should initialize without errors
      expect(find.byType(SplashView), findsOneWidget);
    });

    testWidgets('should handle widget lifecycle correctly', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(Container());

      // Assert - No errors should occur during dispose
      expect(tester.takeException(), isNull);
    });

    testWidgets('should not crash when context is unmounted', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Rapidly change state and unmount
      when(mockAuthProvider.status).thenReturn(AuthStatus.error);
      when(mockAuthProvider.errorMessage).thenReturn('Error');
      mockAuthProvider.notifyListeners();

      await tester.pumpWidget(Container());

      // Assert - Should not crash
      expect(tester.takeException(), isNull);
    });
  });

  group('SplashMixin Integration Tests', () {
    testWidgets('should complete full authentication flow', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);
      when(mockAuthProvider.signInWithGoogle()).thenAnswer((_) async {
        when(mockAuthProvider.isAuthenticated).thenReturn(true);
        when(mockAuthProvider.status).thenReturn(AuthStatus.authenticated);
      });

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Tap Google sign in button
      await tester.tap(find.text(StringConstant.signInGoogle));
      await tester.pump();

      // Assert
      verify(mockAuthProvider.signInWithGoogle()).called(1);
    });

    testWidgets('should handle error during authentication', (tester) async {
      // Arrange
      const errorMessage = 'Google sign in failed';
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);
      when(mockAuthProvider.signInWithGoogle()).thenAnswer((_) async {
        when(mockAuthProvider.status).thenReturn(AuthStatus.error);
        when(mockAuthProvider.errorMessage).thenReturn(errorMessage);
      });
      when(mockAuthProvider.clearError()).thenReturn(null);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Update provider state to error
      when(mockAuthProvider.status).thenReturn(AuthStatus.error);
      when(mockAuthProvider.errorMessage).thenReturn(errorMessage);
      mockAuthProvider.notifyListeners();

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should properly handle loading states during authentication', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);
      when(mockAuthProvider.signInWithGoogle()).thenAnswer((_) async {
        when(mockAuthProvider.isGoogleLoading).thenReturn(true);
      });

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Start authentication
      await tester.tap(find.text(StringConstant.signInGoogle));
      await tester.pump();

      // Assert
      verify(mockAuthProvider.signInWithGoogle()).called(1);
    });

    testWidgets('should show splash screen initially', (tester) async {
      // Arrange
      when(mockAuthProvider.isAuthenticated).thenReturn(false);
      when(mockAuthProvider.status).thenReturn(AuthStatus.initial);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.isGoogleLoading).thenReturn(false);
      when(mockAuthProvider.isFacebookLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Assert
      expect(find.text(StringConstant.splashTitle), findsOneWidget);
      expect(find.text(StringConstant.splashSubtitle), findsOneWidget);
      expect(find.text(StringConstant.signInGoogle), findsOneWidget);
      expect(find.text(StringConstant.signInFacebook), findsOneWidget);
      expect(find.text(StringConstant.emailSignup), findsOneWidget);
    });
  });
}
