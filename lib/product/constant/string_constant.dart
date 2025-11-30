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
  static const String savedVideos = 'Your Saved Videos';
  static const String savedVideosEmpty = 'No saved videos yet';
  static const String savedVideoSearchEmpty = 'No videos found for';
  static const String searchSavedVideo = 'Search saved videos';
  static const String noVideos = 'No videos found';
  static const String logoutAccount = 'Are you sure you want to log out?';

  // Edit Profile
  static const String editProfile = 'Edit Profile';
  static const String chooseImageSource = 'Choose Image Source';
  static const String gallery = 'Gallery';
  static const String camera = 'Camera';
  static const String notEmail = 'Email not found';
  static const String username = 'Username';
  static const String nameHint = 'Enter your username';
  static const String deleteAvatar = 'Delete Profile Photo';
  static const String deletedAvatar = 'Profile photo deleted';
  static const String deleteAvatarError = 'Error while deleting profile photo';
  static const String nameCannotBeEmpty = 'Username cannot be empty';
  static const String uploadAvatarError = 'Avatar upload failed';
  static const String updateProfileError = 'Profile update failed';
  static const String updateProfileSuccess = 'Profile updated successfully';
  static const String deleteYourAvatar =
      'Are you sure you want to delete your profile photo?';

  // Settings
  static const String selectionLanguage = 'Language Selection';
  static const String eng = 'English';
  static const String tur = 'Turkish';
  static const String changePassword = 'Change Password';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String updatePassword = 'Update your password';
  static const String deleteAccount = 'Delete Account';
  static const String deleteAccountSubtitle = 'Permanently delete your account';
  static const String fillAllFields = 'Fill in all fields';
  static const String passwordsNotMatch = 'Passwords do not match';
  static const String passwordMustBeSixCharacters =
      'Password must be at least 6 characters';
  static const String passwordChanged = 'Password changed successfully';
  static const String passwordChangeFailed = 'Password change failed';
  static const String deleteYourAccount =
      'Are you sure you want to delete your account?';
  static const String deleteYourAccountSubtitle =
      'This action cannot be undone and the following will be deleted:';
  static const String deleteYourAccountDatas =
      '• Your profile information\n• Your saved videos\n• All datas';
  static const String accountDeleted = 'Your account has been deleted';
  static const String accountDeleteFailed = 'Account deletion failed';

  // Other
  static const String okey = 'OK';
  static const String loading = 'Loading...';
  static const String tryAgain = 'Try Again';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String change = 'Change';

  // Tooltips
  static const String remove = 'Remove';
  static const String signOut = 'Sign out';
  static const String settings = 'Settings';

  // supabase
  static const String supabaseRedirectUri =
      'com.umutsayar.moodify://oauth2redirect';
}
