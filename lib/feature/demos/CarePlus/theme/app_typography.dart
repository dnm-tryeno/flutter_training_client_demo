import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(bool isDark, double fontScale) {
    final baseColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32 * fontScale,
        fontWeight: FontWeight.w800,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 26 * fontScale,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -0.3,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22 * fontScale,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 19 * fontScale,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 17 * fontScale,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 15 * fontScale,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16 * fontScale,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14 * fontScale,
        fontWeight: FontWeight.w400,
        color: subColor,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12 * fontScale,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15 * fontScale,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 13 * fontScale,
        fontWeight: FontWeight.w500,
        color: subColor,
      ),
    );
  }
}
