import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedVideosProvider with ChangeNotifier {
  SavedVideosProvider() {
    unawaited(_init());
  }

  late Box<SavedVideo> _box;
  final SupabaseClient _supabase = Supabase.instance.client;

  List<SavedVideo> _savedVideos = [];
  List<SavedVideo> get savedVideos => _savedVideos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> _init() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _savedVideos = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    // ✅ Kullanıcıya özel Hive kutusunu aç
    final boxName = 'saved_videos_${user.id}';
    _box = await Hive.openBox<SavedVideo>(boxName);

    // Load from cache (now user-specific)
    _savedVideos = _box.values.toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));

    _isLoading = false;
    notifyListeners();

    // Then sync with Supabase
    await _syncWithSupabase();
  }

  /// Check if a video is saved
  bool isVideoSaved(String videoId) {
    return _savedVideos.any((v) => v.videoId == videoId);
  }

  // Save videos
  Future<void> saveVideo(SavedVideo video) async {
    if (isVideoSaved(video.videoId)) return;

    // Immediate local save
    await _box.put(video.videoId, video);
    _savedVideos
      ..add(video)
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    notifyListeners();

    // Background cloud sync
    await _syncVideoToCloud(video);
  }

  // Remove video
  Future<void> removeVideo(String videoId) async {
    await _box.delete(videoId);
    _savedVideos.removeWhere((v) => v.videoId == videoId);
    notifyListeners();

    await _removeVideoFromCloud(videoId);
  }

  // Sync single video to Supabase
  Future<void> _syncVideoToCloud(SavedVideo video) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('saved_videos').upsert({
        'user_id': user.id,
        'video_id': video.videoId,
        'title': video.title,
        'thumbnail': video.thumbnail,
        'duration': video.duration,
        'video_url': video.videoUrl,
        'saved_at': video.savedAt.toIso8601String(),
      });
    } on Exception catch (e) {
      if (kDebugMode) log('Failed to sync video to cloud: $e');
    }
  }

  Future<void> _removeVideoFromCloud(String videoId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase
          .from('saved_videos')
          .delete()
          .eq('user_id', user.id)
          .eq('video_id', videoId);
    } on Exception catch (e) {
      if (kDebugMode) log('Failed to remove video from cloud: $e');
    }
  }

  // Full bidirectional sync with Supabase
  Future<void> _syncWithSupabase() async {
    if (_isSyncing) return;

    _isSyncing = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        _isSyncing = false;
        notifyListeners();
        return;
      }

      final response = await _supabase
          .from('saved_videos')
          .select()
          .eq('user_id', user.id)
          .order('saved_at', ascending: false);

      final cloudVideos = (response as List)
          .map((e) => SavedVideo.fromJson(e as Map<String, dynamic>))
          .toList();

      final localVideoIds = _box.keys.toSet();
      final cloudVideoIds = cloudVideos.map((v) => v.videoId).toSet();

      // Add cloud videos missing locally
      for (final video in cloudVideos) {
        if (!localVideoIds.contains(video.videoId)) {
          await _box.put(video.videoId, video);
        }
      }

      // Upload local videos missing in cloud
      final videosToUpload = _box.values.where(
        (video) => !cloudVideoIds.contains(video.videoId),
      );

      for (final video in videosToUpload) {
        await _syncVideoToCloud(video);
      }

      // Refresh local list
      _savedVideos = _box.values.toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } on Exception catch (e) {
      if (kDebugMode) log('Sync failed: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Clear all saved videos for current user (both local and cloud)
  Future<void> clearAll() async {
    await _box.clear();
    _savedVideos.clear();
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('saved_videos').delete().eq('user_id', user.id);
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Failed to clear cloud data: $e');
    }
  }

  // Clear local data for current user
  Future<void> clearLocalDataForCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final boxName = 'saved_videos_${user.id}';
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<SavedVideo>(boxName).clear();
      await Hive.box<SavedVideo>(boxName).close();
      await Hive.deleteBoxFromDisk(boxName);
    }
  }
}
