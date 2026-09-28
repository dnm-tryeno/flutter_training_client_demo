import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import 'app_smart_image.dart';
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
                        final double aspect = isDesktop
                            ? 0.92
                            : (isTablet
                                ? 0.95
                                : (constraints.maxWidth < 400 ? 0.95 : 1.05));
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: aspect,
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
    final hasImage = service.imageUrl.isNotEmpty;

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
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full background image covering entire box
          if (hasImage) ...[
            AppSmartImage(
              imageUrl: service.imageUrl,
              fit: BoxFit.cover,
              errorWidget: Container(color: service.accentColor.withValues(alpha: 0.15)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.65),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ],

          // Card Foreground Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon & Action Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: hasImage ? service.accentColor.withValues(alpha: 0.95) : service.accentColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: hasImage
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          service.icon,
                          color: hasImage ? Colors.white : service.accentColor,
                          size: 26,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: hasImage ? Colors.black.withValues(alpha: 0.4) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.whatsappGreen, size: 20),
                        onPressed: () {
                          UrlHelper.openWhatsApp(
                            message: 'Namaste Manish ji! Mujhe "${service.titleHindi}" service ke bare me jankari chahiye.',
                            context: context,
                          );
                        },
                        tooltip: 'WhatsApp Inquiry',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  service.titleHindi,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: hasImage ? Colors.white : textPrimary,
                    shadows: hasImage ? const [Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 2))] : null,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  service.titleEnglish,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: hasImage ? Colors.white70 : service.accentColor,
                    shadows: hasImage ? const [Shadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 1))] : null,
                  ),
                ),
                const SizedBox(height: 10),

                // Short Description
                Text(
                  service.shortDesc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: hasImage
                      ? const TextStyle(fontSize: 14.5, color: Colors.white70, height: 1.45, shadows: [Shadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 1))])
                      : const TextStyle(fontSize: 14.5, height: 1.45, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Sub-offerings bullet preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: service.subOfferings.take(3).map((sub) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: hasImage ? Colors.white70 : service.accentColor,
                              size: 16,
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                sub,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: hasImage ? Colors.white.withValues(alpha: 0.92) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                  shadows: hasImage ? const [Shadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 1))] : null,
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
                    icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                    label: const Text('Learn More & Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: hasImage ? Colors.white : service.accentColor,
                      backgroundColor: hasImage ? service.accentColor.withValues(alpha: 0.35) : null,
                      side: BorderSide(color: hasImage ? Colors.white54 : service.accentColor.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
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
