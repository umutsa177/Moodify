import 'package:hive_ce/hive.dart';

part 'saved_video.g.dart';

@HiveType(typeId: 0)
class SavedVideo extends HiveObject {
  SavedVideo({
    required this.videoId,
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.videoUrl,
    required this.savedAt,
  });

  factory SavedVideo.fromJson(Map<String, dynamic> json) => SavedVideo(
    videoId: json['video_id'] as String,
    title: json['title'] as String,
    thumbnail: json['thumbnail'] as String,
    duration: json['duration'] as String,
    videoUrl: json['video_url'] as String,
    savedAt: DateTime.parse(json['saved_at'] as String),
  );

  @HiveField(0)
  final String videoId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final String duration;

  @HiveField(4)
  final String videoUrl;

  @HiveField(5)
  final DateTime savedAt;

  Map<String, dynamic> toJson() => {
    'video_id': videoId,
    'title': title,
    'thumbnail': thumbnail,
    'duration': duration,
    'video_url': videoUrl,
    'saved_at': savedAt.toIso8601String(),
  };
}
