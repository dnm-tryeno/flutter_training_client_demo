import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import '../utils/url_helper.dart';

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
                        const SizedBox(width: 40),
                        Expanded(flex: 2, child: _buildQuickLinksColumn('Quick Links', ['home', 'about'])),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _buildQuickLinksColumn('Services & Work', ['services', 'projects', 'contact'])),
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
                            Expanded(child: _buildQuickLinksColumn('Quick Links', ['home', 'about'])),
                            Expanded(child: _buildQuickLinksColumn('Services', ['services', 'projects', 'contact'])),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _buildContactColumn(context),
                      ],
                    ),

              const Divider(color: Color(0xFF1E293B), height: 48),

              // Bottom Copyright & Credits
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '© ${DateTime.now().year} ${config.name}. ${config.copyrightText.isNotEmpty ? config.copyrightText : 'All rights reserved.'}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                        if (onOpenAdmin != null) ...[
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: onOpenAdmin,
                            child: Row(
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
                        ],
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_rounded, color: AppColors.whatsappGreen, size: 20),
                        onPressed: () => UrlHelper.openWhatsApp(
                          phone: config.whatsappNumber,
                          message: config.whatsappDefaultMessage,
                          context: context,
                        ),
                        tooltip: 'WhatsApp',
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone_rounded, color: AppColors.callBlue, size: 20),
                        onPressed: () => UrlHelper.makePhoneCall(phone: config.phone, context: context),
                        tooltip: 'Call',
                      ),
                      if (config.githubUrl.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.code_rounded, color: Colors.white70, size: 20),
                          onPressed: () => UrlHelper.openLink(config.githubUrl, context: context),
                          tooltip: 'GitHub',
                        ),
                      if (config.linkedinUrl.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.business_rounded, color: Colors.white70, size: 20),
                          onPressed: () => UrlHelper.openLink(config.linkedinUrl, context: context),
                          tooltip: 'LinkedIn',
                        ),
                      IconButton(
                        icon: const Icon(Icons.share_rounded, color: Colors.white70, size: 20),
                        onPressed: () => UrlHelper.sharePortfolio(context: context),
                        tooltip: 'Share',
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

  Widget _buildBrandColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'MM',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
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
