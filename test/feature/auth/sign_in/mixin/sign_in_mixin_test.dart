// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_in/view/sign_in_view.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sign_in_mixin_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: child,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == AppRouter.moodSelection) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Mood Selection')),
          );
        }
        return null;
      },
    );
  }

  group('SignInMixin - Initialization Tests', () {
    testWidgets('should initialize all controllers in initState', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      expect(state.formKey, isNotNull);
      expect(state.emailController, isNotNull);
      expect(state.passwordController, isNotNull);
      expect(state.isLoading, isFalse);
    });

    testWidgets('should have empty controllers initially', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      expect(state.emailController.text, isEmpty);
      expect(state.passwordController.text, isEmpty);
    });
  });

  group('SignInMixin - Disposal Tests', () {
    testWidgets('should dispose controllers properly', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      final emailController = state.emailController;
      final passwordController = state.passwordController;

      // Widget'ı dispose et
      await tester.pumpWidget(Container());

      // Controller'ların dispose edildiğini kontrol et (exception throw etmeli)
      expect(
        () => emailController.text,
        throwsFlutterError,
      );
      expect(
        () => passwordController.text,
        throwsFlutterError,
      );
    });
  });

  group('SignInMixin - Email Validation Tests', () {
    testWidgets('should validate empty email', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      final result = state.emailValidator('');

      expect(result, 'The email area cannot be left empty');
    });

    testWidgets('should validate null email', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      final result = state.emailValidator(null);

      expect(result, 'The email area cannot be left empty');
    });

    testWidgets('should validate invalid email format', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      final invalidEmails = [
        'invalidemail',
        'test@',
        '@example.com',
        'test@example',
        'test.example.com',
        'test @example.com',
      ];

      for (final email in invalidEmails) {
        final result = state.emailValidator(email);
        expect(
          result,
          'Enter a valid email address',
          reason: 'Email "$email" should be invalid',
        );
      }
    });

    testWidgets('should validate valid email formats', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'first.last@subdomain.example.com',
        'user+tag@example.org',
        'test123@test.io',
      ];

      for (final email in validEmails) {
        final result = state.emailValidator(email);
        expect(
          result,
          isNull,
          reason: 'Email "$email" should be valid',
        );
      }
    });
  });

  group('SignInMixin - Password Validation Tests', () {
    testWidgets('should validate empty password', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      final result = state.passwordValidator('');

      expect(result, 'Password area cannot be left empty');
    });

    testWidgets('should validate null password', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      final result = state.passwordValidator(null);

      expect(result, 'Password area cannot be left empty');
    });

    testWidgets('should validate short password', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      final shortPasswords = ['1', '12', '123', '1234', '12345'];

      for (final password in shortPasswords) {
        final result = state.passwordValidator(password);
        expect(
          result,
          'Password must be at least 6 characters',
          reason:
              'Password "$password" (${password.length} chars) should be invalid',
        );
      }
    });

    testWidgets('should validate valid password lengths', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      final validPasswords = [
        '123456', // exactly 6
        '1234567', // 7
        'password123',
        'VeryLongPassword123!@#',
      ];

      for (final password in validPasswords) {
        final result = state.passwordValidator(password);
        expect(
          result,
          isNull,
          reason:
              'Password "$password" (${password.length} chars) should be valid',
        );
      }
    });
  });

  group('SignInMixin - Email Sign In Tests', () {
    testWidgets('should not sign in if form is invalid', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      // Form'u validate etmeden emailSignIn çağır
      await state.emailSignIn();
      await tester.pumpAndSettle();

      // Auth provider çağrılmamalı
      verifyNever(mockAuthProvider.signInWithEmail(any, any));
      expect(state.isLoading, isFalse);
    });

    testWidgets('should set loading state during sign in', (tester) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 100), () {}),
      );

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      // Valid data set et
      state.emailController.text = 'test@example.com';
      state.passwordController.text = 'password123';

      // emailSignIn çağır ama await etme
      state.emailSignIn();
      await tester.pump();

      // Loading true olmalı
      expect(state.isLoading, isTrue);

      // İşlem bitene kadar bekle
      await tester.pumpAndSettle();

      // Loading false olmalı
      expect(state.isLoading, isFalse);
    });

    testWidgets('should call auth provider with correct parameters', (
      tester,
    ) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      const email = 'test@example.com';
      const password = 'password123';

      state.emailController.text = email;
      state.passwordController.text = password;

      await state.emailSignIn();
      await tester.pumpAndSettle();

      verify(mockAuthProvider.signInWithEmail(email, password)).called(1);
    });

    testWidgets('should trim email before signing in', (tester) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      state.emailController.text = '  test@example.com  ';
      state.passwordController.text = 'password123';

      await state.emailSignIn();
      await tester.pumpAndSettle();

      verify(
        mockAuthProvider.signInWithEmail('test@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should navigate to mood selection on success', (tester) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      state.emailController.text = 'test@example.com';
      state.passwordController.text = 'password123';

      await state.emailSignIn();
      await tester.pumpAndSettle();

      expect(find.text('Mood Selection'), findsOneWidget);
    });

    testWidgets('should handle AuthException', (tester) async {
      const exception = AuthException('Invalid credentials');
      when(mockAuthProvider.signInWithEmail(any, any)).thenThrow(exception);

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );
      state.emailController.text = 'test@example.com';
      state.passwordController.text = 'wrongpassword';

      await state.emailSignIn();
      await tester.pumpAndSettle();

      // Loading state false olmalı
      expect(state.isLoading, isFalse);

      // Navigasyon olmamalı
      expect(find.text('Mood Selection'), findsNothing);
    });

    testWidgets('should reset loading state on error', (tester) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenThrow(const AuthException('Error'));

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      state.emailController.text = 'test@example.com';
      state.passwordController.text = 'password123';

      await state.emailSignIn();
      await tester.pumpAndSettle();

      expect(state.isLoading, isFalse);
    });

    testWidgets('should not navigate if widget is not mounted', (tester) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) => Future.delayed(const Duration(seconds: 1), () {}));

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      state.emailController.text = 'test@example.com';
      state.passwordController.text = 'password123';

      // Sign in başlat
      state.emailSignIn();
      await tester.pump();

      // Widget'ı dispose et
      await tester.pumpWidget(Container());

      // İşlem bitmesini bekle
      await tester.pumpAndSettle();

      // Crash olmamalı
      expect(tester.takeException(), isNull);
    });
  });

  group('SignInMixin - Loading State Tests', () {
    testWidgets('should start with loading false', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      expect(state.isLoading, isFalse);
    });

    testWidgets('should toggle loading state correctly', (tester) async {
      var callCount = 0;
      when(mockAuthProvider.signInWithEmail(any, any)).thenAnswer((_) async {
        callCount++;
        await Future.delayed(const Duration(milliseconds: 100), () {});
        return;
      });

      await tester.pumpWidget(createTestWidget(const SignInView()));

      final dynamic state = tester.state<State<SignInView>>(
        find.byType(SignInView),
      );

      state.emailController.text = 'test@example.com';
      state.passwordController.text = 'password123';

      // İlk sign in
      expect(state.isLoading, isFalse);
      state.emailSignIn();
      await tester.pump();
      expect(state.isLoading, isTrue);
      await tester.pumpAndSettle();
      expect(state.isLoading, isFalse);

      // İkinci sign in
      state.emailSignIn();
      await tester.pump();
      expect(state.isLoading, isTrue);
      await tester.pumpAndSettle();
      expect(state.isLoading, isFalse);

      expect(callCount, 2);
    });
  });
}
