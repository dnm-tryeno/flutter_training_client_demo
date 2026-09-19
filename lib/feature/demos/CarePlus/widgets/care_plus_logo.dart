import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Brand mark matching the CarePlus logo: teal rounded square, heart, wordmark.
class CarePlusLogo extends StatelessWidget {
  const CarePlusLogo({
    super.key,
    this.fontScale = 1,
    this.textColor,
    this.fontSize = 20,
    this.iconBoxSize = 34,
    this.heartIconSize = 17,
    this.useBrandAsset = true,
    this.height,
    this.maxWidth,
  });

  final double fontScale;
  final Color? textColor;
  final double fontSize;
  final double iconBoxSize;
  final double heartIconSize;
  final bool useBrandAsset;
  final double? height;
  final double? maxWidth;

  static const String _assetPath = 'assets/images/care_plus_logo.png';

  @override
  Widget build(BuildContext context) {
    final logoHeight = height ?? (fontSize * fontScale * 1.55);

    if (useBrandAsset) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: logoHeight,
          maxWidth: maxWidth ?? 148,
        ),
        child: Image.asset(
          _assetPath,
          height: logoHeight,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => _buildWordmark(context),
        ),
      );
    }

    return _buildWordmark(context);
  }

  Widget _buildWordmark(BuildContext context) {
    final labelColor = textColor ?? AppColors.brand;
    final boxSize = iconBoxSize * fontScale;
    final cornerRadius = boxSize * 0.26;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: boxSize,
          height: boxSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.brand,
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
          child: Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: heartIconSize * fontScale,
          ),
        ),
        SizedBox(width: 8 * fontScale),
        Text(
          'CarePlus',
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize * fontScale,
            fontWeight: FontWeight.w700,
            color: labelColor,
            letterSpacing: -0.2,
            height: 1,
          ),
        ),
      ],
    );
  }
}
