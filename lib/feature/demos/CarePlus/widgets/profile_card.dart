import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEdit;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bmiColor;
    final bmiVal = profile.bmi;
    if (bmiVal < 18.5) {
      bmiColor = AppColors.warning;
    } else if (bmiVal < 25.0) {
      bmiColor = AppColors.healthGreen;
    } else if (bmiVal < 30.0) {
      bmiColor = AppColors.warning;
    } else {
      bmiColor = AppColors.emergency;
    }

    return HealthCard(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: TextStyle(
                        fontSize: 18 * state.fontScale,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${profile.age} yrs • ${profile.gender}${profile.location.isNotEmpty ? " • ${profile.location}" : ""}',
                      style: TextStyle(
                        fontSize: 13 * state.fontScale,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                tooltip: 'Edit Profile',
                onPressed: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // BMI Gauge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Body Mass Index (BMI)',
                        style: TextStyle(
                          fontSize: 12 * state.fontScale,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '$bmiVal',
                            style: TextStyle(
                              fontSize: 20 * state.fontScale,
                              fontWeight: FontWeight.w800,
                              color: bmiColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: bmiColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                profile.bmiCategory,
                                style: TextStyle(
                                  fontSize: 11 * state.fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: bmiColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    _metricChip('${profile.heightCm.toInt()} cm', 'Height', state, isDark),
                    const SizedBox(width: 8),
                    _metricChip('${profile.weightKg.toInt()} kg', 'Weight', state, isDark),
                  ],
                ),
              ],
            ),
          ),
          if (profile.conditions.isNotEmpty || profile.allergies.isNotEmpty || profile.isPregnant) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (profile.isPregnant)
                  _tagChip('Pregnant', AppColors.secondary, isDark),
                ...profile.conditions.map((c) => _tagChip(c, AppColors.info, isDark)),
                ...profile.allergies.map((a) => _tagChip('Allergy: $a', AppColors.warning, isDark)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _metricChip(String val, String label, CarePlusState state, bool isDark) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 14 * state.fontScale,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11 * state.fontScale,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _tagChip(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : color,
        ),
      ),
    );
  }
}
