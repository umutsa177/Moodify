import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'saved_videos_provider_test.mocks.dart';

@GenerateMocks([
  Box,
  SupabaseClient,
  GoTrueClient,
  User,
  SupabaseQueryBuilder,
  PostgrestFilterBuilder,
  PostgrestTransformBuilder,
])
void main() {
  late MockBox<SavedVideo> mockBox;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late MockUser mockUser;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder<dynamic> mockFilterBuilder;

  setUp(() {
    mockBox = MockBox<SavedVideo>();
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockUser = MockUser();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();

    // Setup Supabase mocks
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(mockGoTrueClient.currentUser).thenReturn(mockUser);
    when(mockUser.id).thenReturn('user-123');
  });

  group('SavedVideosProvider Unit Tests', () {
    test('should initialize with empty list', () {
      when(mockBox.values).thenReturn([]);

      final provider = SavedVideosProvider();

      expect(provider.savedVideos, isEmpty);
      expect(provider.isLoading, true); // Initially loading
      expect(provider.isSyncing, false);
    });

    test('should load videos from cache on init', () async {
      final video1 = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      final video2 = SavedVideo(
        videoId: '2',
        title: 'Video 2',
        thumbnail: 'thumb2.jpg',
        duration: '3:45',
        videoUrl: 'video2.mp4',
        savedAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      when(mockBox.values).thenReturn([video1, video2]);

      final provider = SavedVideosProvider();
      await Future<void>.delayed(Duration.zero); // Allow init to complete

      expect(provider.savedVideos.length, 2);
      expect(provider.savedVideos.first.videoId, '1'); // Sorted by savedAt
    });

    test('should check if video is saved', () {
      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      when(mockBox.values).thenReturn([video]);

      final provider = SavedVideosProvider();

      expect(provider.isVideoSaved('1'), true);
      expect(provider.isVideoSaved('2'), false);
    });

    test('should save video locally', () async {
      when(mockBox.values).thenReturn([]);
      when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

      final provider = SavedVideosProvider();

      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      await provider.saveVideo(video);

      verify(mockBox.put('1', video)).called(1);
      expect(provider.savedVideos.length, 1);
      expect(provider.savedVideos.first.videoId, '1');
    });

    test('should not save duplicate video', () async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      when(mockBox.values).thenReturn([video]);

      final provider = SavedVideosProvider();

      // Try to save the same video again
      await provider.saveVideo(video);

      // Should not be called because video already exists
      verifyNever(mockBox.put(any, any));
    });

    test('should remove video locally', () async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      when(mockBox.values).thenReturn([video]);
      when(mockBox.delete(any)).thenAnswer((_) async => Future.value());

      final provider = SavedVideosProvider();

      await provider.removeVideo('1');

      verify(mockBox.delete('1')).called(1);
      expect(provider.savedVideos.isEmpty, true);
    });

    test('should clear all videos', () async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      when(mockBox.values).thenReturn([video]);
      when(mockBox.clear()).thenAnswer((_) async => 1);

      final provider = SavedVideosProvider();

      await provider.clearAll();

      verify(mockBox.clear()).called(1);
      expect(provider.savedVideos.isEmpty, true);
    });

    test('should sort videos by savedAt in descending order', () async {
      final now = DateTime.now();
      final video1 = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: now.subtract(const Duration(days: 2)),
      );

      final video2 = SavedVideo(
        videoId: '2',
        title: 'Video 2',
        thumbnail: 'thumb2.jpg',
        duration: '3:45',
        videoUrl: 'video2.mp4',
        savedAt: now,
      );

      final video3 = SavedVideo(
        videoId: '3',
        title: 'Video 3',
        thumbnail: 'thumb3.jpg',
        duration: '8:15',
        videoUrl: 'video3.mp4',
        savedAt: now.subtract(const Duration(days: 1)),
      );

      when(mockBox.values).thenReturn([video1, video2, video3]);

      final provider = SavedVideosProvider();
      await Future<void>.delayed(Duration.zero);

      expect(provider.savedVideos.length, 3);
      expect(provider.savedVideos[0].videoId, '2'); // Most recent
      expect(provider.savedVideos[1].videoId, '3');
      expect(provider.savedVideos[2].videoId, '1'); // Oldest
    });

    test('should handle empty box on initialization', () {
      when(mockBox.values).thenReturn([]);

      final provider = SavedVideosProvider();

      expect(provider.savedVideos, isEmpty);
      expect(provider.isLoading, true);
    });

    test('should update isLoading state during initialization', () async {
      when(mockBox.values).thenReturn([]);

      final provider = SavedVideosProvider();

      expect(provider.isLoading, true);

      await Future.delayed(const Duration(milliseconds: 100), () {});

      expect(provider.isLoading, false);
    });

    test('should notify listeners when video is added', () async {
      when(mockBox.values).thenReturn([]);
      when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

      final provider = SavedVideosProvider();
      var notificationCount = 0;

      provider.addListener(() {
        notificationCount++;
      });

      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      await provider.saveVideo(video);

      expect(notificationCount, greaterThan(0));
    });

    test('should notify listeners when video is removed', () async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      when(mockBox.values).thenReturn([video]);
      when(mockBox.delete(any)).thenAnswer((_) async => Future.value());

      final provider = SavedVideosProvider();
      var notificationCount = 0;

      provider.addListener(() {
        notificationCount++;
      });

      await provider.removeVideo('1');

      expect(notificationCount, greaterThan(0));
    });

    test('should notify listeners when all videos are cleared', () async {
      final video = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      when(mockBox.values).thenReturn([video]);
      when(mockBox.clear()).thenAnswer((_) async => 1);

      final provider = SavedVideosProvider();
      var notificationCount = 0;

      provider.addListener(() {
        notificationCount++;
      });

      await provider.clearAll();

      expect(notificationCount, greaterThan(0));
    });

    test('should handle multiple videos with same savedAt', () async {
      final now = DateTime.now();
      final video1 = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: now,
      );

      final video2 = SavedVideo(
        videoId: '2',
        title: 'Video 2',
        thumbnail: 'thumb2.jpg',
        duration: '3:45',
        videoUrl: 'video2.mp4',
        savedAt: now,
      );

      when(mockBox.values).thenReturn([video1, video2]);

      final provider = SavedVideosProvider();
      await Future<void>.delayed(Duration.zero);

      expect(provider.savedVideos.length, 2);
    });

    test('should maintain video data integrity', () async {
      final video = SavedVideo(
        videoId: 'test-123',
        title: 'Test Video',
        thumbnail: 'https://example.com/thumb.jpg',
        duration: '10:25',
        videoUrl: 'https://example.com/video.mp4',
        savedAt: DateTime(2024, 1, 15),
      );

      when(mockBox.values).thenReturn([video]);

      final provider = SavedVideosProvider();
      await Future<void>.delayed(Duration.zero);

      final savedVideo = provider.savedVideos.first;
      expect(savedVideo.videoId, 'test-123');
      expect(savedVideo.title, 'Test Video');
      expect(savedVideo.thumbnail, 'https://example.com/thumb.jpg');
      expect(savedVideo.duration, '10:25');
      expect(savedVideo.videoUrl, 'https://example.com/video.mp4');
      expect(savedVideo.savedAt, DateTime(2024, 1, 15));
    });

    test('should handle video removal that does not exist', () async {
      when(mockBox.values).thenReturn([]);
      when(mockBox.delete(any)).thenAnswer((_) async => Future.value());

      final provider = SavedVideosProvider();

      // Try to remove non-existent video
      await provider.removeVideo('non-existent');

      verify(mockBox.delete('non-existent')).called(1);
      expect(provider.savedVideos.isEmpty, true);
    });

    test('should maintain list after operations', () async {
      when(mockBox.values).thenReturn([]);
      when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());
      when(mockBox.delete(any)).thenAnswer((_) async => Future.value());

      final provider = SavedVideosProvider();

      // Add videos
      final video1 = SavedVideo(
        videoId: '1',
        title: 'Video 1',
        thumbnail: 'thumb1.jpg',
        duration: '5:30',
        videoUrl: 'video1.mp4',
        savedAt: DateTime.now(),
      );

      final video2 = SavedVideo(
        videoId: '2',
        title: 'Video 2',
        thumbnail: 'thumb2.jpg',
        duration: '3:45',
        videoUrl: 'video2.mp4',
        savedAt: DateTime.now(),
      );

      await provider.saveVideo(video1);
      await provider.saveVideo(video2);

      expect(provider.savedVideos.length, 2);

      // Remove one video
      await provider.removeVideo('1');

      expect(provider.savedVideos.length, 1);
      expect(provider.savedVideos.first.videoId, '2');
    });
  });

  group('SavedVideosProvider Supabase Sync Tests', () {
    test('should sync with cloud when user is logged in', () async {
      when(mockBox.values).thenReturn([]);
      when(mockSupabaseClient.from(any)).thenReturn(mockQueryBuilder);
      when(mockQueryBuilder.select(any)).thenReturn(
        mockFilterBuilder as PostgrestFilterBuilder<List<Map<String, dynamic>>>,
      );
      when(mockFilterBuilder.eq(any, any)).thenReturn(mockFilterBuilder);
      when(
        mockFilterBuilder.order(any, ascending: anyNamed('ascending')),
      ).thenReturn(mockFilterBuilder);

      await Future.delayed(const Duration(milliseconds: 100), () {});

      // Sync should be attempted
      verify(mockSupabaseClient.from('saved_videos')).called(greaterThan(0));
    });

    test('should not sync when user is not logged in', () async {
      when(mockGoTrueClient.currentUser).thenReturn(null);
      when(mockBox.values).thenReturn([]);

      final provider = SavedVideosProvider();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(provider.isSyncing, false);
    });

    test('should handle sync errors gracefully', () async {
      when(mockBox.values).thenReturn([]);
      when(mockSupabaseClient.from(any)).thenThrow(Exception('Network error'));

      final provider = SavedVideosProvider();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Should not crash and should continue with local data
      expect(provider.savedVideos, isEmpty);
      expect(provider.isLoading, false);
    });
  });
}
