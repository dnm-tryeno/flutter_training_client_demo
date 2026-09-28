import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import 'brand_logo_badge.dart';

class PortfolioNavBar extends StatelessWidget {
  final bool isDark;
  final String currentTab;
  final ProfileConfigModel config;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenCms;
  final Function(String sectionKey) onNavigate;

  const PortfolioNavBar({
    super.key,
    required this.isDark,
    this.currentTab = 'home',
    required this.config,
    required this.onToggleTheme,
    required this.onOpenCms,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBg : AppColors.lightBg).withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkCardBorder.withValues(alpha: 0.6) : AppColors.lightCardBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo / Branding
          Flexible(
            child: InkWell(
              onTap: () => onNavigate('home'),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrandLogoBadge(config: config, size: 38, borderRadius: 10),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          config.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          config.locationShort,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Back Button
          ElevatedButton.icon(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                onNavigate('home');
              }
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text(
              'Back to Home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkCard : const Color(0xFFE2E8F0),
              foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Theme Toggle
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF475569),
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),

          // Admin / CMS Shortcut
          IconButton(
            onPressed: onOpenCms,
            icon: Icon(Icons.tune_rounded, color: AppColors.primary),
            tooltip: 'Admin Panel (Customize Everything)',
          ),
        ],
      ),
    );
  }
}
