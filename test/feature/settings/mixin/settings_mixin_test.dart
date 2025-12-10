import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/profile/purchase_provider.dart';
import 'package:moodify/feature/settings/view/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'settings_mixin_test.mocks.dart';

@GenerateMocks([AuthProvider, PurchaseProvider, Package])
void main() {
  late MockAuthProvider mockAuthProvider;
  late MockPurchaseProvider mockPurchaseProvider;
  late MockPackage mockPackage;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockPurchaseProvider = MockPurchaseProvider();
    mockPackage = MockPackage();
  });

  group('SettingsMixin Tests', () {
    testWidgets('showManagePremiumDialog shows dialog', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider<PurchaseProvider>.value(
              value: mockPurchaseProvider,
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SettingsView(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final settingsViewFinder = find.byType(SettingsView);
      expect(settingsViewFinder, findsOneWidget);

      // Use dynamic to avoid type cast
      final state = tester.state(settingsViewFinder);
      await (state as dynamic).showManagePremiumDialog(context);

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('changeLanguageDialog shows dialog', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider<PurchaseProvider>.value(
              value: mockPurchaseProvider,
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SettingsView(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final settingsViewFinder = find.byType(SettingsView);
      expect(settingsViewFinder, findsOneWidget);

      final state = tester.state(settingsViewFinder);
      await (state as dynamic).changeLanguageDialog(context);

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
      'changePasswordDialog shows dialog and handles password change',
      (tester) async {
        when(
          mockAuthProvider.changePassword(any),
        ).thenAnswer((_) async => true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(
                value: mockAuthProvider,
              ),
              ChangeNotifierProvider<PurchaseProvider>.value(
                value: mockPurchaseProvider,
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: SettingsView(),
              ),
            ),
          ),
        );

        final context = tester.element(find.byType(Scaffold));
        final settingsViewFinder = find.byType(SettingsView);
        expect(settingsViewFinder, findsOneWidget);

        final state = tester.state(settingsViewFinder);
        await (state as dynamic).changePasswordDialog(context);

        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.enterText(find.byType(TextField).at(0), 'newPassword');
        await tester.enterText(find.byType(TextField).at(1), 'newPassword');
        await tester.tap(find.text('Change'));
        await tester.pumpAndSettle();

        verify(mockAuthProvider.changePassword('newPassword')).called(1);
      },
    );

    testWidgets(
      'deleteAccountDialog shows dialog and handles account deletion',
      (tester) async {
        when(mockAuthProvider.deleteAccount()).thenAnswer((_) async => true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(
                value: mockAuthProvider,
              ),
              ChangeNotifierProvider<PurchaseProvider>.value(
                value: mockPurchaseProvider,
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: SettingsView(),
              ),
            ),
          ),
        );

        final context = tester.element(find.byType(Scaffold));
        final settingsViewFinder = find.byType(SettingsView);
        expect(settingsViewFinder, findsOneWidget);

        final state = tester.state(settingsViewFinder);
        await (state as dynamic).deleteAccountDialog(context);

        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        verify(mockAuthProvider.deleteAccount()).called(1);
      },
    );

    testWidgets('showPremiumDialog shows dialog', (tester) async {
      final packages = [mockPackage];
      when(mockPurchaseProvider.availablePackages).thenReturn(packages);
      when(mockPurchaseProvider.isLoading).thenReturn(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider<PurchaseProvider>.value(
              value: mockPurchaseProvider,
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SettingsView(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final settingsViewFinder = find.byType(SettingsView);
      expect(settingsViewFinder, findsOneWidget);

      final state = tester.state(settingsViewFinder);
      await (state as dynamic).showPremiumDialog(context);

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('restorePurchasesAction calls restorePurchases', (
      tester,
    ) async {
      when(mockPurchaseProvider.restorePurchases()).thenAnswer((_) async => {});

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider<PurchaseProvider>.value(
              value: mockPurchaseProvider,
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SettingsView(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final settingsViewFinder = find.byType(SettingsView);
      expect(settingsViewFinder, findsOneWidget);

      final state = tester.state(settingsViewFinder);
      await (state as dynamic).restorePurchasesAction(context);

      await tester.pumpAndSettle();

      verify(mockPurchaseProvider.restorePurchases()).called(1);
    });
  });
}
