import 'package:flutter/material.dart';
import 'package:moodify/feature/auth/sign_in/view/sign_in_view.dart';
import 'package:moodify/feature/auth/sign_up/view/sign_up_view.dart';
import 'package:moodify/feature/auth/verification/view/email_verification_view.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/feature/mood_selection/view/mood_selection_view.dart';
import 'package:moodify/feature/navBar/view/nav_bar.dart';
import 'package:moodify/feature/splash/view/splash_view.dart';
import 'package:moodify/product/enum/moods.dart';

class AppRouter {
  const AppRouter._();

  static const String splash = '/';
  static const String moodSelection = '/mood-selection';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String emailVerification = '/email-verification';
  static const String navbar = '/navbar';
  static const String feed = '/feed';

  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case moodSelection:
        return MaterialPageRoute(builder: (_) => const MoodSelectionView());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInView());
      case emailVerification:
        return MaterialPageRoute(builder: (_) => const EmailVerificationView());
      case navbar:
        final mood = settings.arguments! as Moods;
        return MaterialPageRoute(
          builder: (_) => NavBar(mood: mood),
        );
      case feed:
        final mood = settings.arguments! as Moods;
        return MaterialPageRoute(
          builder: (_) => FeedView(mood: mood),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashView());
    }
  }
}
