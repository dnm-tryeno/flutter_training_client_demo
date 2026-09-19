import 'package:flutter/material.dart';
import '../models/health_history_record.dart';
import '../models/health_guidance_result.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class HealthHistoryCard extends StatelessWidget {
  final HealthHistoryRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HealthHistoryCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color badgeColor;
    Color badgeBg;

    switch (record.riskLevel) {
      case RiskLevel.low:
        badgeColor = AppColors.healthGreen;
        badgeBg = isDark ? const Color(0xFF064E3B) : AppColors.healthGreenLight;
        break;
      case RiskLevel.moderate:
        badgeColor = AppColors.warning;
        badgeBg = isDark ? const Color(0xFF78350F) : AppColors.warningLight;
        break;
      case RiskLevel.consultDoctor:
        badgeColor = AppColors.secondary;
        badgeBg = isDark ? const Color(0xFF1E3A8A) : AppColors.secondaryLight;
        break;
      case RiskLevel.emergency:
        badgeColor = AppColors.emergency;
        badgeBg = isDark ? const Color(0xFF881337) : AppColors.emergencyLight;
        break;
    }

    final dateStr = '${record.date.day} ${_monthName(record.date.month)} ${record.date.year}';

    return HealthCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.event_note_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 12.5 * state.fontScale,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      record.riskLevel == RiskLevel.emergency ? 'Emergency' : record.riskLevel.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.5 * state.fontScale,
                        fontWeight: FontWeight.w800,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                    tooltip: 'Delete Check',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.reportedProblem,
            style: TextStyle(
              fontSize: 15.5 * state.fontScale,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          if (record.symptoms.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: record.symptoms.take(3).map((sym) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    sym,
                    style: TextStyle(
                      fontSize: 11 * state.fontScale,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'View Full Report',
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  static String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return (month >= 1 && month <= 12) ? months[month - 1] : '';
  }
}
