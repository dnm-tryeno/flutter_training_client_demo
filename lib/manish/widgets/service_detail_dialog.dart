import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';

class ServiceDetailDialog extends StatelessWidget {
  final ServiceModel service;
  final bool isDark;

  const ServiceDetailDialog({
    super.key,
    required this.service,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: service.accentColor.withValues(alpha: 0.12),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: service.accentColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: service.accentColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(service.icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.titleHindi,
                              style: AppTypography.displayMedium(context, isDark: isDark).copyWith(fontSize: 22),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              service.titleEnglish,
                              style: TextStyle(
                                color: service.accentColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close_rounded, color: textSecondary),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview
                      Text(
                        'Service Overview',
                        style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.detailedDesc,
                        style: AppTypography.bodyLarge(context, isDark: isDark),
                      ),
                      const SizedBox(height: 20),

                      // What is included
                      Text(
                        '✨ What You Get (Shamil Suvidhayein):',
                        style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ...service.subOfferings.map((sub) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_rounded, color: service.accentColor, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    sub,
                                    style: AppTypography.bodyMedium(context, isDark: isDark).copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),

                      // Key Benefits
                      Text(
                        '🚀 Business Benefits (Aapko Kya Fayda Hoga):',
                        style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ...service.benefits.map((benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.arrow_forward_rounded, color: AppColors.success, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: AppTypography.bodyMedium(context, isDark: isDark),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                UrlHelper.openWhatsApp(
                                  message:
                                      'Namaste Manish ji! Mujhe "${service.titleHindi}" service ke baare me discuss karna hai. Details provide karein.',
                                  context: context,
                                );
                              },
                              icon: const Icon(Icons.chat_rounded, color: Colors.white),
                              label: const Text(
                                'WhatsApp Pe Enquire Karein',
                                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.whatsappGreen,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filledTonal(
                            onPressed: () {
                              Navigator.of(context).pop();
                              UrlHelper.makePhoneCall(context: context);
                            },
                            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.callBlue),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            tooltip: 'Direct Call (7380492118)',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
