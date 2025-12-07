// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/feature/auth/verification/view/email_verification_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([SupabaseClient, GoTrueClient])
import 'email_verification_mixin_test.mocks.dart';

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();

    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
  });

  Widget createTestWidget({String? email}) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EmailVerificationView(),
                  settings: RouteSettings(
                    arguments: email ?? 'test@example.com',
                  ),
                ),
              );
            },
            child: const Text('Navigate'),
          );
        },
      ),
    );
  }

  group('EmailVerificationMixin - Initialization Tests', () {
    testWidgets('should initialize userEmail from route arguments', (
      tester,
    ) async {
      const testEmail = 'test@example.com';
      await tester.pumpWidget(createTestWidget(email: testEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, testEmail);
    });

    testWidgets('should initialize isResendLoading as false', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.isResendLoading, isFalse);
    });

    testWidgets('should handle null route arguments', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EmailVerificationView(),
                      settings: const RouteSettings(),
                    ),
                  );
                },
                child: const Text('Navigate'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, isNull);
    });

    testWidgets('should handle non-String route arguments', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EmailVerificationView(),
                      settings: const RouteSettings(arguments: 123),
                    ),
                  );
                },
                child: const Text('Navigate'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      // Non-String argument should not set userEmail
      expect(state.userEmail, isNull);
    });
  });

  group('EmailVerificationMixin - didChangeDependencies Tests', () {
    testWidgets('should extract email from route arguments correctly', (
      tester,
    ) async {
      const testEmail = 'user@example.com';
      await tester.pumpWidget(createTestWidget(email: testEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, testEmail);
    });

    testWidgets('should handle different email formats', (tester) async {
      final testEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'test+tag@example.org',
        'user123@test.io',
      ];

      for (final email in testEmails) {
        await tester.pumpWidget(createTestWidget(email: email));
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        final dynamic state = tester.state(find.byType(EmailVerificationView));
        expect(state.userEmail, email);

        await tester.pumpWidget(Container());
      }
    });
  });

  group('EmailVerificationMixin - Navigation Tests', () {
    testWidgets('navigateBackToSignIn should pop the route', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // EmailVerificationView'de olduğumuzu kontrol et
      expect(find.byType(EmailVerificationView), findsOneWidget);

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      state.navigateBackToSignIn();
      await tester.pumpAndSettle();

      // Geri döndüğünü kontrol et
      expect(find.byType(EmailVerificationView), findsNothing);
    });

    testWidgets('should be able to navigate back multiple times', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EmailVerificationView(),
                      settings: const RouteSettings(
                        arguments: 'test@example.com',
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Navigate Again'));
      await tester.pumpAndSettle();

      expect(find.byType(EmailVerificationView), findsOneWidget);

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      state.navigateBackToSignIn();
      await tester.pumpAndSettle();

      expect(find.byType(EmailVerificationView), findsNothing);
    });
  });

  group('EmailVerificationMixin - Loading State Tests', () {
    testWidgets('should start with isResendLoading false', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.isResendLoading, isFalse);
    });

    testWidgets('should not modify loading state on initialization', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.isResendLoading, isFalse);

      // Wait a bit and check again
      await tester.pump(const Duration(milliseconds: 100));
      expect(state.isResendLoading, isFalse);
    });
  });

  group('EmailVerificationMixin - Email Validation Tests', () {
    testWidgets('should accept valid email formats', (tester) async {
      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'user+tag@example.org',
        'test123@test.io',
      ];

      for (final email in validEmails) {
        await tester.pumpWidget(createTestWidget(email: email));
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        final dynamic state = tester.state(find.byType(EmailVerificationView));
        expect(state.userEmail, email);

        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should handle empty string email', (tester) async {
      await tester.pumpWidget(createTestWidget(email: ''));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, '');
    });

    testWidgets('should handle email with spaces', (tester) async {
      const emailWithSpaces = '  test@example.com  ';
      await tester.pumpWidget(createTestWidget(email: emailWithSpaces));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, emailWithSpaces);
    });
  });

  group('EmailVerificationMixin - State Management Tests', () {
    testWidgets('should maintain state during widget rebuild', (tester) async {
      const testEmail = 'test@example.com';
      await tester.pumpWidget(createTestWidget(email: testEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      final originalEmail = state.userEmail;

      // Trigger rebuild
      await tester.pump();

      expect(state.userEmail, originalEmail);
    });

    testWidgets('should not lose state on hot reload simulation', (
      tester,
    ) async {
      const testEmail = 'test@example.com';
      await tester.pumpWidget(createTestWidget(email: testEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, testEmail);

      // Simulate hot reload
      await tester.pumpWidget(createTestWidget(email: testEmail));
      await tester.pump();

      expect(state.userEmail, testEmail);
    });
  });

  group('EmailVerificationMixin - Edge Cases Tests', () {
    testWidgets('should handle very long email addresses', (tester) async {
      const longEmail =
          'very.long.email.address.with.many.dots@subdomain.example.com';
      await tester.pumpWidget(createTestWidget(email: longEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, longEmail);
    });

    testWidgets('should handle special characters in email', (tester) async {
      const specialEmail = 'test+tag_name@example.co.uk';
      await tester.pumpWidget(createTestWidget(email: specialEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, specialEmail);
    });

    testWidgets('should handle unicode characters in email', (tester) async {
      const unicodeEmail = 'tëst@example.com';
      await tester.pumpWidget(createTestWidget(email: unicodeEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, unicodeEmail);
    });
  });

  group('EmailVerificationMixin - Widget Lifecycle Tests', () {
    testWidgets('should properly dispose without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Navigate back to trigger dispose
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle mount/unmount cycles', (tester) async {
      for (var i = 0; i < 3; i++) {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(EmailVerificationView), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
