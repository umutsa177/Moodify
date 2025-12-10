import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodify/feature/navBar/view/nav_bar.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/moods.dart';

void main() {
  group('NavBar Widget Tests', () {
    testWidgets('NavBar renders correctly with initial state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Scaffold ve BottomNavigationBar'ın varlığını kontrol et
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('NavBar shows two navigation items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // BottomNavigationBar'da 2 item olduğunu kontrol et
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.items.length, 2);
    });

    testWidgets('NavBar displays feed label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Feed label'ının görünür olduğunu kontrol et
      expect(find.text(StringConstant.feed), findsOneWidget);
    });

    testWidgets('NavBar displays profile label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Profile label'ının görünür olduğunu kontrol et
      expect(find.text(StringConstant.profile), findsOneWidget);
    });

    testWidgets('NavBar switches to profile when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // İkinci tab'a (Profile) tıkla
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      // BottomNavigationBar'ın currentIndex'inin 1 olduğunu kontrol et
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 1);
    });

    testWidgets('NavBar switches to feed when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Önce Profile'a geç
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      // Sonra Feed'e geri dön
      await tester.tap(find.text(StringConstant.feed));
      await tester.pumpAndSettle();

      // BottomNavigationBar'ın currentIndex'inin 0 olduğunu kontrol et
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });

    testWidgets('NavBar has ClipRRect with border radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // ClipRRect'in varlığını kontrol et
      expect(find.byType(ClipRRect), findsWidgets);
    });

    testWidgets('NavBar extendBody is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBody, true);
    });

    testWidgets('NavBar resizeToAvoidBottomInset is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.resizeToAvoidBottomInset, false);
    });

    testWidgets('NavBar receives different moods correctly', (tester) async {
      for (final mood in Moods.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: NavBar(mood: mood),
          ),
        );

        expect(find.byType(NavBar), findsOneWidget);

        // Her mood için widget'ın doğru çalıştığını kontrol et
        await tester.pumpAndSettle();
      }
    });

    testWidgets('NavBar initial index is 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });

    testWidgets('NavBar maintains state during navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Profile'a geç
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      var bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 1);

      // Feed'e geri dön
      await tester.tap(find.text(StringConstant.feed));
      await tester.pumpAndSettle();

      bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });

    testWidgets('NavBar onTap callback works correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // İkinci item'a tıkla
      await tester.tap(find.text(StringConstant.profile));
      await tester.pump();

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      expect(bottomNavBar.onTap, isNotNull);
    });

    testWidgets('NavBar bottom navigation items have correct icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Her item'ın icon'u olduğunu kontrol et
      for (final item in bottomNavBar.items) {
        expect(item.icon, isNotNull);
        expect(item.label, isNotNull);
      }
    });
  });
}
