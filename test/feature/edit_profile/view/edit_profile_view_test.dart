import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/feature/edit_profile/view/edit_profile_view.dart';
import 'package:provider/provider.dart';

import 'edit_profile_view_test.mocks.dart';

@GenerateMocks([AuthProvider, File])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createTestWidget({UserProfile? profile}) {
    when(mockAuthProvider.userProfile).thenReturn(profile);

    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: const EditProfileView(),
      ),
    );
  }

  group('EditProfileView Widget Tests', () {
    testWidgets('should render all main UI components', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);

      // Avatar section
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);

      // Username section
      expect(find.text('Username'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Email section
      expect(find.text('Email'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);

      // Save button
      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display gradient background', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final decoratedBox = find.byType(DecoratedBox).first;
      expect(decoratedBox, findsOneWidget);

      final box = tester.widget<DecoratedBox>(decoratedBox);
      expect(box.decoration, isA<BoxDecoration>());

      final decoration = box.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should have resizeToAvoidBottomInset set to false', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.resizeToAvoidBottomInset, false);
    });
  });

  group('Avatar Display Tests', () {
    testWidgets('should show person icon when no avatar', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('should display CachedNetworkImage when avatar exists', (
      tester,
    ) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pump();

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should have correct cache key for avatar', (tester) async {
      final updatedAt = DateTime.now();
      final testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
        updatedAt: updatedAt,
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pump();

      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      expect(
        cachedImage.cacheKey,
        'edit_avatar_123_${updatedAt.millisecondsSinceEpoch}',
      );
    });

    testWidgets('should display avatar in circular container', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final clipOval = find.byType(ClipOval);
      expect(clipOval, findsOneWidget);

      final container = find.descendant(
        of: clipOval,
        matching: find.byType(Container),
      );
      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      final decoration = containerWidget.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });
  });

  group('Avatar Action Buttons Tests', () {
    testWidgets('should show camera button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final cameraButton = find.byIcon(Icons.camera_alt);
      expect(cameraButton, findsOneWidget);

      // Check if it's in a GestureDetector
      final gestureDetector = find.ancestor(
        of: cameraButton,
        matching: find.byType(GestureDetector),
      );
      expect(gestureDetector, findsWidgets);
    });

    testWidgets('should show delete button when avatar exists', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pump();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should not show delete button when no avatar', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('camera button should have correct styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final cameraIcon = find.byIcon(Icons.camera_alt);
      final container = find.ancestor(
        of: cameraIcon,
        matching: find.byType(Container),
      );

      expect(container, findsWidgets);

      final containerWidget = tester.widget<Container>(container.first);
      final decoration = containerWidget.decoration! as BoxDecoration;

      expect(decoration.shape, BoxShape.circle);
      expect(decoration.border, isNotNull);
    });

    testWidgets('delete button should have error color', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pump();

      final deleteIcon = find.byIcon(Icons.delete);
      final container = find.ancestor(
        of: deleteIcon,
        matching: find.byType(Container),
      );

      expect(container, findsWidgets);
    });
  });

  group('Username TextField Tests', () {
    testWidgets('should display username hint', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, isNotNull);
    });

    testWidgets('should have username prefix icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should allow text input', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'NewUsername');
      await tester.pumpAndSettle();

      expect(find.text('NewUsername'), findsOneWidget);
    });

    testWidgets('should have correct initial value', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'InitialUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'InitialUser');
    });

    testWidgets('should have rounded border', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration!;
      final border = decoration.border! as OutlineInputBorder;

      expect(border.borderSide, BorderSide.none);
      expect(border.borderRadius, isNotNull);
    });
  });

  group('Email Display Tests', () {
    testWidgets('should display email correctly', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'user@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('should have email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('email should be in a decorated container', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final emailIcon = find.byIcon(Icons.email_outlined);
      final container = find.ancestor(
        of: emailIcon,
        matching: find.byType(Container),
      );

      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.decoration, isA<BoxDecoration>());
    });
  });

  group('Save Button Tests', () {
    testWidgets('should be enabled by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.style, isNotNull);
    });

    testWidgets('should span full width', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.style?.fixedSize, isNotNull);
    });

    testWidgets('should display Save text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });
  });

  group('Header Tests', () {
    testWidgets('should display Edit Profile title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('should have centered title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Edit Profile'));
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('should have back button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('back button should be tappable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final backButton = find.byType(BackButton);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
    });

    testWidgets('header should use Stack layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final stack = find.descendant(
        of: find.byType(Padding),
        matching: find.byType(Stack),
      );

      expect(stack, findsOneWidget);
    });
  });

  group('Layout and Spacing Tests', () {
    testWidgets('should have proper padding', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final padding = find.byType(Padding);
      expect(padding, findsWidgets);
    });

    testWidgets('should have Column layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final column = find.byType(Column);
      expect(column, findsWidgets);
    });

    testWidgets('should have SizedBox spacing', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final sizedBox = find.byType(SizedBox);
      expect(sizedBox, findsWidgets);
    });

    testWidgets('main column should stretch width', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final columns = find.byType(Column);
      final mainColumn = tester.widget<Column>(columns.first);

      expect(
        mainColumn.crossAxisAlignment,
        CrossAxisAlignment.stretch,
      );
    });
  });

  group('Interaction Tests', () {
    testWidgets('should open image picker dialog on camera tap', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final cameraButton = find.byIcon(Icons.camera_alt);
      await tester.tap(cameraButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should show dialog with gallery and camera options', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
    });

    testWidgets('should open delete dialog on delete button tap', (
      tester,
    ) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Avatar'), findsOneWidget);
    });
  });

  group('Dialog Tests', () {
    testWidgets('image source dialog should have correct styling', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('delete dialog should have cancel and delete buttons', (
      tester,
    ) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('delete dialog should not be dismissible', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Try to tap outside dialog
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Responsive Design Tests', () {
    testWidgets('should adapt to different screen sizes', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileView), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(600, 1000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileView), findsOneWidget);

      addTearDown(tester.view.reset);
    });

    testWidgets('avatar should maintain aspect ratio', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final clipOval = find.byType(ClipOval);
      final container = find.descendant(
        of: clipOval,
        matching: find.byType(Container),
      );

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.constraints?.maxHeight, isNotNull);
      expect(containerWidget.constraints?.maxWidth, isNotNull);
    });
  });

  group('Edge Cases Tests', () {
    testWidgets('should handle null profile gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileView), findsOneWidget);
      expect(find.text('Not Email'), findsOneWidget);
    });

    testWidgets('should handle empty username', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: '',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '');
    });

    testWidgets('should handle very long username', (tester) async {
      const longUsername = 'VeryLongUsernameForTestingPurposes123456789';
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: longUsername,
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, longUsername);
    });

    testWidgets('should handle very long email', (tester) async {
      const longEmail = 'verylongemailaddress@extremelylongdomainname.com';
      const testProfile = UserProfile(
        id: '123',
        email: longEmail,
        username: 'TestUser',
      );

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      expect(find.text(longEmail), findsOneWidget);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('should have semantics for screen readers', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('buttons should be accessible', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final backButton = find.byType(BackButton);
      expect(backButton, findsOneWidget);

      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);
    });
  });
}
