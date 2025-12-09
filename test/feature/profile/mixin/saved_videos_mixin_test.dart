import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/feature/profile/mixin/saved_videos_mixin.dart';
import 'package:moodify/feature/profile/view/profile_view.dart';
import 'package:moodify/product/enum/video_view_type.dart';
import 'package:provider/provider.dart';

import 'saved_videos_mixin_test.mocks.dart';

@GenerateMocks([SavedVideosProvider])
void main() {
  late MockSavedVideosProvider mockProvider;

  setUp(() {
    mockProvider = MockSavedVideosProvider();
    when(mockProvider.savedVideos).thenReturn([]);
    when(mockProvider.isLoading).thenReturn(false);
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<SavedVideosProvider>.value(
      value: mockProvider,
      child: const MaterialApp(
        home: SavedVideos(),
      ),
    );
  }

  group('SavedVideosMixin Tests', () {
    testWidgets('initial values are correct', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin;

      expect(state.viewType, VideoViewType.list);
      expect(state.searchQuery, '');
      expect(state.searchController, isNotNull);
    });

    testWidgets('dispose works correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin;

      final controller = state.searchController;

      expect(controller, isNotNull);

      await tester.pumpWidget(Container()); // dispose tetiklenir
      await tester.pumpAndSettle();
    });

    testWidgets('filter by title works', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Flutter Tutorial',
          thumbnail: '',
          duration: '5:30',
          videoUrl: '',
          savedAt: DateTime.now(),
        ),
        SavedVideo(
          videoId: '2',
          title: 'Dart Basics',
          thumbnail: '',
          duration: '4:00',
          videoUrl: '',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin
        ..searchQuery = 'Flutter';

      final result = state.filterVideos(videos);

      expect(result.length, 1);
      expect(result.first.title, 'Flutter Tutorial');
    });

    testWidgets('filter by duration works', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'Video',
          thumbnail: '',
          duration: '10:45',
          videoUrl: '',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin
        ..searchQuery = '10:45';

      final result = state.filterVideos(videos);

      expect(result.length, 1);
      expect(result.first.duration, '10:45');
    });

    testWidgets('empty search returns all videos', (tester) async {
      final videos = [
        SavedVideo(
          videoId: '1',
          title: 'A',
          thumbnail: '',
          duration: '1',
          videoUrl: '',
          savedAt: DateTime.now(),
        ),
        SavedVideo(
          videoId: '2',
          title: 'B',
          thumbnail: '',
          duration: '2',
          videoUrl: '',
          savedAt: DateTime.now(),
        ),
      ];

      when(mockProvider.savedVideos).thenReturn(videos);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin
        ..searchQuery = '';

      expect(state.filterVideos(videos).length, 2);
    });

    testWidgets('viewType changes on icon tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin;

      expect(state.viewType, VideoViewType.list);

      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pumpAndSettle();
      expect(state.viewType, VideoViewType.grid);

      await tester.tap(find.byIcon(Icons.view_list_rounded));
      await tester.pumpAndSettle();
      expect(state.viewType, VideoViewType.list);
    });

    testWidgets('search updates searchQuery', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(SearchBar), 'Test');
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin;

      expect(state.searchQuery, 'Test');
    });

    testWidgets('clear button clears searchQuery', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(SearchBar), 'Hello');
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(SavedVideos)) as SavedVideosMixin;
      expect(state.searchQuery, 'Hello');

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(state.searchQuery, '');
    });
  });
}
