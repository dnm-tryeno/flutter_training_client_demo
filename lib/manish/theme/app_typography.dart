import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle displayLarge(BuildContext context, {bool isDark = true, Color? color}) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width > 900 ? 44.0 : (width > 600 ? 36.0 : 28.0);
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.15,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  static TextStyle displayMedium(BuildContext context, {bool isDark = true, Color? color}) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width > 900 ? 32.0 : (width > 600 ? 26.0 : 22.0);
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.2,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  static TextStyle headlineSmall(BuildContext context, {bool isDark = true, Color? color}) {
    return GoogleFonts.outfit(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  static TextStyle titleLarge(BuildContext context, {bool isDark = true, Color? color}) {
    return GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  static TextStyle bodyLarge(BuildContext context, {bool isDark = true, Color? color}) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width > 600 ? 16.0 : 15.0;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    );
  }

  static TextStyle bodyMedium(BuildContext context, {bool isDark = true, Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    );
  }

  static TextStyle labelLarge(BuildContext context, {bool isDark = true, Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  static TextStyle caption(BuildContext context, {bool isDark = true, Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: color ?? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
    );
  }
}
