import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';

enum WarningSeverity {
  info,
  warning,
  danger,
}

class WarningCard extends StatelessWidget {
  final String title;
  final String message;
  final WarningSeverity severity;

  const WarningCard({
    super.key,
    required this.title,
    required this.message,
    this.severity = WarningSeverity.warning,
  });

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color border;
    Color iconColor;
    Color titleColor;
    IconData icon;

    switch (severity) {
      case WarningSeverity.info:
        bg = isDark ? const Color(0xFF0C4A6E) : AppColors.infoLight;
        border = AppColors.info.withValues(alpha: 0.4);
        iconColor = AppColors.info;
        titleColor = isDark ? Colors.lightBlue[200]! : const Color(0xFF0369A1);
        icon = Icons.info_outline_rounded;
        break;
      case WarningSeverity.warning:
        bg = isDark ? const Color(0xFF451A03) : const Color(0xFFFFFBEB);
        border = AppColors.warning.withValues(alpha: 0.4);
        iconColor = AppColors.warning;
        titleColor = isDark ? Colors.amber[200]! : AppColors.warningDark;
        icon = Icons.warning_amber_rounded;
        break;
      case WarningSeverity.danger:
        bg = isDark ? const Color(0xFF4C0519) : const Color(0xFFFFF1F2);
        border = AppColors.emergency.withValues(alpha: 0.4);
        iconColor = AppColors.emergency;
        titleColor = isDark ? Colors.red[200]! : AppColors.emergencyDark;
        icon = Icons.error_outline_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty) ...[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5 * state.fontScale,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.5 * state.fontScale,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                    height: 1.4,
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
