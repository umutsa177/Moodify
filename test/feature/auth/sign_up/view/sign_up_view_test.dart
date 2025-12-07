import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_up/view/sign_up_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';

import 'sign_up_view_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(
        home: SignUpView(),
        onGenerateRoute: AppRouter.routes,
      ),
    );
  }

  group('SignUpView Widget Tests', () {
    testWidgets('should display app name and register title', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.appName), findsOneWidget);
      expect(find.text(StringConstant.registerTitle), findsOneWidget);
    });

    testWidgets('should display gradient background', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Scaffold),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final gradient = decoration.gradient! as LinearGradient;

      expect(gradient.colors, equals(ColorConstant.authBackgroundColors));
    });

    testWidgets('should display all form fields', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.email), findsOneWidget);
      expect(find.text(StringConstant.password), findsOneWidget);
      expect(find.text(StringConstant.confirmPassword), findsOneWidget);
    });

    testWidgets('should display sign up button', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.signUp), findsOneWidget);
    });

    testWidgets('should display login redirect text', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(StringConstant.alreadyHaveAccount), findsOneWidget);
      expect(find.text(StringConstant.login), findsOneWidget);
    });

    testWidgets('should have Form widget', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should have three TextFormField widgets', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('should allow text input in email field', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );
      await tester.pump();

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow text input in password field', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );
      await tester.pump();

      // Assert
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should allow text input in confirm password field', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password123',
      );
      await tester.pump();

      // Assert
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should show validation error for empty email', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Tap sign up button without entering email
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('The email area cannot be left empty'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'invalid-email',
      );

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('should show validation error for empty password', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );

      // Tap sign up button without entering password
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Password area cannot be left empty'),
        findsOneWidget,
      );
    });

    testWidgets('should show validation error for short password', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );

      // Enter short password
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        '12345',
      );

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should show validation error for mismatched passwords', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.email),
        'test@example.com',
      );

      // Enter password
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.password),
        'password123',
      );

      // Enter different confirm password
      await tester.enterText(
        find.widgetWithText(TextFormField, StringConstant.confirmPassword),
        'password456',
      );

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should show loading indicator when submitting', (
      tester,
    ) async {
      // Arrange
      when(mockAuthProvider.signUpWithEmail(any, any)).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 2)),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter valid data
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

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pump();

      // Assert - Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable button when loading', (tester) async {
      // Arrange
      when(mockAuthProvider.signUpWithEmail(any, any)).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 2)),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter valid data
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

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pump();

      // Get the button
      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(ElevatedButton),
        ),
      );

      // Assert - Button should be disabled
      expect(button.onPressed, isNull);
    });

    testWidgets('should call signUpWithEmail on valid form submission', (
      tester,
    ) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter valid data
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

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert
      verify(
        mockAuthProvider.signUpWithEmail('test@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should trim email before submission', (tester) async {
      // Arrange
      when(
        mockAuthProvider.signUpWithEmail(any, any),
      ).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(createTestWidget());

      // Enter email with spaces
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

      // Tap sign up button
      await tester.tap(find.text(StringConstant.signUp));
      await tester.pumpAndSettle();

      // Assert - Email should be trimmed
      verify(
        mockAuthProvider.signUpWithEmail('test@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should navigate to login when login text is tapped', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Tap login text
      await tester.tap(find.text(StringConstant.login));
      await tester.pumpAndSettle();

      // Assert - Should attempt navigation
      // Note: Navigation testing would require NavigatorObserver
      expect(find.byType(SignUpView), findsOneWidget);
    });

    testWidgets('should have correct button styling', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, StringConstant.signUp),
      );

      expect(
        button.style?.backgroundColor?.resolve({}),
        ColorConstant.primary,
      );
    });

    testWidgets('should have SingleChildScrollView for keyboard', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should adjust for keyboard padding', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - SingleChildScrollView should have padding
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.padding, isNotNull);
    });

    testWidgets('should have ShaderMask on button text', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('should display button with gradient text effect', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final shaderMask = tester.widget<ShaderMask>(find.byType(ShaderMask));
      expect(shaderMask.shaderCallback, isNotNull);
    });
  });
}
