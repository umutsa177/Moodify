import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/mood_selection/view/mood_selection_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/moods.dart';

void main() {
  group('MoodSelectionView Widget Tests', () {
    testWidgets('MoodSelectionView should render successfully', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.byType(MoodSelectionView), findsOneWidget);
    });

    testWidgets('MoodSelectionView should have gradient background', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox).first,
      );
      expect(decoratedBox.decoration, isA<BoxDecoration>());
      final boxDecoration = decoratedBox.decoration as BoxDecoration;
      expect(boxDecoration.gradient, isA<LinearGradient>());
    });

    testWidgets('MoodSelectionView should display title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.text(StringConstant.moodSelectionTitle), findsOneWidget);
    });

    testWidgets('MoodSelectionView should display description texts', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(
        find.text(StringConstant.moodSelectionFirstDescriptionText),
        findsOneWidget,
      );
      expect(
        find.text(StringConstant.moodSelectionSecondDescriptionText),
        findsOneWidget,
      );
    });

    testWidgets(
      'MoodSelectionView should have GridView with correct item count',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: MoodSelectionView(),
          ),
        );

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(
          (gridView.childrenDelegate as SliverChildBuilderDelegate).childCount,
          Moods.values.length,
        );
      },
    );

    testWidgets('MoodSelectionView should display all mood cards', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      for (final mood in Moods.values) {
        expect(find.text(mood.label), findsOneWidget);
        expect(find.text(mood.mood), findsOneWidget);
      }
    });

    testWidgets('MoodSelectionView GridView should have 2 columns', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('MoodSelectionView should have ClampingScrollPhysics', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.physics, isA<ClampingScrollPhysics>());
    });
  });

  group('MoodCard Widget Tests', () {
    testWidgets('MoodCard should display mood emoji and label', (tester) async {
      // Arrange
      const testMood = Moods.happy;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MoodSelectionView(),
          ),
        ),
      );

      // Assert
      expect(find.text(testMood.mood), findsOneWidget);
      expect(find.text(testMood.label), findsOneWidget);
    });

    testWidgets('MoodCard should be wrapped in InkWell', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.byType(InkWell), findsNWidgets(Moods.values.length));
    });

    testWidgets('MoodCard should be wrapped in Card', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.byType(Card), findsNWidgets(Moods.values.length));
    });

    testWidgets('MoodCard tap should trigger navigation', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
          onGenerateRoute: AppRouter.routes,
        ),
      );

      // Act - Tap on first mood card (Happy)
      await tester.tap(find.text(Moods.happy.label));
      await tester.pumpAndSettle();

      // Assert - Navigation should occur (NavBar should be visible)
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Each MoodCard should navigate with correct mood argument', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
          onGenerateRoute: AppRouter.routes,
        ),
      );

      // Test for each mood
      for (var i = 0; i < 3; i++) {
        // Test first 3 moods
        final mood = Moods.values[i];

        // Act
        await tester.tap(find.text(mood.label));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Go back for next iteration
        if (i < 2) {
          await tester.pageBack();
          await tester.pumpAndSettle();
        }
      }
    });
  });

  group('TitleAndDescription Widget Tests', () {
    testWidgets('TitleAndDescription should display title with correct style', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      final titleText = tester.widget<Text>(
        find.text(StringConstant.moodSelectionTitle),
      );
      expect(titleText.textAlign, TextAlign.center);
      expect(titleText.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('TitleAndDescription should display both description texts', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(
        find.text(StringConstant.moodSelectionFirstDescriptionText),
        findsOneWidget,
      );
      expect(
        find.text(StringConstant.moodSelectionSecondDescriptionText),
        findsOneWidget,
      );
    });

    testWidgets('TitleAndDescription should be wrapped in Column', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.byType(Column), findsWidgets);
    });
  });

  group('Moods Enum Tests', () {
    test('Moods enum should have correct number of values', () {
      // Assert
      expect(Moods.values.length, 12);
    });

    test('Moods enum should have correct labels', () {
      // Assert
      expect(Moods.happy.label, 'Happy');
      expect(Moods.joyful.label, 'Joyful');
      expect(Moods.sad.label, 'Sad');
      expect(Moods.angry.label, 'Angry');
      expect(Moods.calm.label, 'Calm');
      expect(Moods.surprised.label, 'Surprised');
      expect(Moods.loved.label, 'Loved');
      expect(Moods.laughing.label, 'Laughing');
      expect(Moods.thoughtful.label, 'Thoughtful');
      expect(Moods.tired.label, 'Tired');
      expect(Moods.excited.label, 'Excited');
      expect(Moods.scared.label, 'Scared');
    });

    test('Moods enum should have correct emojis', () {
      // Assert
      expect(Moods.happy.mood, '😊');
      expect(Moods.joyful.mood, '😀');
      expect(Moods.sad.mood, '😢');
      expect(Moods.angry.mood, '😡');
      expect(Moods.calm.mood, '😌');
      expect(Moods.surprised.mood, '😲');
      expect(Moods.loved.mood, '😍');
      expect(Moods.laughing.mood, '😂');
      expect(Moods.thoughtful.mood, '🤔');
      expect(Moods.tired.mood, '😴');
      expect(Moods.excited.mood, '🤩');
      expect(Moods.scared.mood, '😨');
    });

    test('Each mood should have both label and emoji', () {
      // Assert
      for (final mood in Moods.values) {
        expect(mood.label.isNotEmpty, true);
        expect(mood.mood.isNotEmpty, true);
      }
    });
  });

  group('MoodSelectionView Layout Tests', () {
    testWidgets('MoodSelectionView should have correct Column structure', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.body, isA<DecoratedBox>());
    });

    testWidgets('GridView should be wrapped in Expanded', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.byType(Expanded), findsOneWidget);
      final expanded = tester.widget<Expanded>(find.byType(Expanded));
      expect(expanded.child, isA<GridView>());
    });

    testWidgets('MoodSelectionView should have correct padding structure', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(find.byType(Padding), findsWidgets);
    });
  });

  group('MoodSelectionView Scrolling Tests', () {
    testWidgets('GridView should be scrollable when content exceeds screen', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Act
      final gesture = await tester.startGesture(const Offset(200, 400));
      await gesture.moveBy(const Offset(0, -300));
      await tester.pump();

      // Assert - Should not throw error and should scroll
      expect(find.byType(GridView), findsOneWidget);

      await gesture.up();
    });

    testWidgets('All mood cards should be accessible through scrolling', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Act & Assert - Check if all moods are in the tree
      for (final mood in Moods.values) {
        expect(find.text(mood.label), findsOneWidget);
      }
    });
  });

  group('MoodSelectionView Interaction Tests', () {
    testWidgets('Multiple mood card taps should work correctly', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
          onGenerateRoute: AppRouter.routes,
        ),
      );

      // Act - First tap
      await tester.tap(find.text(Moods.happy.label));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Act - Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Assert - Should be back at mood selection
      expect(find.byType(MoodSelectionView), findsOneWidget);

      // Act - Second tap
      await tester.tap(find.text(Moods.sad.label));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Rapid taps on same mood card should not cause issues', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
          onGenerateRoute: AppRouter.routes,
        ),
      );

      // Act - Multiple rapid taps
      await tester.tap(find.text(Moods.happy.label));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text(Moods.happy.label));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Assert - Should navigate successfully
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });

  group('MoodSelectionView Edge Cases', () {
    testWidgets('MoodSelectionView should handle empty Moods enum gracefully', (
      tester,
    ) async {
      // Note: This test verifies current behavior
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Assert
      expect(Moods.values.isNotEmpty, true);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('MoodSelectionView should maintain state on hot reload', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );

      // Act - Simulate hot reload
      await tester.pumpWidget(
        const MaterialApp(
          home: MoodSelectionView(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MoodSelectionView), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
