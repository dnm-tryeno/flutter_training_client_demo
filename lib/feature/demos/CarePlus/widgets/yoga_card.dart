import 'package:flutter/material.dart';
import '../models/yoga_exercise.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class YogaCard extends StatelessWidget {
  final YogaExercise yoga;

  const YogaCard({super.key, required this.yoga});

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return HealthCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.self_improvement_rounded, size: 22, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yoga.title,
                      style: TextStyle(
                        fontSize: 15 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, size: 12, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                yoga.duration,
                                style: TextStyle(
                                  fontSize: 11 * state.fontScale,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.healthGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            yoga.intensity,
                            style: TextStyle(
                              fontSize: 11 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: AppColors.healthGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (yoga.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              yoga.description,
              style: TextStyle(
                fontSize: 13 * state.fontScale,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            state.tr('instructions_label'),
            style: TextStyle(
              fontSize: 13 * state.fontScale,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          ...yoga.steps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 13 * state.fontScale,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3B1E1E) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.emergency.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.emergency),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    yoga.safetyWarning,
                    style: TextStyle(
                      fontSize: 11.5 * state.fontScale,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.red[200] : AppColors.emergencyDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
