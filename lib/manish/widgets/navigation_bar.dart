import 'package:flutter/material.dart';
import '../models/profile_config_model.dart';
import '../theme/app_colors.dart';
import '../utils/url_helper.dart';

class PortfolioNavBar extends StatelessWidget {
  final bool isDark;
  final ProfileConfigModel config;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenCms;
  final Function(String sectionKey) onNavigate;

  const PortfolioNavBar({
    super.key,
    required this.isDark,
    required this.config,
    required this.onToggleTheme,
    required this.onOpenCms,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 860;

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
          InkWell(
            onTap: () => onNavigate('home'),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'MM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      config.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      config.locationShort,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Desktop Nav links
          if (isDesktop) ...[
            _navItem('Home', 'home'),
            _navItem('About', 'about'),
            _navItem('Services', 'services'),
            _navItem('Projects', 'projects'),
            _navItem('Contact', 'contact'),
            const SizedBox(width: 12),
          ],

          // Quick Action: WhatsApp Button
          ElevatedButton.icon(
            onPressed: () => UrlHelper.openWhatsApp(
              phone: config.whatsappNumber,
              message: config.whatsappDefaultMessage,
              context: context,
            ),
            icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Colors.white),
            label: Text(
              isDesktop ? 'WhatsApp' : '',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.whatsappGreen,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 14 : 10, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
            ),
          ),

          const SizedBox(width: 8),

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

          // Mobile Menu Icon
          if (!isDesktop)
            IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                _showMobileNavDrawer(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _navItem(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextButton(
        onPressed: () => onNavigate(key),
        style: TextButton.styleFrom(
          foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  void _showMobileNavDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              _mobileDrawerItem(ctx, 'Home', 'home', Icons.home_rounded),
              _mobileDrawerItem(ctx, 'About Me', 'about', Icons.person_rounded),
              _mobileDrawerItem(ctx, 'My Services', 'services', Icons.miscellaneous_services_rounded),
              _mobileDrawerItem(ctx, 'My Projects', 'projects', Icons.rocket_launch_rounded),
              _mobileDrawerItem(ctx, 'Contact & Location', 'contact', Icons.location_on_rounded),
              const Divider(height: 24),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
                  title: Text('Admin Panel (Edit Everything)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  onTap: () {
                    Navigator.pop(ctx);
                    onOpenCms();
                  },
                ),
              ),
              const Divider(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        UrlHelper.openWhatsApp(
                          phone: config.whatsappNumber,
                          message: config.whatsappDefaultMessage,
                          context: context,
                        );
                      },
                      icon: const Icon(Icons.chat_rounded, color: Colors.white),
                      label: const Text('WhatsApp Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.whatsappGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        UrlHelper.makePhoneCall(phone: config.phone, context: context);
                      },
                      icon: const Icon(Icons.call_rounded, color: Colors.white),
                      label: const Text('Call Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.callBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileDrawerItem(BuildContext ctx, String label, String key, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        onTap: () {
          Navigator.pop(ctx);
          onNavigate(key);
        },
      ),
    );
  }
}
