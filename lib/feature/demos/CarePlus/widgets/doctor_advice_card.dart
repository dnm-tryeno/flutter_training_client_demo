import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';
import 'custom_button.dart';

class DoctorAdviceCard extends StatelessWidget {
  final String advice;
  final String recommendedSpecialist;
  final VoidCallback onFindDoctor;
  final VoidCallback onBookConsult;
  final VoidCallback onSaveReport;

  const DoctorAdviceCard({
    super.key,
    required this.advice,
    required this.recommendedSpecialist,
    required this.onFindDoctor,
    required this.onBookConsult,
    required this.onSaveReport,
  });

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return HealthCard(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_hospital_rounded, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.tr('doctor_title'),
                      style: TextStyle(
                        fontSize: 16 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Specialist: $recommendedSpecialist',
                      style: TextStyle(
                        fontSize: 12.5 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            advice,
            style: TextStyle(
              fontSize: 13.5 * state.fontScale,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: state.tr('btn_book_consult'),
            icon: Icons.calendar_month_rounded,
            onPressed: onBookConsult,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: state.tr('btn_find_doctor'),
                  icon: Icons.search,
                  variant: ButtonVariant.outline,
                  height: 44,
                  onPressed: onFindDoctor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: state.tr('btn_save_report'),
                  icon: Icons.share_rounded,
                  variant: ButtonVariant.subtle,
                  height: 44,
                  onPressed: onSaveReport,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
