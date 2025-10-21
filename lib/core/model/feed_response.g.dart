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
  name: json['name'] as String,
  duration: (json['duration'] as num).toInt(),
  pictures: Pictures.fromJson(json['pictures'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
  'name': instance.name,
  'duration': instance.duration,
  'pictures': instance.pictures,
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
