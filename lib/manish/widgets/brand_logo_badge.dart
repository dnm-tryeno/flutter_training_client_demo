import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import 'app_smart_image.dart';

class BrandLogoBadge extends StatelessWidget {
  final ProfileConfigModel config;
  final double size;
  final double borderRadius;
  final double? fontSize;
  final bool hasShadow;

  const BrandLogoBadge({
    super.key,
    required this.config,
    this.size = 38,
    this.borderRadius = 10,
    this.fontSize,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = config.logoImageUrl.trim().isNotEmpty;
    final text = config.logoText.trim().isNotEmpty ? config.logoText.trim() : 'MM';

    final effectiveFontSize = fontSize ?? (text.length <= 2 ? (size * 0.44) : (size * 0.32));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.38),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? AppSmartImage(
              imageUrl: config.logoImageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorWidget: _buildTextLogo(text, effectiveFontSize),
            )
          : _buildTextLogo(text, effectiveFontSize),
    );
  }

  Widget _buildTextLogo(String text, double effectiveFontSize) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: effectiveFontSize,
              letterSpacing: text.length <= 2 ? 1.0 : 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
