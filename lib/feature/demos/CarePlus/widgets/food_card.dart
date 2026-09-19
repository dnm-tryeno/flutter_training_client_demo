import 'package:flutter/material.dart';
import '../models/food_suggestion.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class FoodCard extends StatelessWidget {
  final FoodSuggestion food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRecommended = food.category == 'Recommended';

    final badgeColor = isRecommended ? AppColors.healthGreen : AppColors.warning;
    final badgeBg = isRecommended
        ? (isDark ? const Color(0xFF064E3B) : AppColors.healthGreenLight)
        : (isDark ? const Color(0xFF78350F) : AppColors.warningLight);

    return HealthCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isRecommended ? Icons.restaurant_rounded : Icons.do_not_disturb_on_rounded,
                  size: 20,
                  color: badgeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.title,
                      style: TextStyle(
                        fontSize: 15 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        food.category,
                        style: TextStyle(
                          fontSize: 11 * state.fontScale,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (food.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              food.description,
              style: TextStyle(
                fontSize: 13 * state.fontScale,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          ...food.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      isRecommended ? Icons.check_circle : Icons.remove_circle_outline,
                      size: 15,
                      color: isRecommended ? AppColors.healthGreen : AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13.5 * state.fontScale,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (food.warning.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.warningDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      food.warning,
                      style: TextStyle(
                        fontSize: 11.5 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.amber[200] : AppColors.warningDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
