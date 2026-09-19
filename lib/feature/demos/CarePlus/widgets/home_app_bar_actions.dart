import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'language_selector_button.dart';
import '../pages/ai_assistant_page.dart';

/// Home header controls: language, dark mode switch, AI chat.
class HomeAppBarActions extends StatelessWidget {
  const HomeAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = state.isDarkMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LanguageSelectorButton(),
        const SizedBox(width: 6),
        _ThemeSwitchChip(
          isDark: isDark,
          onChanged: state.toggleDarkMode,
          fontScale: state.fontScale,
        ),
        IconButton(
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.forum_outlined, color: AppColors.primary),
          tooltip: state.tr('nav_ai_assistant'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AIAssistantPage()),
          ),
        ),
      ],
    );
  }
}

class _ThemeSwitchChip extends StatelessWidget {
  const _ThemeSwitchChip({
    required this.isDark,
    required this.onChanged,
    required this.fontScale,
  });

  final bool isDark;
  final ValueChanged<bool> onChanged;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 2),
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
          Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          Transform.scale(
            scale: 0.82,
            child: Switch.adaptive(
              value: isDark,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.45),
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
