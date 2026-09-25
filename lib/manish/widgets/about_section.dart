import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import 'app_smart_image.dart';

class AboutSection extends StatelessWidget {
  final bool isDark;
  final ProfileConfigModel config;

  const AboutSection({
    super.key,
    required this.isDark,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 860;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 64 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Section Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  config.aboutHeading.isNotEmpty ? config.aboutHeading : 'About ${config.name}',
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
                config.aboutSubtitle.isNotEmpty ? config.aboutSubtitle : config.tagline,
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium(context, isDark: isDark),
              ),
              const SizedBox(height: 36),

              // Responsive Content Card
              Container(
                padding: EdgeInsets.all(isDesktop ? 36 : 20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bio Row
                    isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileBadge(context),
                              const SizedBox(width: 32),
                              Expanded(child: _buildBioDetails(context, textPrimary)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildProfileBadge(context),
                              const SizedBox(height: 24),
                              _buildBioDetails(context, textPrimary),
                            ],
                          ),

                    const Divider(height: 48),

                    // Core Pillars Cards
                    Text(
                      'Core Expertise & Skills Focus:',
                      style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSkillBadge(Icons.trending_up_rounded, 'Digital Marketing', const Color(0xFF6366F1)),
                        _buildSkillBadge(Icons.campaign_rounded, 'Meta Ads (FB & Insta)', const Color(0xFFEC4899)),
                        _buildSkillBadge(Icons.search_rounded, 'SEO & Local Google Ranking', const Color(0xFF10B981)),
                        _buildSkillBadge(Icons.ads_click_rounded, 'Google Ads (PPC)', const Color(0xFFF59E0B)),
                        _buildSkillBadge(Icons.laptop_mac_rounded, 'Website Development', const Color(0xFF38BDF8)),
                        _buildSkillBadge(Icons.phone_android_rounded, 'App Development (Flutter)', const Color(0xFF8B5CF6)),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Quick Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => UrlHelper.openMapLocation(query: config.mapsEmbedQuery.isNotEmpty ? config.mapsEmbedQuery : config.location, context: context),
                            icon: Icon(Icons.pin_drop_rounded, color: AppColors.primary),
                            label: Text(
                              'Location: ${config.locationShort}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textPrimary,
                              side: BorderSide(
                                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => UrlHelper.sharePortfolio(context: context),
                          icon: const Icon(Icons.share_rounded, size: 18),
                          label: const Text('Share Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
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
    );
  }

  Widget _buildProfileBadge(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: ClipOval(
              child: config.avatarUrl.isNotEmpty
                  ? AppSmartImage(
                      imageUrl: config.avatarUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        width: 64,
                        height: 64,
                        color: AppColors.primary,
                        child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
                      ),
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: AppColors.primary,
                      child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            config.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            config.locationShort,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBioDetails(BuildContext context, Color textPrimary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Goal & Mission',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          config.aboutBio,
          style: AppTypography.bodyLarge(context, isDark: isDark),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  config.aboutMission.isNotEmpty
                      ? config.aboutMission
                      : 'Har business ke liye customized digital blueprint aur continuous growth execution.',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillBadge(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
