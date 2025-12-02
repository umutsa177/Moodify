import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/settings/view/settings_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';

mixin SettingsMixin on State<SettingsView> {
  // Change Language Dialog
  Future<void> changeLanguageDialog(BuildContext context) async {
    final currentLocale = context.locale;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: dialogContext.border.normalBorderRadius,
        ),
        title: Text(
          StringConstant.selectionLanguage,
          style: dialogContext.general.textTheme.titleLarge?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RadioGroup<String>(
          groupValue: currentLocale.languageCode,
          onChanged: (value) async {
            if (value != null) {
              await context.setLocale(Locale(value));
              if (dialogContext.mounted) await dialogContext.route.pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(
                  StringConstant.tur,
                  style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.primary,
                  ),
                ),
                value: 'tr',
                activeColor: ColorConstant.primary,
              ),
              RadioListTile<String>(
                title: Text(
                  StringConstant.eng,
                  style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.primary,
                  ),
                ),
                value: 'en',
                activeColor: ColorConstant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Change Password Dialog
  Future<void> changePasswordDialog(BuildContext context) async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    var obscureNewPassword = true;
    var obscureConfirmPassword = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          backgroundColor: ColorConstant.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: dialogContext.border.normalBorderRadius,
          ),
          title: Text(
            StringConstant.changePassword,
            style: dialogContext.general.textTheme.titleLarge?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // New Password
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,
                  style: const TextStyle(color: ColorConstant.primary),
                  decoration: InputDecoration(
                    labelText: StringConstant.newPassword,
                    labelStyle: TextStyle(
                      color: ColorConstant.videoCloseColor,
                    ),
                    filled: true,
                    fillColor: ColorConstant.onPrimaryLight,
                    border: OutlineInputBorder(
                      borderRadius: dialogContext.border.lowBorderRadius,
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: ColorConstant.videoCloseColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNewPassword = !obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                dialogContext.sized.emptySizedHeightBoxLow3x,
                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  style: const TextStyle(color: ColorConstant.primary),
                  decoration: InputDecoration(
                    labelText: StringConstant.confirmPassword,
                    labelStyle: TextStyle(
                      color: ColorConstant.videoCloseColor,
                    ),
                    filled: true,
                    fillColor: ColorConstant.onPrimaryLight,
                    border: OutlineInputBorder(
                      borderRadius: dialogContext.border.lowBorderRadius,
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: ColorConstant.videoCloseColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.route.pop(false),
              child: Text(
                StringConstant.cancel,
                style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.videoDurationColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _handlePasswordChange(
                  context,
                  dialogContext,
                  builderContext,
                  newPasswordController,
                  confirmPasswordController,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                foregroundColor: ColorConstant.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: dialogContext.border.lowBorderRadius,
                ),
              ),
              child: Text(
                StringConstant.change,
                style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle password change logic
  Future<void> _handlePasswordChange(
    BuildContext context,
    BuildContext dialogContext,
    BuildContext builderContext,
    TextEditingController newPasswordController,
    TextEditingController confirmPasswordController,
  ) async {
    // Validations
    if (newPasswordController.text.isEmpty) {
      await ToastExtension.showToast(
        message: StringConstant.fillAllFields,
        backgroundColor: ColorConstant.error,
        context: context,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      await ToastExtension.showToast(
        message: StringConstant.passwordsNotMatch,
        backgroundColor: ColorConstant.error,
        context: context,
      );
      return;
    }

    if (newPasswordController.text.length < 6) {
      await ToastExtension.showToast(
        message: StringConstant.passwordMustBeSixCharacters,
        backgroundColor: ColorConstant.error,
        context: context,
      );
      return;
    }

    // Change password
    final success = await context.read<AuthProvider>().changePassword(
      newPasswordController.text,
    );

    // Dispose controllers
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    if (!builderContext.mounted) return;

    // Close dialog
    if (dialogContext.mounted) await dialogContext.route.pop();

    // Show toast
    if (context.mounted) {
      await ToastExtension.showToast(
        message: success
            ? StringConstant.passwordChanged
            : StringConstant.passwordChangeFailed,
        backgroundColor: success ? ColorConstant.success : ColorConstant.error,
        context: context,
      );
    }
  }

  // Delete Account Dialog
  Future<void> deleteAccountDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        title: Text(
          StringConstant.deleteAccount,
          style: context.general.textTheme.titleLarge?.copyWith(
            color: ColorConstant.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstant.deleteYourAccount,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.primary,
              ),
            ),
            context.sized.emptySizedHeightBoxLow3x,
            Text(
              StringConstant.deleteYourAccountSubtitle,
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: ColorConstant.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            context.sized.emptySizedHeightBoxLow,
            Text(
              StringConstant.deleteYourAccountDatas,
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: ColorConstant.videoCloseColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.route.pop(false),
            child: Text(
              StringConstant.cancel,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.videoDurationColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => context.route.pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.error,
              foregroundColor: ColorConstant.primary,
              shape: RoundedRectangleBorder(
                borderRadius: context.border.lowBorderRadius,
              ),
            ),
            child: Text(
              StringConstant.delete,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      if (context.mounted) await _handleAccountDeletion(context);
    }
  }

  // Handle account deletion logic
  Future<void> _handleAccountDeletion(BuildContext context) async {
    // Clear cache
    try {
      if (Hive.isBoxOpen('saved_videos_box')) {
        final box = Hive.box<SavedVideo>('saved_videos_box');
        await box.clear();
      } else {
        final box = await Hive.openBox<SavedVideo>('saved_videos_box');
        await box.clear();
        await box.close();
      }
      if (kDebugMode) log('Cache cleared successfully');
    } on Exception catch (e) {
      if (kDebugMode) log('Cache could not be cleared: $e');
    }

    // Delete account
    final success = await context.read<AuthProvider>().deleteAccount();

    if (context.mounted) {
      if (success) {
        await ToastExtension.showToast(
          message: StringConstant.accountDeleted,
          backgroundColor: ColorConstant.success,
          context: context,
        );

        // Redirect to splash view
        if (context.mounted) {
          await Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.splash,
            (route) => false,
          );
        }
      } else {
        await ToastExtension.showToast(
          message: StringConstant.accountDeleteFailed,
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    }
  }
}
