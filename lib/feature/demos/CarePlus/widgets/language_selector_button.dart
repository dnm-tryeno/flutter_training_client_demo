import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../localization/app_language.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class LanguageSelectorButton extends StatelessWidget {
  final bool compact;

  const LanguageSelectorButton({
    super.key,
    this.compact = false,
  });

  static void showLanguageModal(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.language_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Language / भाषा चुनें',
                              style: TextStyle(
                                fontSize: 16 * state.fontScale,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Hindi, English ya Hinglish me use karein',
                              style: TextStyle(
                                fontSize: 12 * state.fontScale,
                                color: isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildLangOption(
              ctx: ctx,
              state: state,
              isDark: isDark,
              lang: AppLanguage.hindi,
              title: 'हिन्दी (Hindi)',
              sub: 'सेहत की सरल और सुरक्षित मार्गदर्शिका',
              icon: Icons.language_rounded,
            ),
            _buildLangOption(
              ctx: ctx,
              state: state,
              isDark: isDark,
              lang: AppLanguage.english,
              title: 'English',
              sub: 'Your Simple Health Guidance Companion',
              icon: Icons.translate_rounded,
            ),
            _buildLangOption(
              ctx: ctx,
              state: state,
              isDark: isDark,
              lang: AppLanguage.hinglish,
              title: 'Hinglish',
              sub: 'Sehat ki simple aur safe guidance',
              icon: Icons.chat_bubble_outline_rounded,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static Widget _buildLangOption({
    required BuildContext ctx,
    required CarePlusState state,
    required bool isDark,
    required AppLanguage lang,
    required String title,
    required String sub,
    required IconData icon,
  }) {
    final isSelected = state.language == lang;

    return HealthCard(
      onTap: () {
        state.setLanguage(lang);
        Navigator.of(ctx).pop();
      },
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      border: Border.all(
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.borderDark : AppColors.borderLight),
        width: isSelected ? 2 : 1,
      ),
      backgroundColor: isSelected
          ? (isDark ? const Color(0xFF134E4A) : AppColors.primarySurface)
          : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textPrimaryDark : AppColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15 * state.fontScale,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11.5 * state.fontScale,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String label;
    switch (state.language) {
      case AppLanguage.hindi:
        label = 'हिन्दी';
        break;
      case AppLanguage.hinglish:
        label = 'Hinglish';
        break;
      case AppLanguage.english:
        label = 'English';
        break;
    }

    return InkWell(
      onTap: () => showLanguageModal(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E293B)
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5 * state.fontScale,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
