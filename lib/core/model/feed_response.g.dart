// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
  videos: (json['videos'] as List<dynamic>)
      .map((e) => Video.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{'videos': instance.videos};

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
  uri: json['uri'] as String,
  name: json['name'] as String,
  duration: (json['duration'] as num).toInt(),
  pictures: Pictures.fromJson(json['pictures'] as Map<String, dynamic>),
  link: json['link'] as String?,
  playerEmbedUrl: json['player_embed_url'] as String?,
);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
  'uri': instance.uri,
  'name': instance.name,
  'duration': instance.duration,
  'pictures': instance.pictures,
  'link': instance.link,
  'player_embed_url': instance.playerEmbedUrl,
};

Pictures _$PicturesFromJson(Map<String, dynamic> json) => Pictures(
  sizes: (json['sizes'] as List<dynamic>)
      .map((e) => Size.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PicturesToJson(Pictures instance) => <String, dynamic>{
  'sizes': instance.sizes,
};

Size _$SizeFromJson(Map<String, dynamic> json) => Size(
  width: (json['width'] as num?)?.toInt(),
  link: json['link'] as String?,
);

Map<String, dynamic> _$SizeToJson(Size instance) => <String, dynamic>{
  'width': instance.width,
  'link': instance.link,
};
