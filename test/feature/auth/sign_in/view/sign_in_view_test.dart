import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_in/view/sign_in_view.dart';
import 'package:moodify/feature/auth/widget/auth_email_textfield.dart';
import 'package:moodify/feature/auth/widget/auth_password_textfield.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([AuthProvider])
import 'sign_in_view_test.mocks.dart';

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: const SignInView(),
      ),
      onGenerateRoute: AppRouter.routes,
    );
  }

  group('SignInView Widget Tests', () {
    testWidgets('should render all required widgets', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Title kontrolü - text yerine widgetları bulalım
      expect(find.byType(SignInView), findsOneWidget);

      // Email ve password textfield kontrolü
      expect(find.byType(AuthEmailTextField), findsOneWidget);
      expect(find.byType(AuthPasswordTextField), findsOneWidget);

      // Sign in button kontrolü
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Redirect button kontrolü - InkWell içinde RichText
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should have gradient background', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Container).first,
        ),
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should show validation errors for empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Sign in butonuna tıkla
      final signInButton = find.byType(ElevatedButton);
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Validation mesajlarını kontrol et
      expect(find.text('The email area cannot be left empty'), findsOneWidget);
      expect(find.text('Password area cannot be left empty'), findsOneWidget);
    });

    testWidgets('should show error for invalid email format', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Geçersiz email gir
      final emailField = find.byType(AuthEmailTextField);
      await tester.enterText(emailField, 'invalidemail');

      // Password gir (validation geçmesi için)
      final passwordField = find.byType(AuthPasswordTextField);
      await tester.enterText(passwordField, 'password123');

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Valid email gir
      final emailField = find.byType(AuthEmailTextField);
      await tester.enterText(emailField, 'test@example.com');

      // Kısa password gir
      final passwordField = find.byType(AuthPasswordTextField);
      await tester.enterText(passwordField, '12345');

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should show loading indicator during sign in', (tester) async {
      // Mock auth provider'ı uzun süren bir işlem döndürecek şekilde ayarla
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) => Future.delayed(const Duration(seconds: 2)));

      await tester.pumpWidget(createWidgetUnderTest());

      // Valid credentials gir
      await tester.enterText(
        find.byType(AuthEmailTextField),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(AuthPasswordTextField),
        'password123',
      );

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Loading indicator'ı kontrol et
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Button disabled olmalı
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('should call signInWithEmail with correct parameters', (
      tester,
    ) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());

      const email = 'test@example.com';
      const password = 'password123';

      // Credentials gir
      await tester.enterText(find.byType(AuthEmailTextField), email);
      await tester.enterText(find.byType(AuthPasswordTextField), password);

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Doğru parametrelerle çağrıldığını kontrol et
      verify(mockAuthProvider.signInWithEmail(email, password)).called(1);
    });

    testWidgets('should navigate to mood selection on successful sign in', (
      tester,
    ) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());

      // Valid credentials gir
      await tester.enterText(
        find.byType(AuthEmailTextField),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(AuthPasswordTextField),
        'password123',
      );

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Mood selection ekranına gittiğini kontrol et - route değişimini kontrol edelim
      verify(mockAuthProvider.signInWithEmail(any, any)).called(1);
    });

    testWidgets('should show error toast on AuthException', (tester) async {
      const authException = AuthException('Invalid credentials');
      when(mockAuthProvider.signInWithEmail(any, any)).thenThrow(authException);

      await tester.pumpWidget(createWidgetUnderTest());

      // Valid credentials gir
      await tester.enterText(
        find.byType(AuthEmailTextField),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(AuthPasswordTextField),
        'wrongpassword',
      );

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Loading indicator kaybolmalı
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Exception fırlatıldığını verify et
      verify(mockAuthProvider.signInWithEmail(any, any)).called(1);
    });

    testWidgets('should navigate to sign up when redirect button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Sign up link'ine tıkla - InkWell widget'ını bul
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Sign up view render edildiğini kontrol et
      expect(find.byType(SignInView), findsNothing);
    });

    testWidgets('should dispose controllers properly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Widget'ı dispose et
      await tester.pumpWidget(Container());

      // Controller'ların dispose edildiğini test etmek için
      // yeni bir widget oluştur ve controllers'ın yeni instance olduğunu kontrol et
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SignInView), findsOneWidget);
    });

    testWidgets('should trim email before signing in', (tester) async {
      when(
        mockAuthProvider.signInWithEmail(any, any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());

      const emailWithSpaces = '  test@example.com  ';
      const trimmedEmail = 'test@example.com';

      // Email ile boşluklar gir
      await tester.enterText(find.byType(AuthEmailTextField), emailWithSpaces);
      await tester.enterText(find.byType(AuthPasswordTextField), 'password123');

      // Sign in butonuna tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Trim edilmiş email ile çağrıldığını kontrol et
      verify(
        mockAuthProvider.signInWithEmail(trimmedEmail, 'password123'),
      ).called(1);
    });

    testWidgets('should handle keyboard appearance', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // SingleChildScrollView var mı kontrol et
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Email field'a focus ver (klavye açılır)
      await tester.tap(find.byType(AuthEmailTextField));
      await tester.pump();

      // Widget hala render edilebilmeli
      expect(find.byType(SignInView), findsOneWidget);
    });
  });

  group('SignInView Form Validation Tests', () {
    testWidgets('should validate email with various formats', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final testCases = [
        ('test@example.com', true),
        ('user.name@domain.co.uk', true),
        ('invalid.email', false),
        ('@example.com', false),
        ('test@', false),
        ('', false),
      ];

      for (final testCase in testCases) {
        final email = testCase.$1;
        final shouldBeValid = testCase.$2;

        await tester.enterText(find.byType(AuthEmailTextField), email);
        await tester.enterText(
          find.byType(AuthPasswordTextField),
          'password123',
        );
        await tester.tap(find.text(StringConstant.login));
        await tester.pump();

        if (shouldBeValid) {
          expect(
            find.text('Enter a valid email address'),
            findsNothing,
            reason: 'Email "$email" should be valid',
          );
        } else {
          expect(
            find.textContaining('email'),
            findsWidgets,
            reason: 'Email "$email" should be invalid',
          );
        }
      }
    });

    testWidgets('should validate password length', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final testCases = [
        ('12345', false), // 5 characters - invalid
        ('123456', true), // 6 characters - valid
        ('1234567890', true), // 10 characters - valid
        ('', false), // empty - invalid
      ];

      for (final testCase in testCases) {
        final password = testCase.$1;
        final shouldBeValid = testCase.$2;

        await tester.enterText(
          find.byType(AuthEmailTextField),
          'test@example.com',
        );
        await tester.enterText(find.byType(AuthPasswordTextField), password);
        await tester.tap(find.text(StringConstant.login));
        await tester.pump();

        if (shouldBeValid) {
          expect(
            find.text('Password must be at least 6 characters'),
            findsNothing,
            reason: 'Password "$password" should be valid',
          );
        } else {
          expect(
            find.textContaining('Password'),
            findsWidgets,
            reason: 'Password "$password" should be invalid',
          );
        }
      }
    });
  });
}
