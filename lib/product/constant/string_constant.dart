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

  // Register Screen
  static const String registerTitle = 'Create your account';

  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUp = 'Sign Up';

  // Login
  static const String login = 'Login';
  static const String loginTitle = 'Log in to your account';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";

  // Verification
  static const String backToSignUp = 'Back to Sign Up';
  static const String resendEmailFirstText = "Didn't receive the email?";
  static const String resendEmailSecondText = 'Resend';
  static const String checkMail = 'Check your email';
  static const String sendLink = "We've sent a verification link to:";
  static const String checkInboxAndContinue =
      'Please check your inbox and click the link to continue';

  // supabase
  static const String supabaseRedirectUri =
      'com.umutsayar.moodify://oauth2redirect';

  static const String loading = 'Loading...';
}
