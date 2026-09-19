import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../localization/app_language.dart';

class ProblemInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onQuickSelect;
  final ValueChanged<String>? onChanged;

  const ProblemInputWidget({
    super.key,
    required this.controller,
    required this.onQuickSelect,
    this.onChanged,
  });

  static const List<Map<String, String>> commonProblems = [
    {'en': 'Pet me dard hai (Stomach pain)', 'hi': 'पेट में दर्द है', 'query': 'Pet me dard hai / Stomach pain'},
    {'en': 'Sir dard hai (Headache)', 'hi': 'सिर में दर्द है', 'query': 'Sir dard hai / Headache'},
    {'en': 'Acidity & Gas issue', 'hi': 'एसिडिटी और गैस की समस्या', 'query': 'Acidity & Gas issue'},
    {'en': 'Back pain / Kamar dard', 'hi': 'कमर में दर्द (Back pain)', 'query': 'Back pain / Kamar dard'},
    {'en': 'Thakan hoti hai (Fatigue & weakness)', 'hi': 'थकान और कमजोरी होती है', 'query': 'Thakan hoti hai / Fatigue & weakness'},
    {'en': 'Neend nahi aa rahi (Sleep trouble)', 'hi': 'नींद नहीं आ रही (Insomnia)', 'query': 'Neend nahi aa rahi / Sleep trouble'},
    {'en': 'Weight badh raha hai', 'hi': 'वजन बढ़ रहा है (Weight gain)', 'query': 'Weight badh raha hai'},
    {'en': 'Blood pressure high rehta hai', 'hi': 'ब्लड प्रेशर हाई रहता है', 'query': 'Blood pressure high rehta hai'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.tr('problem_input_title'),
          style: TextStyle(
            fontSize: 15 * state.fontScale,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          state.tr('problem_input_subtitle'),
          style: TextStyle(
            fontSize: 13 * state.fontScale,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 3,
          minLines: 2,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 15 * state.fontScale,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            hintText: state.tr('problem_hint'),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Icon(Icons.edit_note_rounded, color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          state.tr('select_common_problems'),
          style: TextStyle(
            fontSize: 13 * state.fontScale,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: commonProblems.map((prob) {
            final isSelected = controller.text.toLowerCase().contains(prob['query']!.toLowerCase().split(' ').first);
            return FilterChip(
              label: Text(
                state.language == AppLanguage.hindi ? prob['hi']! : prob['en']!,
                style: TextStyle(
                  fontSize: 12 * state.fontScale,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) {
                controller.text = prob['query']!;
                onQuickSelect(prob['query']!);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
