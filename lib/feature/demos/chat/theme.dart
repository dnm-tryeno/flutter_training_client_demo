import 'package:flutter/material.dart';

class ChatColors {
  static const background = Color(0xFFECE5DD);
  static const primary = Color(0xFF075E54);
  static const accent = Color(0xFF25D366);
  static const myBubble = Color(0xFFDCF8C6);
  static const theirBubble = Colors.white;
  static const text = Colors.black87;
  static const subtle = Colors.black54;
}

final ThemeData chatTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: ChatColors.background,
  colorScheme: const ColorScheme.light(
    primary: ChatColors.primary,
    secondary: ChatColors.accent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ChatColors.primary,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: ChatColors.text, fontSize: 15),
    bodySmall: TextStyle(color: ChatColors.subtle, fontSize: 11),
  ),
);
