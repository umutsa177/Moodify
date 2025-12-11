import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:path_provider/path_provider.dart';

mixin ProfileMixin {
  static Future<void> showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
    SavedVideosProvider savedVideosProvider,
  ) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        title: Text(
          StringConstant.signOut,
          style: context.general.textTheme.titleLarge?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          StringConstant.logoutAccount,
          style: context.general.textTheme.bodyLarge?.copyWith(
            color: ColorConstant.primaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.route.pop(false),
            child: Text(
              StringConstant.cancel,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.onPrimary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => context.route.pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.primary,
              foregroundColor: ColorConstant.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: context.border.lowBorderRadius,
              ),
            ),
            child: Text(
              StringConstant.signOut,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.onSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      // Clear saved videos
      await savedVideosProvider.clearLocalDataForCurrentUser();

      // Logout
      await authProvider.signOut();

      // Redirect
      if (context.mounted) {
        unawaited(
          context.route.navigation.pushNamedAndRemoveUntil(
            AppRouter.splash,
            (route) => false,
          ),
        );
      }
    }
  }

  // Clear image cache
  static Future<void> clearImageCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final libCacheDir = Directory('${cacheDir.path}/libCachedImageData');

      if (await libCacheDir.exists()) {
        await libCacheDir.delete(recursive: true);
        if (kDebugMode) log('Image cache cleared');
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Error clearing image cache: $e');
    }
  }
}
