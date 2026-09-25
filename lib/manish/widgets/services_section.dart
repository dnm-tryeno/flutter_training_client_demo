import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import 'service_detail_dialog.dart';

class ServicesSection extends StatelessWidget {
  final bool isDark;
  final List<ServiceModel> services;
  final VoidCallback? onOpenAdmin;

  const ServicesSection({
    super.key,
    required this.isDark,
    required this.services,
    this.onOpenAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 950;
    final isTablet = width > 600 && width <= 950;
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 64 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'What I Do (Meri Sevaayein)',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'My Specialized Services',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium(context, isDark: isDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Har business ko modern technology aur results-oriented marketing se scale karne ke liye comprehensive solutions.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(context, isDark: isDark),
              ),
              const SizedBox(height: 40),

              // Grid of Services
              services.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(Icons.miscellaneous_services_rounded, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text('Abhi koi service add nahi ki gayi hai.', style: AppTypography.bodyLarge(context, isDark: isDark)),
                          if (onOpenAdmin != null) ...[
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: onOpenAdmin,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add Service in Admin Panel'),
                            ),
                          ],
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: isDesktop ? 0.92 : (isTablet ? 0.95 : 1.1),
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, i) {
                            final service = services[i];
                            return _buildServiceCard(context, service);
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel service) {
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Action Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: service.accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(service.icon, color: service.accentColor, size: 28),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.whatsappGreen, size: 20),
                onPressed: () {
                  UrlHelper.openWhatsApp(
                    message: 'Namaste Manish ji! Mujhe "${service.titleHindi}" service ke bare me jankari chahiye.',
                    context: context,
                  );
                },
                tooltip: 'WhatsApp Inquiry',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            service.titleHindi,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            service.titleEnglish,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: service.accentColor,
            ),
          ),
          const SizedBox(height: 10),

          // Short Description
          Text(
            service.shortDesc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium(context, isDark: isDark),
          ),
          const SizedBox(height: 12),

          // Sub-offerings bullet preview
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: service.subOfferings.take(3).map((sub) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, color: service.accentColor, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Learn More Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ServiceDetailDialog(service: service, isDark: isDark),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Learn More & Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: service.accentColor,
                side: BorderSide(color: service.accentColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
