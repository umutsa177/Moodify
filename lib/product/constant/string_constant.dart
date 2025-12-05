import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@immutable
final class StringConstant {
  const StringConstant._();

  // AppName
  static String get appName => 'appName'.tr();

  // nav bar
  static String get feed => 'feed'.tr();
  static String get profile => 'profile'.tr();

  // Splash Screen
  static String get splashTitle => 'splashTitle'.tr();
  static String get splashSubtitle => 'splashSubtitle'.tr();

  static String get signInGoogle => 'signInGoogle'.tr();
  static String get signInFacebook => 'signInFacebook'.tr();
  static String get emailSignup => 'emailSignup'.tr();
  static String get firstTermsText => 'firstTermsText'.tr();
  static String get secondTermsText => 'secondTermsText'.tr();
  static String get seperateText => 'seperateText'.tr();

  // Register Screen
  static String get registerTitle => 'registerTitle'.tr();

  // Sign Up
  static String get email => 'email'.tr();
  static String get password => 'password'.tr();
  static String get confirmPassword => 'confirmPassword'.tr();
  static String get alreadyHaveAccount => 'alreadyHaveAccount'.tr();
  static String get signUp => 'signUp'.tr();
  static String get signUpSuccess => 'signUpSuccess'.tr();

  // Login
  static String get login => 'login'.tr();
  static String get loginTitle => 'loginTitle'.tr();
  static String get forgotPassword => 'forgotPassword'.tr();
  static String get dontHaveAccount => 'dontHaveAccount'.tr();

  // Verification
  static String get backToSignUp => 'backToSignUp'.tr();
  static String get resendEmailFirstText => 'resendEmailFirstText'.tr();
  static String get resendEmailSecondText => 'resendEmailSecondText'.tr();
  static String get checkMail => 'checkMail'.tr();
  static String get sendLink => 'sendLink'.tr();
  static String get checkInboxAndContinue => 'checkInboxAndContinue'.tr();

  // Mood Selection
  static String get moodSelectionTitle => 'moodSelectionTitle'.tr();
  static String get moodSelectionFirstDescriptionText =>
      'moodSelectionFirstDescriptionText'.tr();
  static String get moodSelectionSecondDescriptionText =>
      'moodSelectionSecondDescriptionText'.tr();

  // Feed
  static String get videosNotFound => 'videosNotFound'.tr();
  static String get notPlayable => 'notPlayable'.tr();
  static String get notLoaded => 'notLoaded'.tr();
  static String get pullToRefresh => 'pullToRefresh'.tr();
  static String get removeVideoSuccess => 'removeVideoSuccess'.tr();
  static String get videoSaved => 'videoSaved'.tr();

  // Profile
  static String get myProfile => 'myProfile'.tr();
  static String get savedVideos => 'savedVideos'.tr();
  static String get savedVideosEmpty => 'savedVideosEmpty'.tr();
  static String get savedVideoSearchEmpty => 'savedVideoSearchEmpty'.tr();
  static String get searchSavedVideo => 'searchSavedVideo'.tr();
  static String get noVideos => 'noVideos'.tr();
  static String get logoutAccount => 'logoutAccount'.tr();

  // Edit Profile
  static String get editProfile => 'editProfile'.tr();
  static String get chooseImageSource => 'chooseImageSource'.tr();
  static String get gallery => 'gallery'.tr();
  static String get camera => 'camera'.tr();
  static String get notEmail => 'notEmail'.tr();
  static String get username => 'username'.tr();
  static String get nameHint => 'nameHint'.tr();
  static String get deleteAvatar => 'deleteAvatar'.tr();
  static String get deletedAvatar => 'deletedAvatar'.tr();
  static String get deleteAvatarError => 'deleteAvatarError'.tr();
  static String get nameCannotBeEmpty => 'nameCannotBeEmpty'.tr();
  static String get uploadAvatarError => 'uploadAvatarError'.tr();
  static String get updateProfileError => 'updateProfileError'.tr();
  static String get updateProfileSuccess => 'updateProfileSuccess'.tr();
  static String get deleteYourAvatar => 'deleteYourAvatar'.tr();

  // Settings
  static String get selectionLanguage => 'selectionLanguage'.tr();
  static String get eng => 'eng'.tr();
  static String get tur => 'tur'.tr();
  static String get changePassword => 'changePassword'.tr();
  static String get currentPassword => 'currentPassword'.tr();
  static String get newPassword => 'newPassword'.tr();
  static String get updatePassword => 'updatePassword'.tr();
  static String get deleteAccount => 'deleteAccount'.tr();
  static String get deleteAccountSubtitle => 'deleteAccountSubtitle'.tr();
  static String get fillAllFields => 'fillAllFields'.tr();
  static String get passwordsNotMatch => 'passwordsNotMatch'.tr();
  static String get passwordMustBeSixCharacters =>
      'passwordMustBeSixCharacters'.tr();
  static String get passwordChanged => 'passwordChanged'.tr();
  static String get passwordChangeFailed => 'passwordChangeFailed'.tr();
  static String get deleteYourAccount => 'deleteYourAccount'.tr();
  static String get deleteYourAccountSubtitle =>
      'deleteYourAccountSubtitle'.tr();
  static String get deleteYourAccountDatas => 'deleteYourAccountDatas'.tr();
  static String get accountDeleted => 'accountDeleted'.tr();
  static String get accountDeleteFailed => 'accountDeleteFailed'.tr();

  // Other
  static String get okey => 'okey'.tr();
  static String get loading => 'loading'.tr();
  static String get tryAgain => 'tryAgain'.tr();
  static String get cancel => 'cancel'.tr();
  static String get save => 'save'.tr();
  static String get delete => 'delete'.tr();
  static String get change => 'change'.tr();

  // Tooltips
  static String get remove => 'remove'.tr();
  static String get signOut => 'signOut'.tr();
  static String get settings => 'settings'.tr();

  // Purchase
  static String get upgradeToPremium => 'upgradeToPremium'.tr();
  static String get premiumMember => 'premiumMember'.tr();
  static String get premiumActive => 'premiumActive'.tr();
  static String get unlockAllFeatures => 'unlockAllFeatures'.tr();
  static String get premiumFeatures => 'premiumFeatures'.tr();
  static String get feature1 => 'feature1'.tr();
  static String get feature2 => 'feature2'.tr();
  static String get feature3 => 'feature3'.tr();
  static String get purchaseSuccess => 'purchaseSuccess'.tr();
  static String get purchaseFailed => 'purchaseFailed'.tr();
  static String get restorePurchases => 'restorePurchases'.tr();
  static String get restorePurchasesSubtitle => 'restorePurchasesSubtitle'.tr();
  static String get purchasesRestored => 'purchasesRestored'.tr();
  static String get noPurchasesFound => 'noPurchasesFound'.tr();
  static String get managePremiumInfo => 'managePremiumInfo'.tr();
  static String get manageSubscription => 'manageSubscription'.tr();
  static String get close => 'close'.tr();
  static String get cannotOpenSubscriptionManagement =>
      'cannotOpenSubscriptionManagement'.tr();
  static String get noManagementUrlAvailable => 'noManagementUrlAvailable'.tr();
  static String get errorOccurred => 'errorOccurred'.tr();

  // supabase
  static const String supabaseRedirectUri =
      'com.umutsayar.moodify://oauth2redirect';
}
