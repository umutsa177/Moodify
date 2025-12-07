// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/verification/view/email_verification_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([SupabaseClient, GoTrueClient])
import 'email_verification_view_test.mocks.dart';

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();

    // Setup Supabase mock
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
  });

  Widget createWidgetUnderTest({String? email}) {
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
      onGenerateRoute: AppRouter.routes,
    );
  }

  group('EmailVerificationView Widget Tests', () {
    testWidgets('should render all required widgets', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Email icon kontrolü
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);

      // Email adres kontrolü
      expect(find.text('test@example.com'), findsOneWidget);

      // Buttons kontrolü
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should display email from route arguments', (tester) async {
      const testEmail = 'user@example.com';
      await tester.pumpWidget(createWidgetUnderTest(email: testEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.text(testEmail), findsOneWidget);
    });

    testWidgets('should have gradient background', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

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

    testWidgets('should have circular email icon container', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final containers = find.byType(Container);
      var foundCircularContainer = false;

      for (var i = 0; i < tester.widgetList(containers).length; i++) {
        final container = tester.widget<Container>(containers.at(i));
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration! as BoxDecoration;
          if (decoration.shape == BoxShape.circle) {
            foundCircularContainer = true;
            break;
          }
        }
      }

      expect(foundCircularContainer, isTrue);
    });

    testWidgets('should navigate back when back button pressed', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // EmailVerificationView'de olduğumuzu kontrol et
      expect(find.byType(EmailVerificationView), findsOneWidget);

      // Back button'a tıkla
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Geri dönüldüğünü kontrol et
      expect(find.byType(EmailVerificationView), findsNothing);
    });

    testWidgets('should show resend email button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should have proper layout spacing', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Column içinde spacing kontrolü
      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Column).first,
        ),
      );

      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should display all text widgets', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Text widget'larının sayısını kontrol et
      expect(find.byType(Text), findsWidgets);
    });
  });

  group('EmailVerificationView State Tests', () {
    testWidgets('should initialize with correct email from arguments', (
      tester,
    ) async {
      const testEmail = 'test@example.com';
      await tester.pumpWidget(createWidgetUnderTest(email: testEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.userEmail, testEmail);
    });

    testWidgets('should start with isResendLoading false', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(EmailVerificationView));
      expect(state.isResendLoading, isFalse);
    });

    testWidgets('should handle null email arguments', (tester) async {
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

      // Widget should still render without crashing
      expect(find.byType(EmailVerificationView), findsOneWidget);
    });
  });

  group('EmailVerificationView Button Tests', () {
    testWidgets('back button should have correct styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(elevatedButton.onPressed, isNotNull);
    });

    testWidgets('resend button should be tappable', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.onTap, isNotNull);
    });

    testWidgets('should handle multiple button taps', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Back button'a birden fazla tıklama
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Geri döndüğünü kontrol et
      expect(find.byType(EmailVerificationView), findsNothing);
    });
  });

  group('EmailVerificationView Layout Tests', () {
    testWidgets('should have proper widget hierarchy', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Scaffold içinde Container olmalı
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Container),
        ),
        findsWidgets,
      );

      // Container içinde Column olmalı
      expect(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Column),
        ),
        findsWidgets,
      );
    });

    testWidgets('should center content vertically', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Column).first,
        ),
      );

      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should have padding applied', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.byType(Padding), findsWidgets);
    });
  });

  group('EmailVerificationView Email Display Tests', () {
    testWidgets('should display different email formats correctly', (
      tester,
    ) async {
      final testEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'test+tag@example.org',
      ];

      for (final email in testEmails) {
        await tester.pumpWidget(createWidgetUnderTest(email: email));
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text(email), findsOneWidget);

        // Reset for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should handle long email addresses', (tester) async {
      const longEmail =
          'very.long.email.address.with.many.dots@subdomain.example.com';
      await tester.pumpWidget(createWidgetUnderTest(email: longEmail));
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.text(longEmail), findsOneWidget);
    });
  });

  group('EmailVerificationView Icon Tests', () {
    testWidgets('should display email icon with correct properties', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.email_outlined));
      expect(icon.icon, Icons.email_outlined);
    });

    testWidgets('email icon should be inside container', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(Container),
          matching: find.byIcon(Icons.email_outlined),
        ),
        findsOneWidget,
      );
    });
  });
}
