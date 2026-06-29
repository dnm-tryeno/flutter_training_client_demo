import 'package:flutter/material.dart';

/// Color + theme tokens for the LMS (Learning Management System) demo.
///
/// Inspired by green education platforms (univ.live / Classplus style).
class LmsColors {
  static const primary = Color(0xFF16A34A); // education green
  static const primaryDark = Color(0xFF0F7A37);
  static const accent = Color(0xFF2563EB); // chart / link blue
  static const accentCyan = Color(0xFF22D3EE);
  static const purple = Color(0xFF7C5CFF); // "Learner Deep Dive" card

  static const background = Color(0xFFF5F6F8);
  static const surface = Colors.white;
  static const divider = Color(0xFFE6E8EB);

  static const textPrimary = Color(0xFF1A1D1F);
  static const textSecondary = Color(0xFF6B7280);

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
}

final ThemeData lmsTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: LmsColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: LmsColors.primary,
    primary: LmsColors.primary,
    secondary: LmsColors.accent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: LmsColors.surface,
    foregroundColor: LmsColors.textPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: LmsColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardThemeData(
    color: LmsColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: LmsColors.divider),
    ),
  ),
  dividerColor: LmsColors.divider,
);

/// Small reusable rounded "pill" chip used across the demo.
class LmsPill extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  const LmsPill(this.text, {super.key, this.color, this.textColor, this.icon});

  @override
  Widget build(BuildContext context) {
    final bg = color ?? LmsColors.background;
    final fg = textColor ?? LmsColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LmsColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header with a title and optional "See all" trailing action.
class LmsSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const LmsSectionHeader(this.title, {super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: LmsColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: LmsColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
