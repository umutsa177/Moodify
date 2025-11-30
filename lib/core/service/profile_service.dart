import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Load Profile Data
  Future<UserProfile?> loadProfile(String userId, String email) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response != null) {
      if (kDebugMode) log('Profile loaded from DB: $response');
      return UserProfile.fromJson({
        ...response,
        'email': email,
      });
    }
    return null;
  }

  // Create Profile
  Future<UserProfile> createProfile({
    required String userId,
    required String email,
    String? username,
    String? avatarUrl,
  }) async {
    final profileData = {
      'id': userId,
      'username': username ?? email.split('@').first,
      'email': email,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      profileData['avatar_url'] = avatarUrl;
      if (kDebugMode) log('Creating profile with avatar: $avatarUrl');
    }

    await _supabase.from('profiles').insert(profileData);

    return UserProfile(
      id: userId,
      username: username ?? email.split('@').first,
      avatarUrl: avatarUrl,
      email: email,
      updatedAt: DateTime.now(),
    );
  }

  // Update Profile
  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    bool clearAvatar = false,
  }) async {
    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (username != null) updateData['username'] = username;

    if (avatarUrl != null) {
      updateData['avatar_url'] = avatarUrl;
    } else if (clearAvatar) {
      updateData['avatar_url'] = null;
    }

    if (kDebugMode) log('Updating profile with data: $updateData');

    final response = await _supabase
        .from('profiles')
        .update(updateData)
        .eq('id', userId)
        .select()
        .single();

    if (kDebugMode) log('Profile updated successfully: $response');
  }

  // Upload Avatar to Supabase Storage
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = '$userId/$fileName';
    try {
      // Get existing files
      final existingFiles = await _supabase.storage
          .from('avatars')
          .list(path: userId);

      // Delete existing avatars
      if (existingFiles.isNotEmpty) {
        final fileNames = existingFiles
            .map((file) => '$userId/${file.name}')
            .toList();
        await _supabase.storage.from('avatars').remove(fileNames);
      }

      // Upload New Avatar
      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/*',
            ),
          );

      // Get Public URL
      final publicUrlData = _supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);
      return publicUrlData;
    } catch (e) {
      if (kDebugMode) log('Error uploading avatar: $e');
      rethrow;
    }
  }

  // Delete Avatar
  Future<void> deleteAvatar(String userId) async {
    try {
      final files = await _supabase.storage.from('avatars').list(path: userId);

      if (files.isNotEmpty) {
        final fileNames = files.map((file) => '$userId/${file.name}').toList();
        await _supabase.storage.from('avatars').remove(fileNames);
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Error deleting avatar: $e');
    }
  }

  // Update the extractMetadata method in ProfileService
  Map<String, String?> extractMetadata(
    Map<String, dynamic>? metadata,
    User? user,
  ) {
    String? username;
    String? avatarUrl;

    // Handle Google sign-in metadata
    if (user?.appMetadata['provider'] == 'google') {
      final identities = user?.userMetadata?['identities'] as List?;
      final googleIdentity =
          identities?.firstWhere(
                (identity) => (identity as Map)['provider'] == 'google',
                orElse: () => null,
              )
              as Map?;

      avatarUrl = googleIdentity?['avatar_url'] as String?;
      username =
          googleIdentity?['full_name'] as String? ??
          user?.email?.split('@').first;
    }
    // Handle Facebook sign-in
    else if (user?.appMetadata['provider'] == 'facebook') {
      avatarUrl = user?.userMetadata?['avatar_url'] as String?;
      username =
          user?.userMetadata?['full_name'] as String? ??
          user?.email?.split('@').first;
    }
    // Handle email sign-in
    else {
      avatarUrl = user?.userMetadata?['avatar_url'] as String?;
      username =
          user?.userMetadata?['full_name'] as String? ??
          user?.email?.split('@').first;
    }

    // Process Google avatar URL to remove size parameters if needed
    if (avatarUrl != null && avatarUrl.contains('googleusercontent.com')) {
      // Remove size parameters like =s96-c
      avatarUrl = avatarUrl.split('=')[0];
    }

    return {
      'username': username,
      'avatarUrl': avatarUrl,
    };
  }
}
