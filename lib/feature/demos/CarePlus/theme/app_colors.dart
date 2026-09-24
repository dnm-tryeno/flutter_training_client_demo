import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand wordmark / icon (matches CarePlus logo asset)
  static const Color brand = Color(0xFF52887C);

  // Primary Medical Emerald Palette
  static const Color primary = Color(0xFF52887C);
  static const Color primaryDark = Color(0xFF0F766E); // Teal-700
  static const Color primaryLight = Color(0xFFCCFBF1); // Teal-100
  static const Color primarySurface = Color(0xFFF0FDFA); // Teal-50

  // Secondary Healing Blue
  static const Color secondary = Color(0xFF2563EB); // Blue-600
  static const Color secondaryLight = Color(0xFFDBEAFE); // Blue-100
  static const Color secondaryDark = Color(0xFF1D4ED8);

  // Health Accent Greens
  static const Color healthGreen = Color(0xFF10B981); // Emerald-500
  static const Color healthGreenLight = Color(0xFFD1FAE5);

  // Warning & Caution (Amber/Orange)
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber-100
  static const Color warningDark = Color(0xFFB45309);

  // Emergency & Danger (Rose/Red)
  static const Color emergency = Color(0xFFE11D48); // Rose-600
  static const Color emergencyLight = Color(0xFFFFE4E6); // Rose-100
  static const Color emergencyDark = Color(0xFF9F1239);

  // Info & Medical Notice
  static const Color info = Color(0xFF0284C7); // Sky-600
  static const Color infoLight = Color(0xFFE0F2FE);

  // Neutral Light Surfaces
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate-50
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0); // Slate-200
  static const Color dividerLight = Color(0xFFEEF2F6);

  // Neutral Dark Surfaces
  static const Color backgroundDark = Color(0xFF0F172A); // Slate-900
  static const Color surfaceDark = Color(0xFF1E293B); // Slate-800
  static const Color cardDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155); // Slate-700
  static const Color dividerDark = Color(0xFF1E293B);

  // Typography Colors Light
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Typography Colors Dark
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFE11D48), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0FDFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
