import 'package:flutter/material.dart';
import 'package:moodify/feature/auth/sign_up/view/sign_up_view.dart';
import 'package:moodify/feature/mood_selection/view/mood_selection_view.dart';
import 'package:moodify/feature/navBar/view/nav_bar.dart';
import 'package:moodify/feature/splash/view/splash_view.dart';

class AppRouter {
  const AppRouter._();

  static const String splash = '/';
  static const String moodSelection = '/mood-selection';
  static const String signUp = '/sign-up';
  static const String navbar = '/navbar';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashView(),
    moodSelection: (context) => const MoodSelectionView(),
    signUp: (context) => const SignUpView(),
    navbar: (context) => const NavBar(),
  };
}
