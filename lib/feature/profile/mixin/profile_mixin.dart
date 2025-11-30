import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';

mixin ProfileMixin {
  static Future<void> showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
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
      // Clear saved vdieos cache
      try {
        final box = await Hive.openBox<SavedVideo>('saved_videos_box');
        await box.clear();
        await box.close();
      } on Exception catch (e) {
        if (kDebugMode) log('Cache could not be cleared: $e');
      }

      // Logout
      await authProvider.signOut();

      // Redirect to splash view
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
}
