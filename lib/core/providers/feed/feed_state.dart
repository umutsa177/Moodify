import 'package:equatable/equatable.dart';
import 'package:moodify/core/model/feed_response.dart';

class FeedState extends Equatable {
  const FeedState({
    this.videos = const [],
    this.isLoading = false,
    this.reachedEnd = false,
    this.error,
  });
  final List<Video> videos;
  final bool isLoading;
  final bool reachedEnd;
  final String? error;

  FeedState copyWith({
    List<Video>? videos,
    bool? isLoading,
    bool? reachedEnd,
    String? error,
  }) => FeedState(
    videos: videos ?? this.videos,
    isLoading: isLoading ?? this.isLoading,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [videos, isLoading, reachedEnd, error];
}
