import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_up/view/sign_up_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';

import 'sign_up_mixin_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createTestApp() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(
        home: SignUpView(),
        onGenerateRoute: AppRouter.routes,
      ),
    );
  }

  group('SignUpMixin Initialization Tests', () {
    testWidgets('should initialize form key', (tester) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Assert
      expect(find.byType(Form), findsOneWidget);
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.key, isNotNull);
    });

    testWidgets('should initialize email controller', (tester) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Assert
      final emailField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, StringConstant.email),
      );
      expect(emailField.controller, isNotNull);
    });

    testWidgets('should initialize password controller', (tester) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Assert
      final passwordField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, StringConstant.password),
      );
      expect(passwordField.controller, isNotNull);
    });

    testWidgets('should initialize confirm password controller', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Assert
      final confirmPasswordField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
      );
      expect(confirmPasswordField.controller, isNotNull);
    });

    testWidgets('should start with isLoading false', (tester) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Assert - Button should be enabled (not loading)
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.signUp),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('SignUpMixin Validation Tests', () {
    testWidgets('emailValidator should reject empty email', (tester) async {
      // Act
      await tester.pumpWidget(createTestApp());
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('The email area cannot be left empty'), findsOneWidget);
    });

    testWidgets('emailValidator should reject invalid email format', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'invalid-email',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('emailValidator should accept valid email', (tester) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - No email validation error
      expect(find.text('Enter a valid email address'), findsNothing);
      expect(
        find.text('The email area cannot be left empty'),
        findsNothing,
      );
    });

    testWidgets('passwordValidator should reject empty password', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Password area cannot be left empty'),
        findsOneWidget,
      );
    });

    testWidgets(
      'passwordValidator should reject password shorter than 6 chars',
      (tester) async {
        // Act
        await tester.pumpWidget(createTestApp());

        await tester.enterText(
          find.widgetWithText(TextFormField, StringConstant.email),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, StringConstant.password),
          '12345',
        );
        await tester.tap(find.text(StringConstant.signUp));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      },
    );

    testWidgets('passwordValidator should accept valid password', (
      tester,
    ) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - No password validation error
      expect(
        find.text('Password must be at least 6 characters'),
        findsNothing,
      );
      expect(
        find.text('Password area cannot be left empty'),
        findsNothing,
      );
    });

    testWidgets('confirmPasswordValidator should reject empty field', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Password repetition area cannot be left empty'),
        findsOneWidget,
      );
    });

    testWidgets(
      'confirmPasswordValidator should reject non-matching password',
      (tester) async {
        // Act
        await tester.pumpWidget(createTestApp());

        await tester.enterText(
          find.widgetWithText(TextFormField, StringConstant.email),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, StringConstant.password),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, StringConstant.confirmPassword),
          'password456',
        );
        await tester.tap(find.text(StringConstant.signUp));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Passwords do not match'), findsOneWidget);
      },
    );

    testWidgets('confirmPasswordValidator should accept matching password', (
      tester,
    ) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - No confirm password validation error
      expect(find.text('Passwords do not match'), findsNothing);
      expect(
        find.text('Password repetition area cannot be left empty'),
        findsNothing,
      );
    });
  });

  group('SignUpMixin Email Sign Up Tests', () {
    testWidgets('should not submit if form is invalid', (tester) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Tap submit button without entering data
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - signUpWithEmail should not be called
      verifyNever(mockAuthProvider.signUpWithEmail(any, any));
    });

    testWidgets('should set loading state to true when submitting', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.signUpWithEmail(any, any)).thenAnswer(
        (_) async => Future.delayed(const Duration(milliseconds: 100)),
      );

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );

      await tester.tap(find.text(StringConstant.signUp));
      await tester.pump();

      // Assert - Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call signUpWithEmail with correct parameters', (
      tester,
    ) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );

      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      verify(
        mockAuthProvider.signUpWithEmail('test@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should trim email before calling signUpWithEmail', (
      tester,
    ) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        '  test@example.com  ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );

      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - Email should be trimmed
      verify(
        mockAuthProvider.signUpWithEmail('test@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should set loading to false after successful submission', (
      tester,
    ) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );

      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - Button should be enabled again
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.signUp),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should handle error during sign up', (tester) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenThrow(Exception('Sign up failed'));

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );

      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - Error should be handled gracefully
      expect(tester.takeException(), isNull);
    });

    testWidgets('should set loading to false after error', (tester) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenThrow(Exception('Sign up failed'));

      // Act
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );

      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - Button should be enabled again
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.signUp),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('SignUpMixin Widget Lifecycle Tests', () {
    testWidgets('should dispose controllers when widget is disposed', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestApp());

      // Pump the widget
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(Container());

      // Assert - No errors should occur during dispose
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle multiple form submissions', (tester) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestApp());

      // First submission
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test1@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Clear fields
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test2@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password456',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password456',
      );

      // Second submission
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - Both submissions should be called
      verify(mockAuthProvider.signUpWithEmail(any, any)).called(2);
    });
  });
}
