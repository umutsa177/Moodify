import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moodify/core/model/feed_response.dart';
import 'package:moodify/core/network/feed_network_manager.dart';
import 'package:moodify/core/providers/feed/feed_state.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/enum/moods.dart';

class FeedProvider with ChangeNotifier {
  FeedProvider(this._mood) {
    unawaited(_init());
  }

  final Moods _mood;
  final _service = FeedNetworkManager();

  FeedState _state = const FeedState();
  FeedState get state => _state;

  int _currentPage = 1;
  bool _fetching = false;

  // Cache constants
  static const String _cacheBoxName = 'feed_first_page_cache';
  static final Duration _cacheValidDuration = Duration(
    hours: DoubleConstant.two.toInt(),
  );
  late Box<String> _cacheBox;

  Future<void> _init() async {
    // Open cache box (String type for JSON storage)
    if (!Hive.isBoxOpen(_cacheBoxName)) {
      _cacheBox = await Hive.openBox<String>(_cacheBoxName);
    } else {
      _cacheBox = Hive.box<String>(_cacheBoxName);
    }

    // Try to load from cache first
    final cachedData = await _loadFromCache();

    if (cachedData != null && cachedData.isNotEmpty) {
      // Show cached data immediately (instant UI)
      _state = _state.copyWith(videos: cachedData);
      notifyListeners();

      // Start from page 2 for next load
      _currentPage = 2;

      // Check if cache is stale, refresh in background if needed
      if (_isCacheStale()) {
        await _refreshFirstPage();
      }
    } else {
      // No cache, fetch first page from API
      await loadMoreVideos();
    }
  }

  // Get cache key for current mood
  String _getCacheKey() => 'feed_${_mood.label.toLowerCase()}_page1';

  // Get cache timestamp key
  String _getCacheTimeKey() => '${_getCacheKey()}_timestamp';

  // Load first page from cache
  Future<List<Video>?> _loadFromCache() async {
    try {
      final cacheKey = _getCacheKey();
      final cachedJsonString = _cacheBox.get(cacheKey);

      if (cachedJsonString == null || cachedJsonString.isEmpty) return null;

      // Decode JSON string to List
      final jsonList = jsonDecode(cachedJsonString) as List<dynamic>;

      final videos = jsonList
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList();

      if (kDebugMode) {
        log(
          '✅ Loaded ${videos.length} videos from cache for ${_mood.label}',
        );
      }
      return videos;
    } on Exception catch (e) {
      if (kDebugMode) log('❌ Cache load failed: $e');
      return null;
    }
  }

  // Save first page to cache
  Future<void> _saveToCache(List<Video> videos) async {
    try {
      final cacheKey = _getCacheKey();
      final timeKey = _getCacheTimeKey();

      // Convert videos to JSON string
      final videosJson = videos.map((v) => v.toJson()).toList();
      final jsonString = jsonEncode(videosJson);

      // Save JSON string and timestamp
      await _cacheBox.put(cacheKey, jsonString);
      await _cacheBox.put(
        timeKey,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (kDebugMode) {
        log('💾 Cached ${videos.length} videos for ${_mood.label}');
      }
    } on Exception catch (e) {
      if (kDebugMode) log('❌ Cache save failed: $e');
    }
  }

  // Check if cache is stale (older than 1 hour)
  bool _isCacheStale() {
    try {
      final timeKey = _getCacheTimeKey();
      final timestampString = _cacheBox.get(timeKey);

      if (timestampString == null) return true;

      final timestamp = int.tryParse(timestampString);
      if (timestamp == null) return true;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cacheTime);

      return age > _cacheValidDuration;
    } on Exception catch (_) {
      return true;
    }
  }

  // Refresh first page in background (silent update)
  Future<void> _refreshFirstPage() async {
    try {
      if (kDebugMode) {
        log('🔄 Refreshing first page cache for ${_mood.label}...');
      }

      final data = await _service.fetchVideos(
        mood: _mood.label.toLowerCase(),
      );

      if (data == null) return;

      final response = FeedResponse.fromJson({
        'videos': (data['data'] as List?) ?? [],
      });

      final newVideos = response.videos;

      if (newVideos.isEmpty) return;

      // Save to cache
      await _saveToCache(newVideos);

      // Update UI if videos changed
      final currentFirstPageIds = _state.videos
          .take(10)
          .map((v) => v.videoId)
          .toSet();
      final newFirstPageIds = newVideos.map((v) => v.videoId).toSet();

      if (currentFirstPageIds != newFirstPageIds) {
        // Videos changed, update UI
        final remainingVideos = _state.videos.skip(10).toList();
        _state = _state.copyWith(videos: [...newVideos, ...remainingVideos]);
        notifyListeners();
        if (kDebugMode) log('✨ First page updated with fresh data');
      }
    } on Exception catch (e) {
      if (kDebugMode) log('❌ Background refresh failed: $e');
    }
  }

  // Load more videos for the current mood
  Future<void> loadMoreVideos() async {
    if (_state.reachedEnd || _fetching) return;

    _fetching = true;
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final data = await _service.fetchVideos(
        mood: _mood.label.toLowerCase(),
        page: _currentPage,
      );

      if (data == null) {
        _state = _state.copyWith(
          isLoading: false,
          error: 'Empty response from API',
        );
        return;
      }

      final response = FeedResponse.fromJson({
        'videos': (data['data'] as List?) ?? [],
      });

      final newVideos = response.videos;

      // If this is first page, save to cache
      if (_currentPage == 1 && newVideos.isNotEmpty) {
        await _saveToCache(newVideos);
      }

      _state = _state.copyWith(
        videos: [..._state.videos, ...newVideos],
        reachedEnd: newVideos.length < 10,
        isLoading: false,
      );
      _currentPage++;

      if (kDebugMode) {
        log(
          '📥 Loaded page ${_currentPage - 1} for ${_mood.label}: ${newVideos.length} videos',
        );
      }
    } on Exception catch (e) {
      _state = _state.copyWith(error: e.toString(), isLoading: false);
      if (kDebugMode) log('❌ Load more failed: $e');
    } finally {
      _fetching = false;
      notifyListeners();
    }
  }

  // Manual refresh – only first page
  Future<void> refresh() async {
    //  Check internet connection
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      if (kDebugMode) log('❌ No internet connection, skipping refresh');
      return;
    }

    _currentPage = 1;
    _state = _state.copyWith(
      videos: [],
      reachedEnd: false,
      isLoading: true,
    );
    notifyListeners();

    try {
      final data = await _service.fetchVideos(
        mood: _mood.label.toLowerCase(),
      );

      final response = FeedResponse.fromJson({
        'videos': (data?['data'] as List?) ?? [],
      });

      final freshVideos = response.videos;

      if (freshVideos.isNotEmpty) await _saveToCache(freshVideos);

      _state = _state.copyWith(
        videos: freshVideos,
        reachedEnd: freshVideos.length < 10,
        isLoading: false,
      );
      _currentPage = 2;
    } on Exception catch (_) {
      final cached = await _loadFromCache();
      if (cached != null && cached.isNotEmpty) {
        _state = _state.copyWith(
          videos: cached,
          reachedEnd: cached.length < 10,
          isLoading: false,
        );
        _currentPage = 2;
      } else {
        _state = _state.copyWith(
          videos: [],
          reachedEnd: true,
          isLoading: false,
        );
      }
    } finally {
      notifyListeners();
    }
  }

  // Check if there is an internet connection
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  // Clear cache for current mood
  Future<void> clearCache() async {
    try {
      await _cacheBox.delete(_getCacheKey());
      await _cacheBox.delete(_getCacheTimeKey());
      if (kDebugMode) log('🗑️ Cache cleared for ${_mood.label}');
    } on Exception catch (e) {
      if (kDebugMode) log('❌ Cache clear failed: $e');
    }
  }
}
