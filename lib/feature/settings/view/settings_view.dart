import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/profile/purchase_provider.dart';
import 'package:moodify/feature/settings/mixin/settings_mixin.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';

part '../widget/settings_tile.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SettingsMixin {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final purchaseProvider = context.watch<PurchaseProvider>();
    final isEmailUser = authProvider.isEmailProvider();
    final isPremium = purchaseProvider.isPremium;

    // Get current language
    final currentLocale = context.locale;
    final currentLanguage = currentLocale.languageCode == 'tr'
        ? StringConstant.tur
        : StringConstant.eng;

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
                      // Premium Status
                      _SettingsTile(
                        icon: isPremium
                            ? Icons.verified
                            : Icons.workspace_premium,
                        title: isPremium
                            ? StringConstant.premiumMember
                            : StringConstant.upgradeToPremium,
                        subtitle: isPremium
                            ? StringConstant.premiumActive
                            : StringConstant.unlockAllFeatures,
                        onTap: isPremium
                            ? () => showManagePremiumDialog(context)
                            : () => showPremiumDialog(context),
                      ),
                      _settingsDivider(),
                      // Restore Purchases
                      _SettingsTile(
                        icon: Icons.restore,
                        title: StringConstant.restorePurchases,
                        subtitle: StringConstant.restorePurchasesSubtitle,
                        onTap: () => restorePurchasesAction(context),
                      ),
                      _settingsDivider(),
                      // Language Selection
                      _SettingsTile(
                        icon: Icons.language,
                        title: StringConstant.selectionLanguage,
                        subtitle: currentLanguage,
                        onTap: () => changeLanguageDialog(context),
                      ),
                      if (isEmailUser) ...[
                        _settingsDivider(),
                        // Change Password
                        _SettingsTile(
                          icon: Icons.lock_outline,
                          title: StringConstant.changePassword,
                          subtitle: StringConstant.updatePassword,
                          onTap: () => changePasswordDialog(context),
                        ),
                      ],
                      _settingsDivider(),
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

  Divider _settingsDivider() {
    return Divider(
      height: DoubleConstant.two,
      color: ColorConstant.videoErrorColor,
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
}
