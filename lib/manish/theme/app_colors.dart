import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';

class ThemePresetItem {
  final String id;
  final String name;
  final String hindiName;
  final Color primary;
  final Color secondary;
  final Color accent;

  const ThemePresetItem({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  String get primaryHex => '#${(primary.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  String get secondaryHex => '#${(secondary.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  String get accentHex => '#${(accent.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

class AppColors {
  // Available Presets
  static const List<ThemePresetItem> presets = [
    ThemePresetItem(
      id: 'indigo_purple',
      name: 'Classic Indigo & Violet',
      hindiName: 'इंडिगो और वॉयलेट (Classic)',
      primary: Color(0xFF6366F1),
      secondary: Color(0xFF8B5CF6),
      accent: Color(0xFFEC4899),
    ),
    ThemePresetItem(
      id: 'cyber_cyan',
      name: 'Cyber Ocean & Cyan',
      hindiName: 'साइबर ओशन और नियॉन सियान',
      primary: Color(0xFF06B6D4),
      secondary: Color(0xFF3B82F6),
      accent: Color(0xFF10B981),
    ),
    ThemePresetItem(
      id: 'emerald_green',
      name: 'Emerald Growth & Mint',
      hindiName: 'एमराल्ड ग्रीन और मिंट',
      primary: Color(0xFF10B981),
      secondary: Color(0xFF059669),
      accent: Color(0xFFF59E0B),
    ),
    ThemePresetItem(
      id: 'royal_gold',
      name: 'Royal Gold & Amber',
      hindiName: 'रॉयल गोल्ड और एम्बर',
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFD97706),
      accent: Color(0xFF6366F1),
    ),
    ThemePresetItem(
      id: 'crimson_red',
      name: 'Crimson Blaze & Sunset',
      hindiName: 'क्रिमसन रेड और सनसेट ऑरेंज',
      primary: Color(0xFFEF4444),
      secondary: Color(0xFFF97316),
      accent: Color(0xFF8B5CF6),
    ),
    ThemePresetItem(
      id: 'neon_fuchsia',
      name: 'Neon Fuchsia & Pink',
      hindiName: 'नियॉन फुकिया और पिंक',
      primary: Color(0xFFD946EF),
      secondary: Color(0xFF8B5CF6),
      accent: Color(0xFF06B6D4),
    ),
    ThemePresetItem(
      id: 'midnight_sapphire',
      name: 'Midnight Sapphire',
      hindiName: 'मिडनाइट सफायर और स्काई ब्लू',
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF4F46E5),
      accent: Color(0xFF38BDF8),
    ),
  ];

  // Dynamic Brand Gradients
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient heroGradient = const LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient accentGradient = const LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Social / Direct Action
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color callBlue = Color(0xFF0284C7);
  static const Color mailRed = Color(0xFFEA4335);

  // Dark Theme Palette
  static const Color darkBg = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF131C2E);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkCardBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Light Theme Palette
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dynamic Primary & Accents
  static Color primary = const Color(0xFF6366F1);
  static Color primaryLight = const Color(0xFF818CF8);
  static Color secondary = const Color(0xFF8B5CF6);
  static Color accent = const Color(0xFFEC4899);
  static const Color success = Color(0xFF10B981);

  // Utility helpers
  static Color parseHex(String? hex, {Color fallback = const Color(0xFF6366F1)}) {
    if (hex == null || hex.trim().isEmpty) return fallback;
    try {
      String clean = hex.replaceAll('#', '').trim();
      if (clean.length == 6) {
        clean = 'FF$clean';
      }
      if (clean.length == 8) {
        return Color(int.parse(clean, radix: 16));
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  static String toHex(Color color) {
    return '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  static void applyTheme({
    required Color primaryColor,
    required Color secondaryColor,
    required Color accentColor,
  }) {
    primary = primaryColor;
    primaryLight = Color.lerp(primaryColor, Colors.white, 0.25) ?? primaryColor;
    secondary = secondaryColor;
    accent = accentColor;

    primaryGradient = LinearGradient(
      colors: [primaryColor, secondaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    accentGradient = LinearGradient(
      colors: [secondaryColor, primaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    heroGradient = LinearGradient(
      colors: [
        const Color(0xFF0F172A),
        primaryColor.withValues(alpha: 0.25),
        const Color(0xFF0B0F19),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static void applyFromConfig(ProfileConfigModel config) {
    final p = parseHex(config.primaryColorHex, fallback: const Color(0xFF6366F1));
    final s = parseHex(config.secondaryColorHex, fallback: const Color(0xFF8B5CF6));
    final a = parseHex(config.accentColorHex, fallback: const Color(0xFFEC4899));

    applyTheme(primaryColor: p, secondaryColor: s, accentColor: a);
  }
}
