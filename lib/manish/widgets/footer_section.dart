import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import '../utils/url_helper.dart';
import 'brand_logo_badge.dart';
import 'whatsapp_icon.dart';

class FooterSection extends StatelessWidget {
  final bool isDark;
  final ProfileConfigModel config;
  final Function(String key) onNavigate;
  final VoidCallback? onOpenAdmin;

  const FooterSection({
    super.key,
    required this.isDark,
    required this.config,
    required this.onNavigate,
    this.onOpenAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    return Container(
      color: isDark ? const Color(0xFF070A10) : const Color(0xFF0F172A),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Top Columns
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildBrandColumn(context)),
                        const SizedBox(width: 36),
                        Expanded(flex: 2, child: _buildQuickLinksColumn('Quick Links', ['home', 'about'])),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _buildQuickLinksColumn('Services', ['services', 'projects'])),
                        const SizedBox(width: 24),
                        Expanded(flex: 4, child: _buildContactColumn(context)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrandColumn(context),
                        const SizedBox(height: 28),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildQuickLinksColumn('Quick Links', ['home', 'about']),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              flex: 3,
                              child: _buildQuickLinksColumn('Services', ['services', 'projects']),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              flex: 4,
                              child: _buildContactColumn(context),
                            ),
                          ],
                        ),
                      ],
                    ),

              const Divider(color: Color(0xFF1E293B), height: 48),

              // Bottom Copyright & Credits
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      Text(
                        '© ${DateTime.now().year} ${config.name}. ${config.copyrightText.isNotEmpty ? config.copyrightText : 'All rights reserved.'}',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                      if (onOpenAdmin != null)
                        InkWell(
                          onTap: onOpenAdmin,
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline_rounded, size: 13, color: AppColors.primaryLight),
                                const SizedBox(width: 4),
                                Text(
                                  'Admin Panel',
                                  style: TextStyle(
                                    color: AppColors.primaryLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildFooterSocialButton(
                        customChild: const WhatsAppIcon(size: 24, color: AppColors.whatsappGreen),
                        color: AppColors.whatsappGreen,
                        tooltip: 'WhatsApp',
                        size: 24,
                        onPressed: () => UrlHelper.openWhatsApp(
                          phone: config.whatsappNumber,
                          message: config.whatsappDefaultMessage,
                          context: context,
                        ),
                      ),
                      _buildFooterSocialButton(
                        icon: Icons.phone_rounded,
                        color: AppColors.callBlue,
                        tooltip: 'Call',
                        size: 24,
                        onPressed: () => UrlHelper.makePhoneCall(phone: config.phone, context: context),
                      ),
                      if (config.youtubeUrl.isNotEmpty)
                        _buildFooterSocialButton(
                          icon: Icons.play_circle_fill_rounded,
                          color: const Color(0xFFFF0000),
                          tooltip: 'YouTube',
                          size: 26,
                          onPressed: () => UrlHelper.openLink(config.youtubeUrl, context: context),
                        ),
                      if (config.instagramUrl.isNotEmpty)
                        _buildFooterSocialButton(
                          icon: Icons.camera_alt_rounded,
                          color: const Color(0xFFE4405F),
                          tooltip: 'Instagram',
                          size: 24,
                          onPressed: () => UrlHelper.openLink(config.instagramUrl, context: context),
                        ),
                      if (config.facebookUrl.isNotEmpty)
                        _buildFooterSocialButton(
                          icon: Icons.facebook_rounded,
                          color: const Color(0xFF1877F2),
                          tooltip: 'Facebook',
                          size: 24,
                          onPressed: () => UrlHelper.openLink(config.facebookUrl, context: context),
                        ),
                      if (config.linkedinUrl.isNotEmpty)
                        _buildFooterSocialButton(
                          icon: Icons.business_rounded,
                          color: const Color(0xFF0A66C2),
                          tooltip: 'LinkedIn',
                          size: 24,
                          onPressed: () => UrlHelper.openLink(config.linkedinUrl, context: context),
                        ),
                      _buildFooterSocialButton(
                        icon: Icons.share_rounded,
                        color: Colors.white,
                        tooltip: 'Share',
                        size: 22,
                        onPressed: () => UrlHelper.sharePortfolio(context: context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSocialButton({
    IconData? icon,
    Widget? customChild,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
    double size = 24,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: IconButton(
        icon: customChild ?? Icon(icon, color: color, size: size),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minWidth: 46, minHeight: 46),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildBrandColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BrandLogoBadge(config: config, size: 38, borderRadius: 10),
            const SizedBox(width: 10),
            Text(
              config.name,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          config.tagline,
          style: TextStyle(color: AppColors.primaryLight, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          config.footerAbout.isNotEmpty
              ? config.footerAbout
              : 'Helping businesses establish commanding digital presence through high-ROI Meta & Google Ads, local SEO supremacy, and ultra-fast web/mobile applications.',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildQuickLinksColumn(String title, List<String> keys) {
    final Map<String, String> labels = {
      'home': 'Home',
      'about': 'About Manish',
      'services': 'My Services',
      'projects': 'Case Studies',
      'contact': 'Contact Me',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        ...keys.map((key) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onNavigate(key),
              child: Text(
                labels[key] ?? key,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildContactColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact & Location',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => UrlHelper.makePhoneCall(phone: config.phone, context: context),
          child: Row(
            children: [
              const Icon(Icons.phone_rounded, color: AppColors.callBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                config.phone,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => UrlHelper.openMapLocation(
            query: config.mapsEmbedQuery.isNotEmpty ? config.mapsEmbedQuery : config.location,
            context: context,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  config.location,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
