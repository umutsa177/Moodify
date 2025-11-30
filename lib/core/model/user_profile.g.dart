// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
