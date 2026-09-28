import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../models/why_work_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import 'app_smart_image.dart';

class WhyWorkWithMeSection extends StatelessWidget {
  final bool isDark;
  final List<WhyWorkModel> items;
  final ProfileConfigModel config;

  const WhyWorkWithMeSection({
    super.key,
    required this.isDark,
    required this.items,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTablet = width > 600 && width <= 900;
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 64 : 40,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1322) : const Color(0xFFF1F5F9),
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
                  'Key Value Proposition',
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
                'Why Work With ${config.name}?',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium(context, isDark: isDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Aapke business ke liye dedicated, transparent aur result-driven digital partnership.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(context, isDark: isDark),
              ),
              const SizedBox(height: 40),

              // Grid of value pillars
              LayoutBuilder(
                builder: (context, constraints) {
                  final double aspect = isDesktop
                      ? 1.4
                      : (isTablet ? 1.35 : (constraints.maxWidth < 420 ? 1.25 : 1.35));
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: aspect,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final Color color = item.color;
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
                        child: item.imageUrl.isNotEmpty
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Full background image covering entire box
                                  AppSmartImage(
                                    imageUrl: item.imageUrl,
                                    fit: BoxFit.cover,
                                    errorWidget: Container(
                                      color: color.withValues(alpha: 0.2),
                                      child: Center(
                                        child: Icon(item.icon, color: color, size: 36),
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay for clean text contrast
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.2),
                                          Colors.black.withValues(alpha: 0.5),
                                          Colors.black.withValues(alpha: 0.9),
                                        ],
                                        stops: const [0.0, 0.45, 1.0],
                                      ),
                                    ),
                                  ),
                                  // Text & Icon content inside card
                                  Padding(
                                    padding: const EdgeInsets.all(22),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Custom Icon Badge
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.9),
                                            borderRadius: BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.35),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(item.icon, color: Colors.white, size: 24),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 2)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.subtitleHindi,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                            color: Colors.white.withValues(alpha: 0.92),
                                            height: 1.45,
                                            shadows: const [
                                              Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 2)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(child: Icon(item.icon, color: color, size: 26)),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.subtitleHindi,
                                      style: const TextStyle(fontSize: 14.5, height: 1.45, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 36),

              // Direct Consultation Banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.support_agent_rounded, size: 32, color: Colors.white),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Ready to grow your business online?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Free consultation ke liye aaj hi WhatsApp ya direct call par connect karein.',
                            style: TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: () => UrlHelper.openWhatsApp(
                              phone: config.whatsappNumber,
                              message: config.whatsappDefaultMessage,
                              context: context,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Chat on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        const Icon(Icons.support_agent_rounded, size: 40, color: Colors.white),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ready to grow your business online?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Free consultation ke liye aaj hi WhatsApp ya direct call par connect karein.',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => UrlHelper.openWhatsApp(
                            phone: config.whatsappNumber,
                            message: config.whatsappDefaultMessage,
                            context: context,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Chat on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
