import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';

class DisclaimerBanner extends StatelessWidget {
  final bool compact;
  final VoidCallback? onLearnMore;

  const DisclaimerBanner({
    super.key,
    this.compact = false,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'CarePlus provides general guidance, not medical diagnosis or prescriptions.',
                style: TextStyle(
                  fontSize: 11 * state.fontScale,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF27272A) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline_rounded, size: 20, color: AppColors.warningDark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Safety & General Guidance Notice',
                  style: TextStyle(
                    fontSize: 13 * state.fontScale,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.amber[200] : AppColors.warningDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.tr('disclaimer_text'),
                  style: TextStyle(
                    fontSize: 12 * state.fontScale,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF78350F),
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
