import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/feed_response.dart';
import 'package:moodify/core/providers/feed/feed_provider.dart';
import 'package:moodify/core/providers/feed/feed_state.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/product/enum/moods.dart';
import 'package:provider/provider.dart';

import 'feed_view_test.mocks.dart';

@GenerateMocks([FeedProvider, SavedVideosProvider])
void main() {
  group('FeedView Widget Tests', () {
    late MockFeedProvider mockFeedProvider;
    late MockSavedVideosProvider mockSavedVideosProvider;

    setUp(() {
      mockFeedProvider = MockFeedProvider();
      mockSavedVideosProvider = MockSavedVideosProvider();

      // Default state
      when(mockFeedProvider.state).thenReturn(const FeedState());
      when(mockSavedVideosProvider.isVideoSaved(any)).thenReturn(false);
      when(mockSavedVideosProvider.savedVideos).thenReturn([]);
      when(mockSavedVideosProvider.isLoading).thenReturn(false);
      when(mockSavedVideosProvider.isSyncing).thenReturn(false);
    });

    Widget createTestWidget(Moods mood) {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<FeedProvider>.value(
              value: mockFeedProvider,
            ),
            ChangeNotifierProvider<SavedVideosProvider>.value(
              value: mockSavedVideosProvider,
            ),
          ],
          child: FeedView(mood: mood),
        ),
      );
    }

    testWidgets('should display app bar with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget(Moods.happy));

      expect(find.text('Happy Videos 😊'), findsOneWidget);
    });

    testWidgets('should show skeleton loader when loading and no videos', (
      tester,
    ) async {
      when(mockFeedProvider.state).thenReturn(
        const FeedState(isLoading: true),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Skeleton loader içinde Shimmer widget'ı olmalı
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should show no videos view when videos list is empty', (
      tester,
    ) async {
      when(mockFeedProvider.state).thenReturn(
        const FeedState(),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
    });

    testWidgets('should display video cards when videos are available', (
      tester,
    ) async {
      final testVideos = [
        const Video(
          uri: '/videos/1',
          name: 'Test Video 1',
          duration: 120,
          pictures: Pictures(
            sizes: [
              Size(width: 640, link: 'https://test.com/thumb1.jpg'),
            ],
          ),
          playerEmbedUrl: 'https://player.vimeo.com/video/1',
        ),
        const Video(
          uri: '/videos/2',
          name: 'Test Video 2',
          duration: 180,
          pictures: Pictures(
            sizes: [
              Size(width: 640, link: 'https://test.com/thumb2.jpg'),
            ],
          ),
          playerEmbedUrl: 'https://player.vimeo.com/video/2',
        ),
      ];

      when(mockFeedProvider.state).thenReturn(
        FeedState(videos: testVideos),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      expect(find.text('Test Video 1'), findsOneWidget);
      expect(find.text('Test Video 2'), findsOneWidget);
      expect(find.text('120 s'), findsOneWidget);
      expect(find.text('180 s'), findsOneWidget);
    });

    testWidgets('should call loadMoreVideos when scrolled to bottom', (
      tester,
    ) async {
      final testVideos = List.generate(
        15,
        (i) => Video(
          uri: '/videos/$i',
          name: 'Video $i',
          duration: 120,
          pictures: const Pictures(
            sizes: [
              Size(width: 640, link: 'https://test.com/thumb.jpg'),
            ],
          ),
          playerEmbedUrl: 'https://player.vimeo.com/video/$i',
        ),
      );

      when(mockFeedProvider.state).thenReturn(
        FeedState(
          videos: testVideos,
        ),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();

      verify(mockFeedProvider.loadMoreVideos()).called(greaterThan(0));
    });

    testWidgets('should show loading indicator at bottom when loading more', (
      tester,
    ) async {
      final testVideos = List.generate(
        5,
        (i) => Video(
          uri: '/videos/$i',
          name: 'Video $i',
          duration: 120,
          pictures: const Pictures(
            sizes: [
              Size(width: 640, link: 'https://test.com/thumb.jpg'),
            ],
          ),
          playerEmbedUrl: 'https://player.vimeo.com/video/$i',
        ),
      );

      when(mockFeedProvider.state).thenReturn(
        FeedState(
          isLoading: true,
          videos: testVideos,
        ),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // CircularProgressIndicator veya loading bar olmalı
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not show loading indicator when reached end', (
      tester,
    ) async {
      final testVideos = List.generate(
        5,
        (i) => Video(
          uri: '/videos/$i',
          name: 'Video $i',
          duration: 120,
          pictures: const Pictures(
            sizes: [
              Size(width: 640, link: 'https://test.com/thumb.jpg'),
            ],
          ),
          playerEmbedUrl: 'https://player.vimeo.com/video/$i',
        ),
      );

      when(mockFeedProvider.state).thenReturn(
        FeedState(
          videos: testVideos,
          reachedEnd: true,
        ),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      // Loading indicator olmamalı
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should call refresh when pull to refresh', (tester) async {
      when(mockFeedProvider.state).thenReturn(
        const FeedState(
          videos: [
            Video(
              uri: '/videos/1',
              name: 'Test',
              duration: 120,
              pictures: Pictures(sizes: []),
              playerEmbedUrl: 'https://test.com',
            ),
          ],
        ),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Pull to refresh
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
      );
      await tester.pump();

      verify(mockFeedProvider.refresh()).called(1);
    });

    testWidgets('should save video when save button tapped', (tester) async {
      const testVideo = Video(
        uri: '/videos/test123',
        name: 'Test Video',
        duration: 120,
        pictures: Pictures(
          sizes: [
            Size(width: 640, link: 'https://test.com/thumb.jpg'),
          ],
        ),
        playerEmbedUrl: 'https://player.vimeo.com/video/test',
      );

      when(mockFeedProvider.state).thenReturn(
        const FeedState(videos: [testVideo]),
      );

      when(mockSavedVideosProvider.isVideoSaved('test123')).thenReturn(false);

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Find and tap save button
      final saveButton = find.byIcon(Icons.bookmark_border);
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pump();

      verify(mockSavedVideosProvider.saveVideo(any)).called(1);
    });

    testWidgets('should remove video when unsave button tapped', (
      tester,
    ) async {
      const testVideo = Video(
        uri: '/videos/test123',
        name: 'Test Video',
        duration: 120,
        pictures: Pictures(
          sizes: [
            Size(width: 640, link: 'https://test.com/thumb.jpg'),
          ],
        ),
        playerEmbedUrl: 'https://player.vimeo.com/video/test',
      );

      when(mockFeedProvider.state).thenReturn(
        const FeedState(videos: [testVideo]),
      );

      when(mockSavedVideosProvider.isVideoSaved('test123')).thenReturn(true);

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Find and tap unsave button
      final unsaveButton = find.byIcon(Icons.bookmark);
      expect(unsaveButton, findsOneWidget);

      await tester.tap(unsaveButton);
      await tester.pump();

      verify(mockSavedVideosProvider.removeVideo('test123')).called(1);
    });

    testWidgets('should open video player dialog when video card tapped', (
      tester,
    ) async {
      const testVideo = Video(
        uri: '/videos/test123',
        name: 'Test Video',
        duration: 120,
        pictures: Pictures(
          sizes: [
            Size(width: 640, link: 'https://test.com/thumb.jpg'),
          ],
        ),
        playerEmbedUrl: 'https://player.vimeo.com/video/test',
      );

      when(mockFeedProvider.state).thenReturn(
        const FeedState(videos: [testVideo]),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Tap on play button
      final playButton = find.byIcon(Icons.play_arrow);
      expect(playButton, findsOneWidget);

      await tester.tap(playButton);
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Test Video'), findsOneWidget);
    });

    testWidgets('should close video player when close button tapped', (
      tester,
    ) async {
      const testVideo = Video(
        uri: '/videos/test123',
        name: 'Test Video',
        duration: 120,
        pictures: Pictures(
          sizes: [
            Size(width: 640, link: 'https://test.com/thumb.jpg'),
          ],
        ),
        playerEmbedUrl: 'https://player.vimeo.com/video/test',
      );

      when(mockFeedProvider.state).thenReturn(
        const FeedState(videos: [testVideo]),
      );

      await tester.pumpWidget(createTestWidget(Moods.happy));
      await tester.pump();

      // Open dialog
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('should display correct mood emoji in title', (tester) async {
      final moods = [
        (Moods.happy, '😊'),
        (Moods.sad, '😢'),
        (Moods.loved, '😍'),
        (Moods.calm, '😌'),
        (Moods.angry, '😡'),
      ];

      for (final (mood, emoji) in moods) {
        await tester.pumpWidget(createTestWidget(mood));
        await tester.pump();

        expect(find.textContaining(emoji), findsOneWidget);

        // Clean up
        await tester.pumpWidget(Container());
      }
    });
  });
}
