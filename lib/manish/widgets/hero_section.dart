import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import 'app_smart_image.dart';

class HeroSection extends StatelessWidget {
  final bool isDark;
  final ProfileConfigModel config;
  final Function(String key) onNavigate;

  const HeroSection({
    super.key,
    required this.isDark,
    required this.config,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0B0F19), Color(0xFF131A2E), Color(0xFF0B0F19)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 60 : 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: _buildHeroContent(context, isDesktop)),
                    const SizedBox(width: 40),
                    Expanded(flex: 5, child: _buildHeroProfileCard(context, isDesktop)),
                  ],
                )
              : Column(
                  children: [
                    _buildHeroProfileCard(context, isDesktop),
                    const SizedBox(height: 32),
                    _buildHeroContent(context, isDesktop),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Location Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                config.locationShort,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Name
        Text(
          config.name,
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          style: AppTypography.displayLarge(context, isDark: isDark),
        ),
        const SizedBox(height: 8),

        // Headline
        ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
          child: Text(
            config.tagline,
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: AppTypography.displayMedium(context, isDark: isDark).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Hindi/Hinglish Intro
        Text(
          config.heroSubtitle,
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          style: AppTypography.bodyLarge(context, isDark: isDark),
        ),
        const SizedBox(height: 28),

        // Main Action Buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => onNavigate('services'),
              icon: const Icon(Icons.miscellaneous_services_rounded, size: 18),
              label: const Text('My Services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => onNavigate('projects'),
              icon: const Icon(Icons.rocket_launch_rounded, size: 18),
              label: const Text('My Projects'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkCard : const Color(0xFFE0E7FF),
                foregroundColor: isDark ? Colors.white : AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate('contact'),
              icon: const Icon(Icons.mail_outline_rounded, size: 18),
              label: const Text('Contact Me'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                side: BorderSide(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Direct Reach: WhatsApp & Call buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => UrlHelper.openWhatsApp(
                phone: config.whatsappNumber,
                message: config.whatsappDefaultMessage,
                context: context,
              ),
              icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
              label: Text(
                'WhatsApp (${config.whatsappNumber})',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.whatsappGreen,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => UrlHelper.makePhoneCall(phone: config.phone, context: context),
              icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
              label: Text(
                'Call Now: ${config.phone}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.callBlue,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroProfileCard(BuildContext context, bool isDesktop) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Glowing background aura
          Container(
            width: isDesktop ? 340 : 260,
            height: isDesktop ? 340 : 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.35),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // Main Avatar Card (Full Circular Photo)
          Container(
            width: isDesktop ? 290 : 230,
            height: isDesktop ? 290 : 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5),
            child: ClipOval(
              child: config.avatarUrl.isNotEmpty
                  ? AppSmartImage(
                      imageUrl: config.avatarUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Container(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ),

          // Floating Badges
          if (config.heroBadge1.isNotEmpty)
            Positioned(
              bottom: -8,
              right: isDesktop ? 10 : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      config.heroBadge1,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          if (config.heroBadge2.isNotEmpty)
            Positioned(
              top: 10,
              left: isDesktop ? -10 : -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, color: AppColors.accent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      config.heroBadge2,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
