import 'package:flutter/material.dart';
import '../models/medicine_safety_item.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class MedicineSafetyCard extends StatelessWidget {
  final MedicineSafetyItem medicine;

  const MedicineSafetyCard({super.key, required this.medicine});

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
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.medication_liquid_rounded, size: 22, color: AppColors.info),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: TextStyle(
                        fontSize: 15 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      medicine.genericCategory,
                      style: TextStyle(
                        fontSize: 12 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mandatory Warning Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3E1C1C) : const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.emergency.withValues(alpha: 0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.emergency),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    medicine.mandatoryWarning,
                    style: TextStyle(
                      fontSize: 11.5 * state.fontScale,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.red[200] : AppColors.emergencyDark,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // General Purpose
          Text(
            state.tr('medicine_purpose'),
            style: TextStyle(
              fontSize: 12.5 * state.fontScale,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            medicine.generalPurpose,
            style: TextStyle(
              fontSize: 13 * state.fontScale,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),

          // Common Precautions
          Text(
            state.tr('medicine_precautions'),
            style: TextStyle(
              fontSize: 12.5 * state.fontScale,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          ...medicine.commonPrecautions.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.shield_outlined, size: 12, color: AppColors.primary),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.5 * state.fontScale,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Common Side Effects
          Text(
            state.tr('medicine_side_effects'),
            style: TextStyle(
              fontSize: 12.5 * state.fontScale,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          ...medicine.commonSideEffects.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.info_outline, size: 12, color: AppColors.warning),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.5 * state.fontScale,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Reference & Reviewer Footer
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Reviewed by: ${medicine.medicalReviewer} (${medicine.lastReviewedDate})',
                    style: TextStyle(
                      fontSize: 10.5 * state.fontScale,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
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
