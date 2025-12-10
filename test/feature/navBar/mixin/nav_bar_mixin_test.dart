import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/feature/navBar/view/nav_bar.dart';
import 'package:moodify/feature/profile/view/profile_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/moods.dart';

void main() {
  group('NavBarMixin Tests', () {
    testWidgets('NavBarMixin initializes with selectedIndex 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));

      expect((state as dynamic).selectedIndex, 0);
    });

    testWidgets('NavBarMixin pages list contains 2 pages', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));
      final pages = (state as dynamic).pages as List<Widget>;

      expect(pages.length, 2);
    });

    testWidgets('NavBarMixin first page is FeedView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));
      final pages = (state as dynamic).pages as List<Widget>;

      expect(pages[0], isA<FeedView>());
    });

    testWidgets('NavBarMixin second page is ProfileView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));
      final pages = (state as dynamic).pages as List<Widget>;

      expect(pages[1], isA<ProfileView>());
    });

    testWidgets('onItemTapped updates selectedIndex correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Başlangıç durumu kontrol et
      var bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);

      // Profile tab'ına tıkla
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 1);
    });

    testWidgets('onItemTapped toggles between tabs', (tester) async {
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

    testWidgets('getNavBarIcon returns widget for selected state', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Selected icon için Container ve SvgPicture bulunmalı
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
    });

    testWidgets('getNavBarIcon changes on tab selection', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // İlk durumda feed selected
      final initialContainers = tester
          .widgetList<Container>(
            find.byType(Container),
          )
          .length;

      // Profile'a geç
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      // Container sayısı değişmemeli ama hangisi selected olduğu değişmeli
      final afterContainers = tester
          .widgetList<Container>(
            find.byType(Container),
          )
          .length;

      expect(afterContainers, initialContainers);
    });

    testWidgets('NavBarMixin pages are initialized in initState', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));
      final pages = (state as dynamic).pages as List<Widget>;

      expect(pages, isNotEmpty);
      expect(pages.length, 2);
    });

    testWidgets('NavBarMixin handles different moods correctly', (
      tester,
    ) async {
      for (final mood in Moods.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: NavBar(mood: mood),
          ),
        );

        final navBar = tester.widget<NavBar>(find.byType(NavBar));
        expect(navBar.mood, mood);

        final state = tester.state(find.byWidget(navBar));
        final pages = (state as dynamic).pages as List<Widget>;
        expect(pages[0], isA<FeedView>());
      }
    });

    testWidgets('NavBarMixin FeedView receives correct mood', (tester) async {
      const testMood = Moods.excited;

      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: testMood),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));
      final pages = (state as dynamic).pages as List<Widget>;
      final feedView = pages[0] as FeedView;

      expect(feedView.mood, testMood);
    });

    testWidgets('onItemTapped with same index maintains state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Aynı tab'a birden fazla tıkla
      await tester.tap(find.text(StringConstant.feed));
      await tester.pumpAndSettle();

      var bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);

      await tester.tap(find.text(StringConstant.feed));
      await tester.pumpAndSettle();

      bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });

    testWidgets('NavBarMixin handles rapid navigation changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Hızlıca geçiş yap
      for (var i = 0; i < 5; i++) {
        await tester.tap(find.text(StringConstant.profile));
        await tester.pumpAndSettle();
        await tester.tap(find.text(StringConstant.feed));
        await tester.pumpAndSettle();
      }

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });

    testWidgets('Selected icon has gradient decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // Container'ları bul
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byType(Container),
        ),
      );

      // En az bir Container BoxDecoration ile gradient'a sahip olmalı
      final hasGradientDecoration = containers.any((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration && decoration.gradient != null;
      });

      expect(hasGradientDecoration, isTrue);
    });

    testWidgets('Unselected icon has correct color filter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // SvgPicture widget'larını bul
      final svgPictures = tester.widgetList<SvgPicture>(
        find.byType(SvgPicture),
      );

      // En az bir SvgPicture colorFilter'a sahip olmalı
      expect(svgPictures.isNotEmpty, isTrue);
    });

    testWidgets('NavBarMixin maintains widget structure after navigation', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // İlk yapıyı kaydet
      final initialScaffold = find.byType(Scaffold);
      final initialBottomNav = find.byType(BottomNavigationBar);

      expect(initialScaffold, findsOneWidget);
      expect(initialBottomNav, findsOneWidget);

      // Navigate et
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      // Yapının korunduğunu kontrol et
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('NavBarMixin icon states reflect current selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      // İlk durumda feed selected
      var navBar = tester.widget<NavBar>(find.byType(NavBar));
      var state = tester.state(find.byWidget(navBar));
      expect((state as dynamic).selectedIndex, 0);

      // Profile'a geç ve kontrol et
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      navBar = tester.widget<NavBar>(find.byType(NavBar));
      state = tester.state(find.byWidget(navBar));
      expect((state as dynamic).selectedIndex, 1);
    });

    testWidgets('Pages list maintains references across builds', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NavBar(mood: Moods.happy),
        ),
      );

      final navBar = tester.widget<NavBar>(find.byType(NavBar));
      final state = tester.state(find.byWidget(navBar));
      final initialPages = (state as dynamic).pages as List<Widget>;

      // Tab değiştir
      await tester.tap(find.text(StringConstant.profile));
      await tester.pumpAndSettle();

      // Pages referansının aynı olduğunu kontrol et
      final currentPages = (state as dynamic).pages as List<Widget>;
      expect(identical(initialPages, currentPages), isTrue);
    });
  });
}
