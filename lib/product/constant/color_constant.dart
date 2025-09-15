import 'package:flutter/material.dart';

@immutable
final class ColorConstant {
  const ColorConstant._();

  static const Color primary = Colors.white;
  static const Color primaryLight = Colors.white70;
  static const Color emailBackground = Colors.white54;
  static const Color emojiColor = Colors.white12;
  static final Color onPrimary = Colors.white.withValues(alpha: .8);

  static const Color secondary = Colors.black;
  static const Color turquoise = Color(0xFF4F8096);
  static final Color navBarBackground = Colors.grey.shade200;
  static const Color facebookLoginBackground = Color(0xFF1877F2);
  static const Color transparent = Colors.transparent;
  static const Color error = Colors.red;

  static const List<Color> splashBackgroundColors = [
    Color(0xFFE8B5FF), // Açık pembe-mor
    Color(0xFFC084FC), // Orta mor
    Color(0xFF8E57F2), // Koyu mor
    Color(0xFF673AB7), // Orta mor
    Color(0xFF3F51B5), // Koyu mor
    Color(0xFF303F9F), // Açık mor
    Color(0xFF1976D2), // Koyu mavi
    Color(0xFF0288D1), // Orta mavi
  ];

  static const List<Color> authBackgroundColors = [
    Color(0xFFFF8A50), // Orange
    Color(0xFFFF6B6B), // Red-Orange
    Color(0xFFE91E63), // Pink-Red
    Color(0xFF9C27B0), // Purple
  ];
}
