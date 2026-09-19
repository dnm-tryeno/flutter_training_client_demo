import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HealthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final double borderRadius;
  final List<BoxShadow>? shadows;

  const HealthCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 6),
    this.backgroundColor,
    this.border,
    this.onTap,
    this.gradient,
    this.borderRadius = 16,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = backgroundColor ?? (isDark ? AppColors.cardDark : AppColors.cardLight);
    final defaultBorder = border ??
        Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.0,
        );

    final cardChild = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? defaultBg : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: defaultBorder,
        boxShadow: shadows ??
            [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    return cardChild;
  }
}
