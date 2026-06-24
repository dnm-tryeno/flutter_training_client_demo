import 'package:flutter/material.dart';

class InstaColors {
  static const background = Colors.white;
  static const primary = Color(0xFFE1306C);
  static const accent = Color(0xFF833AB4);
  static const text = Colors.black;
  static const subtle = Colors.black54;
}

final ThemeData instagramTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: InstaColors.background,
  colorScheme: const ColorScheme.light(
    primary: InstaColors.primary,
    secondary: InstaColors.accent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0.5,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: InstaColors.text,
      fontFamily: 'Billabong',
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(color: InstaColors.text, fontSize: 14),
    bodySmall: TextStyle(color: InstaColors.subtle, fontSize: 12),
  ),
);
