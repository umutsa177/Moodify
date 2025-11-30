import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  final String id;
  final String? username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String email;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  List<Object?> get props => [id, username, avatarUrl, email, updatedAt];

  UserProfile copyWith({
    String? username,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
