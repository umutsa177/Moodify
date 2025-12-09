import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/feature/edit_profile/view/edit_profile_view.dart';
import 'package:provider/provider.dart';

import 'edit_profile_mixin_test.mocks.dart';

@GenerateMocks([AuthProvider, ImagePicker])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createTestWidget({UserProfile? profile}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: const EditProfileView(),
      ),
    );
  }

  group('EditProfileMixin Initialization Tests', () {
    testWidgets('should initialize with empty username when profile is null', (
      tester,
    ) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textField = find.byType(TextField).first;
      final textFieldWidget = tester.widget<TextField>(textField);

      expect(textFieldWidget.controller?.text, '');
    });

    testWidgets('should initialize with profile username when profile exists', (
      tester,
    ) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField).first;
      final textFieldWidget = tester.widget<TextField>(textField);

      expect(textFieldWidget.controller?.text, 'TestUser');
    });

    testWidgets('should initialize isLoading as false', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Save button should be enabled (not showing loading)
      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);

      final button = tester.widget<ElevatedButton>(saveButton);
      expect(button.onPressed, isNotNull);
    });
  });

  group('Image Selection Tests', () {
    testWidgets('should show image source dialog when camera button tapped', (
      tester,
    ) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap camera button
      final cameraButton = find.byIcon(Icons.camera_alt);
      expect(cameraButton, findsOneWidget);

      await tester.tap(cameraButton);
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Choose Image Source'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
    });

    testWidgets('should close dialog when gallery option selected', (
      tester,
    ) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      // Tap gallery option
      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('Delete Avatar Tests', () {
    testWidgets('should show delete button when avatar exists', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Delete button should be visible
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);
    });

    testWidgets('should not show delete button when no avatar', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Delete button should not be visible
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsNothing);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pump();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Confirmation dialog should appear
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Avatar'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should dismiss dialog when cancel tapped', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Open delete dialog
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Tap cancel
      await tester.tap(find.text('Cancel'));
      await tester.pump();

      // Dialog should be closed
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(mockAuthProvider.deleteAvatar());
    });
  });

  group('Save Profile Tests', () {
    testWidgets('should show error when username is empty', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Clear username field
      final textField = find.byType(TextField).first;
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.byType(ElevatedButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should not call updateProfile
      verifyNever(
        mockAuthProvider.updateProfile(username: anyNamed('username')),
      );
    });

    testWidgets('should show loading state when saving', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'OldName',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);
      when(mockAuthProvider.updateProfile(username: 'NewName')).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(seconds: 1), () {});
        return true;
      });
      when(mockAuthProvider.refreshProfile()).thenAnswer((_) async {
        return;
      });

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Enter new username
      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'NewName');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.byType(ElevatedButton);
      await tester.tap(saveButton);
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable save button during loading', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);
      when(mockAuthProvider.updateProfile(username: 'NewName')).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(seconds: 1), () {});
        return true;
      });
      when(mockAuthProvider.refreshProfile()).thenAnswer((_) async {
        return;
      });

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Enter new username
      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'NewName');
      await tester.pumpAndSettle();

      // Tap save button
      final saveButton = find.byType(ElevatedButton);
      await tester.tap(saveButton);
      await tester.pump();

      // Button should be disabled
      final button = tester.widget<ElevatedButton>(saveButton);
      expect(button.onPressed, isNull);
    });
  });

  group('Email Display Tests', () {
    testWidgets('should display email as read-only', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Email should be displayed
      expect(find.text('test@example.com'), findsOneWidget);

      // Email field should not be a TextField (read-only)
      final emailContainer = find.byIcon(Icons.email_outlined);
      expect(emailContainer, findsOneWidget);
    });

    testWidgets('should show placeholder when email is null', (tester) async {
      const testProfile = UserProfile(
        id: '123',
        email: '',
        username: 'TestUser',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Should show "Not Email" placeholder
      expect(find.text('Not Email'), findsOneWidget);
    });
  });

  group('UI Component Tests', () {
    testWidgets('should display edit profile header', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('should display back button', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('should display username label', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('should display email label', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should display save button', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('should display avatar placeholder when no avatar', (
      tester,
    ) async {
      const testProfile = UserProfile(
        id: '123',
        email: 'test@example.com',
        username: 'TestUser',
      );

      when(mockAuthProvider.userProfile).thenReturn(testProfile);

      await tester.pumpWidget(createTestWidget(profile: testProfile));
      await tester.pumpAndSettle();

      // Should show person icon as placeholder
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });
  });

  group('Dispose Tests', () {
    testWidgets('should dispose controllers properly', (tester) async {
      when(mockAuthProvider.userProfile).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Dispose the widget
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // No errors should occur
    });
  });
}
