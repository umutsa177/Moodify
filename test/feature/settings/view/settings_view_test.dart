import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/profile/purchase_provider.dart';
import 'package:moodify/feature/settings/view/settings_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';

import 'settings_view_test.mocks.dart';

@GenerateMocks([AuthProvider, PurchaseProvider])
void main() {
  late MockAuthProvider mockAuthProvider;
  late MockPurchaseProvider mockPurchaseProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockPurchaseProvider = MockPurchaseProvider();
  });

  Widget createWidgetUnderTest({
    bool isEmailUser = true,
    bool isPremium = false,
  }) {
    when(mockAuthProvider.isEmailProvider()).thenReturn(isEmailUser);
    when(mockPurchaseProvider.isPremium).thenReturn(isPremium);
    when(mockPurchaseProvider.isLoading).thenReturn(false);
    when(mockPurchaseProvider.availablePackages).thenReturn([]);

    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(
              value: mockAuthProvider,
            ),
            ChangeNotifierProvider<PurchaseProvider>.value(
              value: mockPurchaseProvider,
            ),
          ],
          child: const SettingsView(),
        ),
      ),
    );
  }

  group('SettingsView Widget Tests', () {
    testWidgets('should display settings header with back button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.settings), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('should display gradient background', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox).first,
      );
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should display premium tile for non-premium users', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.upgradeToPremium), findsOneWidget);
      expect(find.text(StringConstant.unlockAllFeatures), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('should display premium member tile for premium users', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isPremium: true));
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.premiumMember), findsOneWidget);
      expect(find.text(StringConstant.premiumActive), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('should display restore purchases tile', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.restorePurchases), findsOneWidget);
      expect(
        find.text(StringConstant.restorePurchasesSubtitle),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.restore), findsOneWidget);
    });

    testWidgets('should display language selection tile', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.selectionLanguage), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('should display change password tile for email users', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.changePassword), findsOneWidget);
      expect(find.text(StringConstant.updatePassword), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should not display change password tile for non-email users', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isEmailUser: false));
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.changePassword), findsNothing);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
    });

    testWidgets('should display delete account tile', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.deleteAccount), findsOneWidget);
      expect(find.text(StringConstant.deleteAccountSubtitle), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should display dividers between tiles', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Email users should have 5 dividers (between 6 tiles)
      expect(find.byType(Divider), findsNWidgets(5));
    });

    testWidgets('should have scrollable list view', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.physics, isA<ClampingScrollPhysics>());
    });

    testWidgets('should navigate back when back button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<AuthProvider>.value(
                              value: mockAuthProvider,
                            ),
                            ChangeNotifierProvider<PurchaseProvider>.value(
                              value: mockPurchaseProvider,
                            ),
                          ],
                          child: const SettingsView(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go to Settings'),
                );
              },
            ),
          ),
        ),
      );

      when(mockAuthProvider.isEmailProvider()).thenReturn(true);
      when(mockPurchaseProvider.isPremium).thenReturn(false);
      when(mockPurchaseProvider.isLoading).thenReturn(false);
      when(mockPurchaseProvider.availablePackages).thenReturn([]);

      await tester.tap(find.text('Go to Settings'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsView), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsView), findsNothing);
    });

    testWidgets('should display correct language subtitle', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Default locale is English
      expect(find.text(StringConstant.eng), findsOneWidget);
    });

    testWidgets('should have correct container decoration', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Expanded),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });
  });

  group('SettingsView Interaction Tests', () {
    testWidgets('should call showPremiumDialog when premium tile tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text(StringConstant.upgradeToPremium));
      await tester.pumpAndSettle();

      // Should show dialog
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
      'should call showManagePremiumDialog when premium member tapped',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(isPremium: true));
        await tester.pumpAndSettle();

        await tester.tap(find.text(StringConstant.premiumMember));
        await tester.pumpAndSettle();

        // Should show dialog
        expect(find.byType(AlertDialog), findsOneWidget);
      },
    );

    testWidgets('should call changeLanguageDialog when language tile tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text(StringConstant.selectionLanguage));
      await tester.pumpAndSettle();

      // Should show dialog with language options
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(StringConstant.tur), findsOneWidget);
      expect(find.text(StringConstant.eng), findsOneWidget);
    });

    testWidgets('should call changePasswordDialog when password tile tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text(StringConstant.changePassword));
      await tester.pumpAndSettle();

      // Should show dialog
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should call deleteAccountDialog when delete tile tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text(StringConstant.deleteAccount));
      await tester.pumpAndSettle();

      // Should show dialog
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('SettingsTile Widget Tests', () {
    testWidgets('should display all tile components', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text('Test Title'),
              subtitle: const Text('Test Subtitle'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should be tappable', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              onTap: () => tapped = true,
              title: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });
  });
}
