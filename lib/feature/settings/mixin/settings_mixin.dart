import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/profile/purchase_provider.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/settings/view/settings_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

mixin SettingsMixin on State<SettingsView> {
  // Manage Premium Dialog (For Premium Users)
  Future<void> showManagePremiumDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: dialogContext.border.normalBorderRadius,
        ),
        title: Row(
          spacing: dialogContext.sized.lowValue,
          children: [
            const Icon(
              Icons.verified,
              color: ColorConstant.success,
            ),
            Text(
              StringConstant.premiumMember,
              style: dialogContext.general.textTheme.titleLarge?.copyWith(
                color: ColorConstant.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: dialogContext.sized.normalValue,
          children: [
            Text(
              StringConstant.premiumActive,
              style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              StringConstant.managePremiumInfo,
              style: dialogContext.general.textTheme.bodyMedium?.copyWith(
                color: ColorConstant.primary,
              ),
            ),
            // Manage Subscription Button
            ElevatedButton.icon(
              onPressed: () => _openManageSubscription(context),
              icon: const Icon(Icons.settings),
              label: Text(
                StringConstant.manageSubscription,
                style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                foregroundColor: ColorConstant.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: dialogContext.border.lowBorderRadius,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.route.pop(),
            child: Text(
              StringConstant.close,
              style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.videoDurationColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Open platform-specific subscription management
  Future<void> _openManageSubscription(BuildContext context) async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final managementUrl = customerInfo.managementURL;

      if (managementUrl != null) {
        final uri = Uri.parse(managementUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            await ToastExtension.showToast(
              message: StringConstant.cannotOpenSubscriptionManagement,
              backgroundColor: ColorConstant.error,
              context: context,
            );
          }
        }
      } else {
        if (context.mounted) {
          await ToastExtension.showToast(
            message: StringConstant.noManagementUrlAvailable,
            backgroundColor: ColorConstant.error,
            context: context,
          );
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Error opening subscription management: $e');
      if (context.mounted) {
        await ToastExtension.showToast(
          message: StringConstant.errorOccurred,
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    }
  }

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
      final savedVideosProvider = context.read<SavedVideosProvider>();
      await savedVideosProvider.clearLocalDataForCurrentUser();

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

  // Premium Dialog (For upgrade to premium)
  Future<void> showPremiumDialog(BuildContext context) async {
    final purchaseProvider = context.read<PurchaseProvider>();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: dialogContext.border.normalBorderRadius,
        ),
        title: Row(
          spacing: context.sized.normalValue,
          children: [
            const Icon(
              Icons.workspace_premium,
              color: ColorConstant.primary,
            ),
            Expanded(
              child: Text(
                StringConstant.upgradeToPremium,
                style: dialogContext.general.textTheme.titleLarge?.copyWith(
                  color: ColorConstant.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringConstant.premiumFeatures,
                style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              dialogContext.sized.emptySizedHeightBoxLow,
              _featureItem(dialogContext, StringConstant.feature1),
              _featureItem(dialogContext, StringConstant.feature2),
              _featureItem(dialogContext, StringConstant.feature3),
              dialogContext.sized.emptySizedHeightBoxLow,

              if (purchaseProvider.isLoading)
                LoadingExtension.loadingBar(context)
              else
                ...purchaseProvider.availablePackages.map(
                  (package) => _packageCard(dialogContext, package),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.route.pop(),
            child: Text(
              StringConstant.cancel,
              style: dialogContext.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.videoDurationColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _featureItem(BuildContext context, String feature) {
    return Padding(
      padding: context.padding.verticalLow,
      child: Row(
        spacing: context.sized.lowValue,
        children: [
          const Icon(
            Icons.check_circle,
            color: ColorConstant.success,
            size: DoubleConstant.twenty,
          ),
          Expanded(
            child: Text(
              feature,
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: ColorConstant.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card _packageCard(BuildContext context, Package package) {
    return Card(
      color: ColorConstant.onPrimaryLight,
      margin: context.padding.onlyBottomLow,
      child: InkWell(
        onTap: () async {
          final success = await context
              .read<PurchaseProvider>()
              .purchasePackage(package);

          if (!context.mounted) return;

          if (success) {
            await context.route.pop();
            if (context.mounted) {
              await ToastExtension.showToast(
                message: StringConstant.purchaseSuccess,
                backgroundColor: ColorConstant.success,
                context: context,
              );
            }
          } else {
            await ToastExtension.showToast(
              message: StringConstant.purchaseFailed,
              backgroundColor: ColorConstant.error,
              context: context,
            );
          }
        },
        child: Padding(
          padding: context.padding.normal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.sized.lowValue,
            children: [
              Text(
                package.storeProduct.title,
                style: context.general.textTheme.titleMedium?.copyWith(
                  color: ColorConstant.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                package.storeProduct.description,
                style: context.general.textTheme.bodySmall?.copyWith(
                  color: ColorConstant.videoCloseColor,
                ),
              ),
              Text(
                package.storeProduct.priceString,
                style: context.general.textTheme.headlineSmall?.copyWith(
                  color: ColorConstant.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Restore Purchases
  Future<void> restorePurchasesAction(BuildContext context) async {
    await context.read<PurchaseProvider>().restorePurchases();

    if (!context.mounted) return;

    final isPremium = context.read<PurchaseProvider>().isPremium;

    await ToastExtension.showToast(
      message: isPremium
          ? StringConstant.purchasesRestored
          : StringConstant.noPurchasesFound,
      backgroundColor: isPremium ? ColorConstant.success : ColorConstant.error,
      context: context,
    );
  }
}
