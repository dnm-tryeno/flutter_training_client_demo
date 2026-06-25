import 'package:flutter/material.dart';

class TikTokColors {
  static const background = Colors.black;
  static const primary = Color(0xFFFE2C55);
  static const accent = Color(0xFF25F4EE);
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
}

final ThemeData tikTokTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: TikTokColors.background,
  colorScheme: const ColorScheme.dark(
    primary: TikTokColors.primary,
    secondary: TikTokColors.accent,
    surface: Colors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: TikTokColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: TikTokColors.textPrimary, fontSize: 14),
    bodySmall: TextStyle(color: TikTokColors.textSecondary, fontSize: 12),
  ),
);
