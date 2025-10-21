import 'package:flutter/material.dart';
import 'package:moodify/core/model/feed_response.dart';
import 'package:moodify/core/network/feed_network_manager.dart';
import 'package:moodify/core/providers/feed/feed_state.dart';
import 'package:moodify/product/enum/moods.dart';

class FeedProvider with ChangeNotifier {
  FeedProvider(this._mood) {
    _init();
  }

  final Moods _mood;
  final _service = FeedNetworkManager();

  FeedState _state = const FeedState();
  FeedState get state => _state;

  int _currentPage = 1;
  bool _fetching = false;

  void _init() => loadMoreVideos();

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
      _state = _state.copyWith(
        videos: [..._state.videos, ...newVideos],
        reachedEnd: newVideos.length < 10,
        isLoading: false,
      );
      _currentPage++;
    } on Exception catch (e) {
      _state = _state.copyWith(error: e.toString(), isLoading: false);
    } finally {
      _fetching = false;
      notifyListeners();
    }
  }
}
