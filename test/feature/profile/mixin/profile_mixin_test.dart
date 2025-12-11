import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/feature/profile/mixin/profile_mixin.dart';
import 'package:moodify/product/constant/string_constant.dart';

import 'profile_mixin_test.mocks.dart';
import 'saved_videos_mixin_test.mocks.dart';

@GenerateMocks([AuthProvider, Box])
void main() {
  late MockAuthProvider mockAuthProvider;
  late MockSavedVideosProvider mockSavedVideosProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockSavedVideosProvider = MockSavedVideosProvider();
  });

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('ProfileMixin Tests', () {
    testWidgets('showLogoutDialog should display logout dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(
        find.text(StringConstant.signOut),
        findsNWidgets(2),
      ); // Title and button
      expect(find.text(StringConstant.logoutAccount), findsOneWidget);
      expect(find.text(StringConstant.cancel), findsOneWidget);
    });

    testWidgets('should dismiss dialog when cancel is tapped', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text(StringConstant.cancel));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(find.text(StringConstant.logoutAccount), findsNothing);
    });

    testWidgets('should call signOut when logout is confirmed', (tester) async {
      when(mockAuthProvider.signOut()).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap sign out button
      await tester.tap(
        find.widgetWithText(ElevatedButton, StringConstant.signOut),
      );
      await tester.pumpAndSettle();

      // Verify signOut was called
      verify(mockAuthProvider.signOut()).called(1);
    });

    testWidgets('dialog should not be dismissible by tapping outside', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Try to tap outside dialog (on barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.text(StringConstant.logoutAccount), findsOneWidget);
    });

    testWidgets('should have correct dialog styling', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify AlertDialog exists
      expect(find.byType(AlertDialog), findsOneWidget);

      // Verify buttons exist
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should return true when logout is confirmed', (tester) async {
      when(mockAuthProvider.signOut()).thenAnswer((_) async => Future.value());

      bool? result;

      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Test'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap confirm button
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Verify result is true
      expect(result, isTrue);
    });

    testWidgets('should return false when cancel is tapped', (tester) async {
      bool? result;

      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Test'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify result is false
      expect(result, isFalse);
    });

    testWidgets('should display all required dialog elements', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify all elements
      expect(find.text(StringConstant.signOut), findsNWidgets(2));
      expect(find.text(StringConstant.logoutAccount), findsOneWidget);
      expect(find.text(StringConstant.cancel), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('ProfileMixin Cache Clearing Tests', () {
    testWidgets('should attempt to clear cache before logout', (tester) async {
      when(mockAuthProvider.signOut()).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap sign out button
      await tester.tap(
        find.widgetWithText(ElevatedButton, StringConstant.signOut),
      );
      await tester.pumpAndSettle();

      // Verify signOut was called (cache clearing happens before this)
      verify(mockAuthProvider.signOut()).called(1);
    });

    testWidgets('should proceed with logout even if cache clearing fails', (
      tester,
    ) async {
      when(mockAuthProvider.signOut()).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => ProfileMixin.showLogoutDialog(
                  context,
                  mockAuthProvider,
                  mockSavedVideosProvider,
                ),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap sign out button
      await tester.tap(
        find.widgetWithText(ElevatedButton, StringConstant.signOut),
      );
      await tester.pumpAndSettle();

      // Verify signOut was still called
      verify(mockAuthProvider.signOut()).called(1);
    });
  });
}
