import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  emergency,
  subtle,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide borderSide = BorderSide.none;
    Gradient? gradient;

    switch (variant) {
      case ButtonVariant.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        gradient = AppColors.primaryGradient;
        break;
      case ButtonVariant.secondary:
        bg = AppColors.secondary;
        fg = Colors.white;
        break;
      case ButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case ButtonVariant.emergency:
        bg = AppColors.emergency;
        fg = Colors.white;
        gradient = AppColors.emergencyGradient;
        break;
      case ButtonVariant.subtle:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        bg = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
        fg = isDark ? Colors.white : AppColors.textPrimaryLight;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null ? null : gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: variant == ButtonVariant.primary && onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : variant == ButtonVariant.emergency && onPressed != null
                  ? [
                      BoxShadow(
                        color: AppColors.emergency.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: gradient != null ? Colors.transparent : bg,
            foregroundColor: fg,
            disabledBackgroundColor: bg.withValues(alpha: 0.4),
            disabledForegroundColor: fg.withValues(alpha: 0.6),
            shadowColor: Colors.transparent,
            side: borderSide,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
            padding: padding,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: fg),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: fg,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
