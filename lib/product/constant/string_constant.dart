import 'package:flutter/material.dart';

@immutable
final class StringConstant {
  const StringConstant._();

  static const String appName = 'Moodify';

  // nav bar
  static const String feed = 'Feed';
  static const String profile = 'Profile';

  // Splash Screen
  static const String splashTitle = 'Find Your Vibe';
  static const String splashSubtitle =
      'Log in to discover videos that match\nyour mood';

  static const String signInGoogle = 'Continue with Google';
  static const String signInFacebook = 'Continue with Social';
  static const String emailSignup = 'Sign up with Email';
  static const String firstTermsText = 'By continuing, you agree to our ';
  static const String secondTermsText = 'Terms of Service';
  static const String seperateText = 'or';
  static const String supabaseRedirectUri =
      'com.umutsayar.moodify://oauth2redirect';

  static String loading = 'Loading...';
}
