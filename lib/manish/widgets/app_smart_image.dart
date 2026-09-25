import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppSmartImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const AppSmartImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl.trim();

    Widget content;

    if (cleanUrl.isEmpty) {
      content = placeholder ?? _defaultPlaceholder();
    } else if (cleanUrl.startsWith('data:image')) {
      try {
        final commaIdx = cleanUrl.indexOf(',');
        if (commaIdx != -1) {
          final base64Data = cleanUrl.substring(commaIdx + 1);
          final bytes = base64Decode(base64Data);
          content = Image.memory(
            bytes,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
          );
        } else {
          content = errorWidget ?? _defaultError();
        }
      } catch (e) {
        content = errorWidget ?? _defaultError();
      }
    } else if (cleanUrl.startsWith('assets/')) {
      content = Image.asset(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
      );
    } else {
      content = Image.network(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.primary.withValues(alpha: 0.12),
      child: Center(
        child: Icon(Icons.image_outlined, color: AppColors.primary, size: 28),
      ),
    );
  }

  Widget _defaultError() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.withValues(alpha: 0.15),
      child: const Center(
        child: Icon(Icons.broken_image_rounded, color: Colors.grey, size: 28),
      ),
    );
  }
}
