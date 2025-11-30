import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';

part '../widget/settings_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isEmailUser = authProvider.isEmailProvider();

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorConstant.feedBackgroundColors,
          ),
        ),
        child: Padding(
          padding:
              context.padding.verticalNormal + context.padding.onlyTopNormal,
          child: Column(
            children: [
              _settingsHeader(context),
              // Settings List
              Expanded(
                child: Container(
                  margin: context.padding.horizontalNormal,
                  decoration: BoxDecoration(
                    color: ColorConstant.emojiColor,
                    borderRadius: context.border.normalBorderRadius,
                  ),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: context.padding.normal,
                    children: [
                      // Language Selection
                      _SettingsTile(
                        icon: Icons.language,
                        title: StringConstant.selectionLanguage,
                        subtitle: StringConstant.eng,
                        onTap: () => changeLanguageDialog(context),
                      ),

                      if (isEmailUser) ...[
                        Divider(
                          height: DoubleConstant.two,
                          color: ColorConstant.videoErrorColor,
                        ),
                        // Change Password
                        _SettingsTile(
                          icon: Icons.lock_outline,
                          title: StringConstant.changePassword,
                          subtitle: StringConstant.updatePassword,
                          onTap: () => changePasswordDialog(context),
                        ),
                      ],

                      Divider(
                        height: DoubleConstant.two,
                        color: ColorConstant.videoErrorColor,
                      ),

                      // Delete Account
                      _SettingsTile(
                        icon: Icons.delete_outline,
                        title: StringConstant.deleteAccount,
                        subtitle: StringConstant.deleteAccountSubtitle,
                        onTap: () => deleteAccountDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _settingsHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          child: Text(
            StringConstant.settings,
            textAlign: TextAlign.center,
            style: context.general.textTheme.headlineSmall?.copyWith(
              color: ColorConstant.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
              color: ColorConstant.onPrimary,
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  context.padding.onlyLeftNormal,
                ),
              ),
            ),
            // Empty space
            SizedBox(
              width: context.sized.mediumValue + context.sized.lowValue,
            ),
          ],
        ),
      ],
    );
  }

  // Change Language Dialog
  Future<void> changeLanguageDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        title: Text(
          StringConstant.selectionLanguage,
          style: context.general.textTheme.titleLarge?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(
                StringConstant.tur,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.primary,
                ),
              ),
              value: 'tr',
              groupValue: 'tr',
              activeColor: ColorConstant.primary,
              onChanged: (value) async {
                await context.route.pop();
                // TODO: Implement language change
              },
            ),
            RadioListTile<String>(
              title: Text(
                StringConstant.eng,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.primary,
                ),
              ),
              value: 'en',
              groupValue: 'en',
              activeColor: ColorConstant.primary,
              onChanged: (value) async {
                await context.route.pop();
                // TODO: Implement language change
              },
            ),
          ],
        ),
      ),
    );
  }

  // Change Password Dialog
  Future<void> changePasswordDialog(BuildContext context) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    var obscureCurrentPassword = true;
    var obscureNewPassword = true;
    var obscureConfirmPassword = true;
    var isLoading = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Current Password
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrentPassword,
                  style: const TextStyle(color: ColorConstant.primary),
                  decoration: InputDecoration(
                    labelText: StringConstant.currentPassword,
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
                        obscureCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: ColorConstant.videoCloseColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureCurrentPassword = !obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                ),
                context.sized.emptySizedHeightBoxLow3x,
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
                context.sized.emptySizedHeightBoxLow3x,
                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  style: const TextStyle(color: ColorConstant.primary),
                  decoration: InputDecoration(
                    labelText: '${StringConstant.confirmPassword} (Again)',
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
              onPressed: isLoading
                  ? null
                  : () => context.route.pop(dialogContext),
              child: Text(
                StringConstant.cancel,
                style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.videoDurationColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (newPasswordController.text.isEmpty ||
                          currentPasswordController.text.isEmpty) {
                        await ToastExtension.showToast(
                          message: StringConstant.fillAllFields,
                          backgroundColor: ColorConstant.error,
                          context: context,
                        );
                        return;
                      }

                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
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

                      setState(() => isLoading = true);

                      final success = await context
                          .read<AuthProvider>()
                          .changePassword(newPasswordController.text);

                      setState(() => isLoading = false);

                      if (dialogContext.mounted) {
                        await context.route.pop(dialogContext);
                        if (context.mounted) {
                          await ToastExtension.showToast(
                            message: success
                                ? StringConstant.passwordChanged
                                : StringConstant.passwordChangeFailed,
                            backgroundColor: success
                                ? ColorConstant.success
                                : ColorConstant.error,
                            context: context,
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                foregroundColor: ColorConstant.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: dialogContext.border.lowBorderRadius,
                ),
              ),
              child: isLoading
                  ? LoadingExtension.loadingBar(dialogContext)
                  : Text(
                      StringConstant.change,
                      style: dialogContext.general.textTheme.bodyLarge
                          ?.copyWith(
                            color: ColorConstant.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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
      // Clear Hive cache
      try {
        final box = await Hive.openBox<SavedVideo>('saved_videos_box');
        await box.clear();
        await box.close();
      } on Exception catch (e) {
        if (kDebugMode) log('Hive could not be cleared: $e');
      }

      // Delete account
      final success = await context.read<AuthProvider>().deleteAccount();

      if (success && context.mounted) {
        await ToastExtension.showToast(
          message: StringConstant.accountDeleted,
          backgroundColor: ColorConstant.success,
          context: context,
        );
        // Navigate to the splash screen
        if (context.mounted) {
          await Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.splash,
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          await ToastExtension.showToast(
            message: StringConstant.accountDeleteFailed,
            backgroundColor: ColorConstant.error,
            context: context,
          );
        }
      }
    }
  }
}
