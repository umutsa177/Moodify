import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/feature/profile/view/profile_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_view_test.mocks.dart';

@GenerateMocks([
  AuthProvider,
  SavedVideosProvider,
  SupabaseClient,
  GoTrueClient,
  User,
  UserProfile,
  Box,
])
void main() {
  late MockAuthProvider mockAuthProvider;
  late MockSavedVideosProvider mockSavedVideosProvider;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late MockUser mockUser;
  late MockUserProfile mockUserProfile;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockSavedVideosProvider = MockSavedVideosProvider();
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockUser = MockUser();
    mockUserProfile = MockUserProfile();

    // Setup Supabase mock
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(mockGoTrueClient.currentUser).thenReturn(mockUser);

    // Setup default AuthProvider behavior
    when(mockAuthProvider.currentUser).thenReturn(mockUser);
    when(mockAuthProvider.userProfile).thenReturn(mockUserProfile);
    when(mockAuthProvider.isEmailProvider()).thenReturn(true);
    when(mockAuthProvider.isGoogleProvider()).thenReturn(false);
    when(mockAuthProvider.isFacebookProvider()).thenReturn(false);

    // Setup default User behavior
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.id).thenReturn('user-123');

    // Setup default UserProfile behavior
    when(mockUserProfile.username).thenReturn('TestUser');
    when(mockUserProfile.avatarUrl).thenReturn(null);
    when(mockUserProfile.id).thenReturn('profile-123');

    // Setup default SavedVideosProvider behavior
    when(mockSavedVideosProvider.savedVideos).thenReturn([]);
    when(mockSavedVideosProvider.isLoading).thenReturn(false);
    when(mockSavedVideosProvider.isSyncing).thenReturn(false);
  });

  Widget createTestWidget({Widget? child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
        ChangeNotifierProvider<SavedVideosProvider>.value(
          value: mockSavedVideosProvider,
        ),
      ],
      child: MaterialApp(
        home: child ?? const ProfileView(),
      ),
    );
  }

  group('ProfileView Widget Tests', () {
    testWidgets('should display profile view with all components', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify main components exist
      expect(find.text(StringConstant.myProfile), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.byIcon(Icons.logout_outlined), findsOneWidget);
      expect(find.text(StringConstant.savedVideos), findsOneWidget);
    });

    testWidgets('should display user email and username', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('TestUser'), findsOneWidget);
    });

    testWidgets('should display default profile icon when no avatar', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('should display edit button for email provider', (
      tester,
    ) async {
      when(mockAuthProvider.isEmailProvider()).thenReturn(true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should not display edit button for non-email provider', (
      tester,
    ) async {
      when(mockUser.userMetadata).thenReturn({});

      when(mockAuthProvider.isEmailProvider()).thenReturn(false);
      when(mockAuthProvider.isGoogleProvider()).thenReturn(true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsNothing);
    });

    testWidgets('should display saved videos section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(StringConstant.savedVideos), findsOneWidget);
      expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    });

    testWidgets('should display search bar in saved videos', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text(StringConstant.searchSavedVideo), findsOneWidget);
    });

    testWidgets('should switch between list and grid view', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially in list view
      expect(find.byType(ListView), findsOneWidget);

      // Tap grid view button
      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pumpAndSettle();

      // Should now be in grid view
      expect(find.byType(GridView), findsOneWidget);

      // Tap list view button
      await tester.tap(find.byIcon(Icons.view_list_rounded));
      await tester.pumpAndSettle();

      // Should be back in list view
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display empty state when no videos', (tester) async {
      when(mockSavedVideosProvider.savedVideos).thenReturn([]);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
      expect(find.text(StringConstant.savedVideosEmpty), findsOneWidget);
    });

    testWidgets('should display saved videos in list', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Test Video 1',
          thumbnail: 'https://example.com/thumb1.jpg',
          duration: '5:30',
          videoUrl: 'https://example.com/video1.mp4',
          savedAt: DateTime.now(),
        ),
        SavedVideo(
          videoId: '2',
          title: 'Test Video 2',
          thumbnail: 'https://example.com/thumb2.jpg',
          duration: '3:45',
          videoUrl: 'https://example.com/video2.mp4',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockSavedVideosProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Test Video 1'), findsOneWidget);
      expect(find.text('Test Video 2'), findsOneWidget);
      expect(find.text('5:30'), findsOneWidget);
      expect(find.text('3:45'), findsOneWidget);
    });

    testWidgets('should filter videos by search query', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Flutter Tutorial',
          thumbnail: 'https://example.com/thumb1.jpg',
          duration: '5:30',
          videoUrl: 'https://example.com/video1.mp4',
          savedAt: DateTime.now(),
        ),
        SavedVideo(
          videoId: '2',
          title: 'Dart Programming',
          thumbnail: 'https://example.com/thumb2.jpg',
          duration: '3:45',
          videoUrl: 'https://example.com/video2.mp4',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockSavedVideosProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(
        find.widgetWithText(SearchBar, StringConstant.searchSavedVideo),
        'Flutter',
      );
      await tester.pumpAndSettle();

      // Should show only Flutter video
      expect(find.text('Flutter Tutorial'), findsOneWidget);
      expect(find.text('Dart Programming'), findsNothing);
    });

    testWidgets('should clear search query', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Test Video',
          thumbnail: 'https://example.com/thumb.jpg',
          duration: '5:30',
          videoUrl: 'https://example.com/video.mp4',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockSavedVideosProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter search query
      final searchBar = find.widgetWithText(
        SearchBar,
        StringConstant.searchSavedVideo,
      );
      await tester.enterText(searchBar, 'Test');
      await tester.pumpAndSettle();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Search should be cleared
      expect(find.text('Test'), findsOneWidget); // Only in video title
    });

    testWidgets('should display loading indicator when loading', (
      tester,
    ) async {
      when(mockSavedVideosProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display empty search result message', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Test Video',
          thumbnail: 'https://example.com/thumb.jpg',
          duration: '5:30',
          videoUrl: 'https://example.com/video.mp4',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockSavedVideosProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Search for non-existent video
      await tester.enterText(
        find.widgetWithText(SearchBar, StringConstant.searchSavedVideo),
        'NonExistent',
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
      expect(
        find.textContaining(StringConstant.savedVideoSearchEmpty),
        findsOneWidget,
      );
    });

    testWidgets('should remove video when delete button tapped', (
      tester,
    ) async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Test Video',
        thumbnail: 'https://example.com/thumb.jpg',
        duration: '5:30',
        videoUrl: 'https://example.com/video.mp4',
        savedAt: DateTime.now(),
      );

      when(mockSavedVideosProvider.savedVideos).thenReturn([video]);
      when(
        mockSavedVideosProvider.removeVideo(any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap delete button
      await tester.tap(find.byIcon(Icons.close_rounded).first);
      await tester.pumpAndSettle();

      // Verify removeVideo was called
      verify(mockSavedVideosProvider.removeVideo('1')).called(1);
    });

    testWidgets('should display videos in grid view', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Test Video 1',
          thumbnail: 'https://example.com/thumb1.jpg',
          duration: '5:30',
          videoUrl: 'https://example.com/video1.mp4',
          savedAt: DateTime.now(),
        ),
        SavedVideo(
          videoId: '2',
          title: 'Test Video 2',
          thumbnail: 'https://example.com/thumb2.jpg',
          duration: '3:45',
          videoUrl: 'https://example.com/video2.mp4',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockSavedVideosProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Switch to grid view
      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Test Video 1'), findsOneWidget);
      expect(find.text('Test Video 2'), findsOneWidget);
    });

    testWidgets('should display user email fallback when no username', (
      tester,
    ) async {
      when(mockUserProfile.username).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should display email prefix as username
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('should display "User" when no email or username', (
      tester,
    ) async {
      when(mockUser.email).thenReturn(null);
      when(mockUserProfile.username).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('User'), findsOneWidget);
      expect(find.text('No email'), findsOneWidget);
    });
  });

  group('ProfileView Integration Tests', () {
    testWidgets('should navigate to settings when settings button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find settings button
      final settingsButton = find.byIcon(Icons.more_vert);
      expect(settingsButton, findsOneWidget);

      // Note: Navigation testing would require NavigatorObserver mock
      // This test verifies the button exists and is tappable
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
    });

    testWidgets('should show search suggestions', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Flutter Tutorial',
          thumbnail: 'https://example.com/thumb1.jpg',
          duration: '5:30',
          videoUrl: 'https://example.com/video1.mp4',
          savedAt: DateTime.now(),
        ),
        SavedVideo(
          videoId: '2',
          title: 'Flutter Advanced',
          thumbnail: 'https://example.com/thumb2.jpg',
          duration: '3:45',
          videoUrl: 'https://example.com/video2.mp4',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockSavedVideosProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap search bar to open suggestions
      await tester.tap(
        find.widgetWithText(SearchBar, StringConstant.searchSavedVideo),
      );
      await tester.pumpAndSettle();

      // Note: SearchAnchor suggestions would need more complex testing
      // This verifies the search bar is interactive
    });

    testWidgets('should handle video removal in grid view', (tester) async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Test Video',
        thumbnail: 'https://example.com/thumb.jpg',
        duration: '5:30',
        videoUrl: 'https://example.com/video.mp4',
        savedAt: DateTime.now(),
      );

      when(mockSavedVideosProvider.savedVideos).thenReturn([video]);
      when(
        mockSavedVideosProvider.removeVideo(any),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Switch to grid view
      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pumpAndSettle();

      // Tap delete button in grid view
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      verify(mockSavedVideosProvider.removeVideo('1')).called(1);
    });
  });
}
