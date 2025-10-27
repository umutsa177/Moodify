import 'package:flutter/material.dart';

@immutable
final class ColorConstant {
  const ColorConstant._();

  static const Color primary = Colors.white;
  static const Color primaryLight = Colors.white70;
  static const Color emailBackground = Colors.white54;
  static const Color emojiColor = Colors.white12;
  static final Color onPrimary = Colors.white.withValues(alpha: .8);
  static const Color onTertiary = Colors.black54;

  static const Color secondary = Colors.black;
  static const Color onSecondary = Colors.black87;
  static const Color turquoise = Color(0xFF4F8096);
  static final Color navBarBackground = Colors.grey.shade200;
  static const Color facebookLoginBackground = Color(0xFF1877F2);
  static const Color transparent = Colors.transparent;
  static const Color error = Colors.red;
  static const Color success = Colors.green;

  static final Color navBarButtonShadowColor = const Color(
    0xFF8B5CF6,
  ).withValues(alpha: .3);

  // Shimmer Colors
  static final Color softPurple = const Color(0xFFB388FF).withValues(alpha: .3);
  static final Color softGold = const Color(0xFFFFD54F).withValues(alpha: .5);

  static const List<Color> splashBackgroundColors = [
    Color(0xFFE8B5FF),
    Color(0xFFC084FC),
    Color(0xFF8E57F2),
    Color(0xFF673AB7),
    Color(0xFF3F51B5),
    Color(0xFF303F9F),
    Color(0xFF1976D2),
    Color(0xFF0288D1),
  ];

  static const List<Color> authBackgroundColors = [
    Color(0xFFFF8A50),
    Color(0xFFFF6B6B),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
  ];

  // Feed and Profile Background Colors
  static const List<Color> feedBackgroundColors = [
    Color(0xFF833ab4),
    Color(0xFFfd1d1d),
    Color(0xFFfcb045),
  ];

  static const List<Color> navBarButtonColors = [
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];
}
