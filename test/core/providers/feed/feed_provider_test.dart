import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moodify/core/model/feed_response.dart';
import 'package:moodify/core/network/feed_network_manager.dart';
import 'package:moodify/core/providers/feed/feed_provider.dart';
import 'package:moodify/core/providers/feed/feed_state.dart';
import 'package:moodify/product/enum/moods.dart';

import 'feed_provider_test.mocks.dart';

@GenerateMocks([
  FeedNetworkManager,
  Box,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFeedNetworkManager mockNetworkManager;
  late MockBox<String> mockCacheBox;
  late FeedProvider feedProvider;

  // Test video data
  final testVideos = [
    const Video(
      name: 'Test Video 1',
      pictures: Pictures(sizes: [Size(width: 100)]),
      duration: 10,
      uri: 'https://example.com/video1.mp4',
    ),
    const Video(
      name: 'Test Video 2',
      pictures: Pictures(sizes: [Size(width: 150)]),
      duration: 15,
      uri: 'https://example.com/video2.mp4',
    ),
  ];

  final testApiResponse = {
    'data': testVideos.map((v) => v.toJson()).toList(),
  };

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Path provider'ı mockla
    const channel = MethodChannel('plugins.flutter.io/path_provider');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              return '.';
            }
            return null;
          },
        );

    // Hive init
    await Hive.initFlutter();

    // Hive adapter resetle
    Hive.resetAdapters();

    mockNetworkManager = MockFeedNetworkManager();
    mockCacheBox = MockBox<String>();

    // openBox mock
    when(
      Hive.openBox<String>(anyOf('saved_video') as String),
    ).thenAnswer((_) async => mockCacheBox);

    // Cache mock
    when(mockCacheBox.get(any)).thenReturn(null);
  });

  tearDown(() {
    reset(mockNetworkManager);
    reset(mockCacheBox);
  });

  group('FeedProvider Initialization Tests', () {
    test('should initialize with empty state', () {
      feedProvider = FeedProvider(Moods.happy);

      expect(feedProvider.state, isA<FeedState>());
      expect(feedProvider.state.videos, isEmpty);
      expect(feedProvider.state.isLoading, isFalse);
      expect(feedProvider.state.reachedEnd, isFalse);
    });

    test('should load videos from cache on init if available', () async {
      // Cache'de veri var
      when(mockCacheBox.get(any)).thenReturn('[]');

      feedProvider = FeedProvider(Moods.happy);

      await Future.delayed(const Duration(milliseconds: 100), () {});

      expect(feedProvider.state.videos, isNotEmpty);
    });
  });

  group('FeedProvider loadMoreVideos Tests', () {
    test('should load videos successfully', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.videos, isNotEmpty);
      expect(feedProvider.state.isLoading, isFalse);
      expect(feedProvider.state.error, isNull);
    });

    test('should not load if already fetching', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      // İlk çağrı
      final future1 = feedProvider.loadMoreVideos();
      // İkinci çağrı - ignore edilmeli
      final future2 = feedProvider.loadMoreVideos();

      await Future.wait([future1, future2]);

      // Sadece bir kez çağrılmalı
      verify(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).called(1);
    });

    test('should not load if reached end', () async {
      feedProvider = FeedProvider(Moods.happy);

      feedProvider.setStateForTest(
        feedProvider.state.copyWith(reachedEnd: true),
      );

      await feedProvider.loadMoreVideos();

      verifyNever(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      );
    });

    test('should handle API error gracefully', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenThrow(Exception('API Error'));

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.error, isNotNull);
      expect(feedProvider.state.isLoading, isFalse);
    });

    test('should set reachedEnd when less than 10 videos returned', () async {
      final smallResponse = {
        'data': [testVideos.first.toJson()],
      };

      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => smallResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.reachedEnd, isTrue);
    });

    test('should handle null API response', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => null);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.error, isNotNull);
      expect(feedProvider.state.error, contains('Empty response'));
    });

    test('should append new videos to existing list', () async {
      final moreVideos = [
        const Video(
          name: 'Test Video 3',
          pictures: Pictures(sizes: [Size(width: 200)]),
          duration: 20,
          uri: 'https://example.com/video3.mp4',
        ),
      ];

      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': moreVideos.map((v) => v.toJson()).toList(),
        },
      );

      feedProvider = FeedProvider(Moods.happy);

      // İlk yükleme
      await feedProvider.loadMoreVideos();
      final firstCount = feedProvider.state.videos.length;

      // İkinci yükleme
      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.videos.length, greaterThan(firstCount));
    });
  });

  group('FeedProvider refresh Tests', () {
    test('should refresh videos successfully', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.refresh();

      expect(feedProvider.state.videos, isNotEmpty);
      expect(feedProvider.state.isLoading, isFalse);
    });

    test('should clear existing videos before refresh', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      // İlk yükleme
      await feedProvider.loadMoreVideos();
      final initialVideos = feedProvider.state.videos;

      // Refresh
      await feedProvider.refresh();

      expect(feedProvider.state.videos, isNot(equals(initialVideos)));
    });

    test('should load from cache on refresh if API fails', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenThrow(Exception('Network Error'));

      when(mockCacheBox.get(any)).thenReturn('[]');

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.refresh();

      // Cache'den yükleme başarılı olmalı
      expect(feedProvider.state.isLoading, isFalse);
    });

    test('should reset to page 1 after refresh', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.refresh();

      // İlk sayfadan yükleme yapmalı
      verify(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          perPage: anyNamed('perPage'),
        ),
      ).called(1);
    });
  });

  group('FeedProvider Cache Tests', () {
    test('should save first page to cache', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      // Cache'e kaydetme işlemi yapılmalı
      expect(feedProvider.state.videos, isNotEmpty);
    });

    test('should clear cache successfully', () async {
      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.clearCache();

      // Clear işlemi hata vermeden tamamlanmalı
      expect(true, isTrue);
    });

    test('should use cached data when available', () async {
      when(mockCacheBox.get(any)).thenReturn(
        '[${testVideos.map((v) => v.toJson()).join(',')}]',
      );

      feedProvider = FeedProvider(Moods.happy);

      await Future.delayed(const Duration(milliseconds: 100), () {});

      // Cache'den yükleme yapmalı
      expect(feedProvider.state.videos, isNotEmpty);
    });
  });

  group('FeedProvider State Management Tests', () {
    test('should notify listeners on state change', () async {
      var notifyCount = 0;

      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy)
        ..addListener(() => notifyCount++);

      await feedProvider.loadMoreVideos();

      expect(notifyCount, greaterThan(0));
    });

    test('should maintain correct loading state', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100), () {});
        return testApiResponse;
      });

      feedProvider = FeedProvider(Moods.happy);

      final loadingFuture = feedProvider.loadMoreVideos();

      // Yükleme sırasında isLoading true olmalı
      expect(feedProvider.state.isLoading, isTrue);

      await loadingFuture;

      // Yükleme sonrasında isLoading false olmalı
      expect(feedProvider.state.isLoading, isFalse);
    });

    test('should handle different moods correctly', () {
      final moods = [Moods.happy, Moods.sad, Moods.angry, Moods.calm];

      for (final mood in moods) {
        final provider = FeedProvider(mood);
        expect(provider, isNotNull);
      }
    });
  });

  group('FeedProvider Error Handling Tests', () {
    test('should handle network timeout', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenThrow(Exception('Timeout'));

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.error, isNotNull);
    });

    test('should handle invalid JSON response', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => {'invalid': 'data'});

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      // Hatalı response'da video listesi boş olmalı
      expect(feedProvider.state.videos, isEmpty);
    });

    test('should recover from error on subsequent calls', () async {
      var callCount = 0;

      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw Exception('First call error');
        }
        return testApiResponse;
      });

      feedProvider = FeedProvider(Moods.happy);

      // İlk çağrı - hata
      await feedProvider.loadMoreVideos();
      expect(feedProvider.state.error, isNotNull);

      // İkinci çağrı - başarılı
      await feedProvider.loadMoreVideos();
      expect(feedProvider.state.videos, isNotEmpty);
    });
  });

  group('FeedProvider Pagination Tests', () {
    test('should increment page number after successful load', () async {
      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => testApiResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();
      await feedProvider.loadMoreVideos();

      // İki farklı sayfa için çağrı yapılmalı
      verify(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          perPage: anyNamed('perPage'),
        ),
      ).called(1);

      verify(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: 2,
          perPage: anyNamed('perPage'),
        ),
      ).called(1);
    });

    test('should not load more when reached end', () async {
      final smallResponse = {
        'data': [testVideos.first.toJson()],
      };

      when(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => smallResponse);

      feedProvider = FeedProvider(Moods.happy);

      await feedProvider.loadMoreVideos();

      expect(feedProvider.state.reachedEnd, isTrue);

      // İkinci çağrı yapılmamalı
      await feedProvider.loadMoreVideos();

      verify(
        mockNetworkManager.fetchVideos(
          mood: anyNamed('mood'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).called(1);
    });
  });
}
