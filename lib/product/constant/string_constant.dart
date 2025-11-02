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

  // Sign Up
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUp = 'Sign Up';
  static const String signUpSuccess = 'Account created successfully';

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

  // Mood Selection
  static const String moodSelectionTitle = 'How are you feeling today?';
  static const String moodSelectionFirstDescriptionText =
      'Select a mood to get video';
  static const String moodSelectionSecondDescriptionText =
      'recommendations tailored just for you';

  // Feed
  static const String videosNotFound = 'No videos found or connection error';
  static const String notPlayable = 'Video do not playable';
  static const String notLoaded = 'Video failed to load';
  static const String pullToRefresh = 'Pull down to refresh';
  static const String removeVideoSuccess = 'Video removed from saved';
  static const String videoSaved = 'Video saved!';

  // Profile
  static const String myProfile = 'My Profile';

  // supabase
  static const String supabaseRedirectUri =
      'com.umutsayar.moodify://oauth2redirect';

  static const String loading = 'Loading...';
  static const String tryAgain = 'Try Again';
}
