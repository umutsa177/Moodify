import 'package:json_annotation/json_annotation.dart';

part 'feed_response.g.dart';

@JsonSerializable()
class FeedResponse {
  FeedResponse({required this.videos});

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);
  final List<Video> videos;
  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);
}

@JsonSerializable()
class Video {
  Video({
    required this.uri,
    required this.name,
    required this.duration,
    required this.pictures,
    this.link,
    this.playerEmbedUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  final String uri;
  final String name;
  final int duration;
  final Pictures pictures;
  final String? link;
  @JsonKey(name: 'player_embed_url')
  final String? playerEmbedUrl;

  String get videoId => uri.split('/').last;

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable()
class Pictures {
  Pictures({required this.sizes});

  factory Pictures.fromJson(Map<String, dynamic> json) =>
      _$PicturesFromJson(json);
  final List<Size> sizes;
  Map<String, dynamic> toJson() => _$PicturesToJson(this);
}

@JsonSerializable()
class Size {
  Size({
    this.width,
    this.link,
  });

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);
  final int? width;
  final String? link;
  Map<String, dynamic> toJson() => _$SizeToJson(this);
}
