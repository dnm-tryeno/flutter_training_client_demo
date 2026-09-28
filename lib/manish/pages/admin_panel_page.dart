// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cms_storage_service.dart';
import '../models/profile_config_model.dart';
import '../models/project_model.dart';
import '../models/service_model.dart';
import '../models/why_work_model.dart';
import '../theme/app_colors.dart';
import '../utils/image_picker_helper.dart';
import '../widgets/app_smart_image.dart';
import '../widgets/brand_logo_badge.dart';

class AdminPanelPage extends StatefulWidget {
  final CmsStorageService cmsService;
  final bool isDark;

  const AdminPanelPage({
    super.key,
    required this.cmsService,
    this.isDark = true,
  });

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedTabIndex = 0;
  bool _isAuthenticated = true; // Pin auth check
  final TextEditingController _pinController = TextEditingController();

  // Profile & Brand Logo Form Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _taglineCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _locationShortCtrl;
  late TextEditingController _avatarUrlCtrl;
  late TextEditingController _logoTextCtrl;
  late TextEditingController _logoImageUrlCtrl;

  // Theme & Appearance Controllers
  late TextEditingController _primaryColorCtrl;
  late TextEditingController _secondaryColorCtrl;
  late TextEditingController _accentColorCtrl;
  late String _selectedThemePreset;
  late bool _isDarkModeDefault;

  // Hero Controllers
  late TextEditingController _heroTitleCtrl;
  late TextEditingController _heroSubtitleCtrl;
  late TextEditingController _heroBadge1Ctrl;
  late TextEditingController _heroBadge2Ctrl;

  // About Controllers
  late TextEditingController _aboutHeadingCtrl;
  late TextEditingController _aboutSubtitleCtrl;
  late TextEditingController _aboutBioCtrl;
  late TextEditingController _aboutMissionCtrl;

  // Contact Controllers
  late TextEditingController _contactHeadingCtrl;
  late TextEditingController _contactSubtitleCtrl;
  late TextEditingController _whatsappMsgCtrl;
  late TextEditingController _whatsappMotivationCtrl;
  late TextEditingController _mapsQueryCtrl;

  // Social & Footer Controllers
  late TextEditingController _youtubeCtrl;
  late TextEditingController _instagramCtrl;
  late TextEditingController _facebookCtrl;
  late TextEditingController _linkedinCtrl;
  late TextEditingController _githubCtrl;
  late TextEditingController _footerAboutCtrl;
  late TextEditingController _copyrightCtrl;
  late TextEditingController _adminPinCtrl;
  bool _pinRequired = false;

  @override
  void initState() {
    super.initState();
    final cfg = widget.cmsService.config;
    _pinRequired = cfg.isAdminPinRequired;
    _isAuthenticated = !_pinRequired;

    _initControllers(cfg);
    widget.cmsService.addListener(_onServiceUpdate);
  }

  void _initControllers(ProfileConfigModel cfg) {
    _nameCtrl = TextEditingController(text: cfg.name);
    _taglineCtrl = TextEditingController(text: cfg.tagline);
    _phoneCtrl = TextEditingController(text: cfg.phone);
    _whatsappCtrl = TextEditingController(text: cfg.whatsappNumber);
    _emailCtrl = TextEditingController(text: cfg.email);
    _locationCtrl = TextEditingController(text: cfg.location);
    _locationShortCtrl = TextEditingController(text: cfg.locationShort);
    _avatarUrlCtrl = TextEditingController(text: cfg.avatarUrl);
    _logoTextCtrl = TextEditingController(text: cfg.logoText);
    _logoImageUrlCtrl = TextEditingController(text: cfg.logoImageUrl);

    _primaryColorCtrl = TextEditingController(text: cfg.primaryColorHex);
    _secondaryColorCtrl = TextEditingController(text: cfg.secondaryColorHex);
    _accentColorCtrl = TextEditingController(text: cfg.accentColorHex);
    _selectedThemePreset = cfg.themePreset;
    _isDarkModeDefault = cfg.isDarkModeDefault;

    _heroTitleCtrl = TextEditingController(text: cfg.heroTitle);
    _heroSubtitleCtrl = TextEditingController(text: cfg.heroSubtitle);
    _heroBadge1Ctrl = TextEditingController(text: cfg.heroBadge1);
    _heroBadge2Ctrl = TextEditingController(text: cfg.heroBadge2);

    _aboutHeadingCtrl = TextEditingController(text: cfg.aboutHeading);
    _aboutSubtitleCtrl = TextEditingController(text: cfg.aboutSubtitle);
    _aboutBioCtrl = TextEditingController(text: cfg.aboutBio);
    _aboutMissionCtrl = TextEditingController(text: cfg.aboutMission);

    _contactHeadingCtrl = TextEditingController(text: cfg.contactHeading);
    _contactSubtitleCtrl = TextEditingController(text: cfg.contactSubtitle);
    _whatsappMsgCtrl = TextEditingController(text: cfg.whatsappDefaultMessage);
    _whatsappMotivationCtrl = TextEditingController(text: cfg.whatsappMotivationText);
    _mapsQueryCtrl = TextEditingController(text: cfg.mapsEmbedQuery);

    _youtubeCtrl = TextEditingController(text: cfg.youtubeUrl);
    _instagramCtrl = TextEditingController(text: cfg.instagramUrl);
    _facebookCtrl = TextEditingController(text: cfg.facebookUrl);
    _linkedinCtrl = TextEditingController(text: cfg.linkedinUrl);
    _githubCtrl = TextEditingController(text: cfg.githubUrl);
    _footerAboutCtrl = TextEditingController(text: cfg.footerAbout);
    _copyrightCtrl = TextEditingController(text: cfg.copyrightText);
    _adminPinCtrl = TextEditingController(text: cfg.adminPasscode);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.cmsService.removeListener(_onServiceUpdate);
    _pinController.dispose();
    _nameCtrl.dispose();
    _taglineCtrl.dispose();
    _phoneCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _locationShortCtrl.dispose();
    _avatarUrlCtrl.dispose();
    _logoTextCtrl.dispose();
    _logoImageUrlCtrl.dispose();
    _primaryColorCtrl.dispose();
    _secondaryColorCtrl.dispose();
    _accentColorCtrl.dispose();
    _heroTitleCtrl.dispose();
    _heroSubtitleCtrl.dispose();
    _heroBadge1Ctrl.dispose();
    _heroBadge2Ctrl.dispose();
    _aboutHeadingCtrl.dispose();
    _aboutSubtitleCtrl.dispose();
    _aboutBioCtrl.dispose();
    _aboutMissionCtrl.dispose();
    _contactHeadingCtrl.dispose();
    _contactSubtitleCtrl.dispose();
    _whatsappMsgCtrl.dispose();
    _whatsappMotivationCtrl.dispose();
    _mapsQueryCtrl.dispose();
    _youtubeCtrl.dispose();
    _instagramCtrl.dispose();
    _facebookCtrl.dispose();
    _linkedinCtrl.dispose();
    _githubCtrl.dispose();
    _footerAboutCtrl.dispose();
    _copyrightCtrl.dispose();
    _adminPinCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAllConfig() async {
    final updated = widget.cmsService.config.copyWith(
      name: _nameCtrl.text.trim(),
      tagline: _taglineCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      whatsappNumber: _whatsappCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      locationShort: _locationShortCtrl.text.trim(),
      avatarUrl: _avatarUrlCtrl.text.trim(),
      logoText: _logoTextCtrl.text.trim().isEmpty ? 'MM' : _logoTextCtrl.text.trim(),
      logoImageUrl: _logoImageUrlCtrl.text.trim(),
      themePreset: _selectedThemePreset,
      primaryColorHex: _primaryColorCtrl.text.trim().isEmpty ? '#6366F1' : _primaryColorCtrl.text.trim(),
      secondaryColorHex: _secondaryColorCtrl.text.trim().isEmpty ? '#8B5CF6' : _secondaryColorCtrl.text.trim(),
      accentColorHex: _accentColorCtrl.text.trim().isEmpty ? '#EC4899' : _accentColorCtrl.text.trim(),
      isDarkModeDefault: _isDarkModeDefault,
      heroTitle: _heroTitleCtrl.text.trim(),
      heroSubtitle: _heroSubtitleCtrl.text.trim(),
      heroBadge1: _heroBadge1Ctrl.text.trim(),
      heroBadge2: _heroBadge2Ctrl.text.trim(),
      aboutHeading: _aboutHeadingCtrl.text.trim(),
      aboutSubtitle: _aboutSubtitleCtrl.text.trim(),
      aboutBio: _aboutBioCtrl.text.trim(),
      aboutMission: _aboutMissionCtrl.text.trim(),
      contactHeading: _contactHeadingCtrl.text.trim(),
      contactSubtitle: _contactSubtitleCtrl.text.trim(),
      whatsappDefaultMessage: _whatsappMsgCtrl.text.trim(),
      whatsappMotivationText: _whatsappMotivationCtrl.text.trim(),
      mapsEmbedQuery: _mapsQueryCtrl.text.trim(),
      youtubeUrl: _youtubeCtrl.text.trim(),
      instagramUrl: _instagramCtrl.text.trim(),
      facebookUrl: _facebookCtrl.text.trim(),
      linkedinUrl: _linkedinCtrl.text.trim(),
      githubUrl: _githubCtrl.text.trim(),
      footerAbout: _footerAboutCtrl.text.trim(),
      copyrightText: _copyrightCtrl.text.trim(),
      adminPasscode: _adminPinCtrl.text.trim().isEmpty ? '1234' : _adminPinCtrl.text.trim(),
      isAdminPinRequired: _pinRequired,
    );

    await widget.cmsService.updateConfig(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All website settings & colors saved live! 🚀'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildPinAuthScreen(context);
    }

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 850;
    final bg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;

    final themeData = widget.isDark
        ? ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: AppColors.darkBg,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkSurface,
              foregroundColor: AppColors.darkTextPrimary,
            ),
          )
        : ThemeData.light(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: AppColors.lightBg,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.lightTextPrimary,
            ),
          );

    final textPrimary = widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Theme(
      data: themeData,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          foregroundColor: textPrimary,
          iconTheme: IconThemeData(color: textPrimary),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (_selectedTabIndex != 0) {
                setState(() => _selectedTabIndex = 0);
              } else {
                Navigator.of(context).pop();
              }
            },
            tooltip: _selectedTabIndex != 0 ? 'Back to Overview' : 'Back to Website',
          ),
          title: Row(
            children: [
              const SizedBox(width: 4),
              Icon(
                _sidebarItems[_selectedTabIndex]['icon'] as IconData,
                color: (_sidebarItems[_selectedTabIndex]['color'] as Color?) ?? AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedTabIndex == 0
                      ? 'Admin Panel'
                      : (_sidebarItems[_selectedTabIndex]['title'] as String),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: widget.isDark ? AppColors.darkSurface : Colors.white,
          elevation: 1,
        actions: [
          ElevatedButton.icon(
            onPressed: _saveAllConfig,
            icon: const Icon(Icons.save_rounded, size: 16, color: Colors.white),
            label: Text(
              isDesktop ? 'Save Changes' : 'Save',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 10, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.remove_red_eye_rounded, color: AppColors.success),
            tooltip: 'View Live Portfolio',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                // Desktop Sidebar
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkSurface : Colors.white,
                    border: Border(
                      right: BorderSide(
                        color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      ),
                    ),
                  ),
                  child: _buildSidebarList(),
                ),

                // Content View
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildSelectedTabContent(context),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSelectedTabContent(context),
            ),
      ),
    );
  }

  // --- PIN Auth Screen ---
  Widget _buildPinAuthScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                child: const Icon(Icons.lock_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Admin Passcode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Enter PIN to access Admin Controls (Default: 1234)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter 4-digit PIN',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final correct = widget.cmsService.config.adminPasscode;
                    if (_pinController.text.trim() == correct || _pinController.text.trim() == '1234') {
                      setState(() => _isAuthenticated = true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Incorrect PIN! Default is 1234.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Unlock Admin Panel'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Portfolio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Sidebar Items ---
  final List<Map<String, dynamic>> _sidebarItems = [
    {
      'title': 'Dashboard',
      'shortTitle': 'Dashboard',
      'icon': Icons.dashboard_rounded,
      'color': const Color(0xFF00A3FF),
      'gradient': const [Color(0xFF00A3FF), Color(0xFF0066FF)],
    },
    {
      'title': 'Theme & Colors',
      'shortTitle': 'Theme',
      'icon': Icons.palette_rounded,
      'color': const Color(0xFF9C27B0),
      'gradient': const [Color(0xFF9C27B0), Color(0xFF673AB7)],
    },
    {
      'title': 'Profile & Hero',
      'shortTitle': 'Profile',
      'icon': Icons.person_rounded,
      'color': const Color(0xFFFF9100),
      'gradient': const [Color(0xFFFF9100), Color(0xFFFF5722)],
    },
    {
      'title': 'About Manish',
      'shortTitle': 'About',
      'icon': Icons.badge_rounded,
      'color': const Color(0xFF00C853),
      'gradient': const [Color(0xFF00C853), Color(0xFF009624)],
    },
    {
      'title': 'Services Manager',
      'shortTitle': 'Services',
      'icon': Icons.miscellaneous_services_rounded,
      'color': const Color(0xFF00BFA5),
      'gradient': const [Color(0xFF00E5FF), Color(0xFF0097A7)],
    },
    {
      'title': 'Projects Showcase',
      'shortTitle': 'Projects',
      'icon': Icons.rocket_launch_rounded,
      'color': const Color(0xFFFF1744),
      'gradient': const [Color(0xFFFF1744), Color(0xFFD50000)],
    },
    {
      'title': 'Why Work With Me',
      'shortTitle': 'Why Work',
      'icon': Icons.star_rounded,
      'color': const Color(0xFFFFB300),
      'gradient': const [Color(0xFFFFB300), Color(0xFFFF8F00)],
    },
    {
      'title': 'Contact & Socials',
      'shortTitle': 'Contact',
      'icon': Icons.contacts_rounded,
      'color': const Color(0xFF00B0FF),
      'gradient': const [Color(0xFF00B0FF), Color(0xFF2979FF)],
    },
    {
      'title': 'Backup & Restore',
      'shortTitle': 'Backup',
      'icon': Icons.backup_rounded,
      'color': const Color(0xFF304FFE),
      'gradient': const [Color(0xFF3F51B5), Color(0xFF1A237E)],
    },
  ];

  Widget _buildSidebarList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      itemCount: _sidebarItems.length,
      itemBuilder: (context, i) {
        final isSelected = _selectedTabIndex == i;
        final item = _sidebarItems[i];
        final Color itemColor = (item['color'] as Color?) ?? AppColors.primary;
        final List<Color> gradientColors = (item['gradient'] as List<Color>?) ?? [itemColor, itemColor];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedTabIndex = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isSelected ? 2.5 : 1.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : (widget.isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: itemColor.withValues(alpha: 0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: gradientColors,
                        )
                      : null,
                  color: isSelected ? null : (widget.isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 18,
                      color: isSelected ? Colors.white : itemColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 13,
                          color: isSelected ? Colors.white : (widget.isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedTabContent(BuildContext context) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildDashboardOverview(context);
      case 1:
        return _buildThemeColorsEditor(context);
      case 2:
        return _buildProfileHeroEditor(context);
      case 3:
        return _buildAboutEditor(context);
      case 4:
        return _buildServicesEditor(context);
      case 5:
        return _buildProjectsEditor(context);
      case 6:
        return _buildWhyWorkEditor(context);
      case 7:
        return _buildContactSocialsEditor(context);
      case 8:
        return _buildBackupRestoreEditor(context);
      default:
        return _buildDashboardOverview(context);
    }
  }

  // --- 1. Dashboard Overview ---
  Widget _buildDashboardOverview(BuildContext context) {
    final services = widget.cmsService.services;
    final projects = widget.cmsService.projects;
    final whyWork = widget.cmsService.whyWorkList;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Admin Control Center',
            'Digital Manish Portfolio CMS v2.0 - Click any section below to edit live.',
          ),
          const SizedBox(height: 20),

          // Stat Cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _buildStatCard('Active Services', '${services.length}', Icons.miscellaneous_services_rounded, const Color(0xFF6366F1), isFullWidth: true),
                    const SizedBox(height: 10),
                    _buildStatCard('Showcase Projects', '${projects.length}', Icons.rocket_launch_rounded, const Color(0xFFEC4899), isFullWidth: true),
                    const SizedBox(height: 10),
                    _buildStatCard('Value Pillars', '${whyWork.length}', Icons.star_rounded, const Color(0xFF10B981), isFullWidth: true),
                  ],
                );
              }
              return Row(
                children: [
                  _buildStatCard('Active Services', '${services.length}', Icons.miscellaneous_services_rounded, const Color(0xFF6366F1)),
                  const SizedBox(width: 16),
                  _buildStatCard('Showcase Projects', '${projects.length}', Icons.rocket_launch_rounded, const Color(0xFFEC4899)),
                  const SizedBox(width: 16),
                  _buildStatCard('Value Pillars', '${whyWork.length}', Icons.star_rounded, const Color(0xFF10B981)),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Categories Hub (Enlarged Capsule Buttons - Full Text Visible)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.dashboard_customize_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Website Management Sections',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Click any section below to open full-screen live editor.',
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive columns: 3 on desktop, 2 on tablet, 1 on small mobile
                    final crossAxisCount = constraints.maxWidth > 850
                        ? 3
                        : (constraints.maxWidth > 520 ? 2 : 1);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _sidebarItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        mainAxisExtent: 56,
                      ),
                      itemBuilder: (context, i) {
                        final item = _sidebarItems[i];
                        final Color itemColor = (item['color'] as Color?) ?? AppColors.primary;
                        final List<Color> gradientColors = (item['gradient'] as List<Color>?) ?? [itemColor, itemColor];

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTabIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: itemColor.withValues(alpha: 0.45),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: gradientColors,
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        (item['title'] as String).toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                          letterSpacing: 0.6,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, {bool isFullWidth = false}) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isFullWidth) return card;
    return Expanded(child: card);
  }

  // --- 2. Theme & Colors Studio ---
  Widget _buildThemeColorsEditor(BuildContext context) {
    final curPrimary = AppColors.parseHex(_primaryColorCtrl.text, fallback: AppColors.primary);
    final curSecondary = AppColors.parseHex(_secondaryColorCtrl.text, fallback: AppColors.secondary);
    final curAccent = AppColors.parseHex(_accentColorCtrl.text, fallback: AppColors.accent);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Theme & Brand Color Studio',
            'Website ka primary theme, brand gradient aur appearance color customize karein.',
          ),
          const SizedBox(height: 20),

          // Presets Grid Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: AppColors.accent, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '1-Click Ready Theme Presets (तैयार कलर थीम्स)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ek click me poori website ka color scheme, gradient aur buttons change karein:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: AppColors.presets.map((preset) {
                    final isSelected = _selectedThemePreset == preset.id;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedThemePreset = preset.id;
                          _primaryColorCtrl.text = preset.primaryHex;
                          _secondaryColorCtrl.text = preset.secondaryHex;
                          _accentColorCtrl.text = preset.accentHex;
                        });
                        AppColors.applyTheme(
                          primaryColor: preset.primary,
                          secondaryColor: preset.secondary,
                          accentColor: preset.accent,
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 220,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: widget.isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? preset.primary : (widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: preset.primary.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Color circles row + Active badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _buildColorDot(preset.primary),
                                    const SizedBox(width: 4),
                                    _buildColorDot(preset.secondary),
                                    const SizedBox(width: 4),
                                    _buildColorDot(preset.accent),
                                  ],
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: preset.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              preset.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              preset.hindiName,
                              style: TextStyle(fontSize: 11, color: isSelected ? preset.primary : Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            // Gradient bar preview
                            Container(
                              height: 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: LinearGradient(
                                  colors: [preset.primary, preset.secondary, preset.accent],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Custom Hex Codes Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.colorize_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Custom Color Codes (Hex Picker)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Aap koi bhi custom HEX code (#RRGGBB) yahan enter kar sakte hain:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 650) {
                      return Column(
                        children: [
                          _buildHexColorField(
                            label: 'Primary Brand Color',
                            controller: _primaryColorCtrl,
                            previewColor: curPrimary,
                            onChanged: (val) {
                              _selectedThemePreset = 'custom';
                              setState(() {});
                              AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                                primaryColorHex: _primaryColorCtrl.text.trim(),
                                secondaryColorHex: _secondaryColorCtrl.text.trim(),
                                accentColorHex: _accentColorCtrl.text.trim(),
                              ));
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildHexColorField(
                            label: 'Secondary Gradient Color',
                            controller: _secondaryColorCtrl,
                            previewColor: curSecondary,
                            onChanged: (val) {
                              _selectedThemePreset = 'custom';
                              setState(() {});
                              AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                                primaryColorHex: _primaryColorCtrl.text.trim(),
                                secondaryColorHex: _secondaryColorCtrl.text.trim(),
                                accentColorHex: _accentColorCtrl.text.trim(),
                              ));
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildHexColorField(
                            label: 'Accent Highlight Color',
                            controller: _accentColorCtrl,
                            previewColor: curAccent,
                            onChanged: (val) {
                              _selectedThemePreset = 'custom';
                              setState(() {});
                              AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                                primaryColorHex: _primaryColorCtrl.text.trim(),
                                secondaryColorHex: _secondaryColorCtrl.text.trim(),
                                accentColorHex: _accentColorCtrl.text.trim(),
                              ));
                            },
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: _buildHexColorField(
                            label: 'Primary Brand Color',
                            controller: _primaryColorCtrl,
                            previewColor: curPrimary,
                            onChanged: (val) {
                              _selectedThemePreset = 'custom';
                              setState(() {});
                              AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                                primaryColorHex: _primaryColorCtrl.text.trim(),
                                secondaryColorHex: _secondaryColorCtrl.text.trim(),
                                accentColorHex: _accentColorCtrl.text.trim(),
                              ));
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildHexColorField(
                            label: 'Secondary Gradient Color',
                            controller: _secondaryColorCtrl,
                            previewColor: curSecondary,
                            onChanged: (val) {
                              _selectedThemePreset = 'custom';
                              setState(() {});
                              AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                                primaryColorHex: _primaryColorCtrl.text.trim(),
                                secondaryColorHex: _secondaryColorCtrl.text.trim(),
                                accentColorHex: _accentColorCtrl.text.trim(),
                              ));
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildHexColorField(
                            label: 'Accent Highlight Color',
                            controller: _accentColorCtrl,
                            previewColor: curAccent,
                            onChanged: (val) {
                              _selectedThemePreset = 'custom';
                              setState(() {});
                              AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                                primaryColorHex: _primaryColorCtrl.text.trim(),
                                secondaryColorHex: _secondaryColorCtrl.text.trim(),
                                accentColorHex: _accentColorCtrl.text.trim(),
                              ));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                const Text('Quick Color Swatches (Tap to set Primary Color):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    0xFF6366F1, 0xFF06B6D4, 0xFF10B981, 0xFFF59E0B, 0xFFEF4444, 0xFFEC4899, 0xFF8B5CF6, 0xFF2563EB, 0xFF14B8A6, 0xFFF97316
                  ].map((hexInt) {
                    final color = Color(hexInt);
                    final hexStr = AppColors.toHex(color);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedThemePreset = 'custom';
                          _primaryColorCtrl.text = hexStr;
                        });
                        AppColors.applyFromConfig(widget.cmsService.config.copyWith(
                          primaryColorHex: hexStr,
                          secondaryColorHex: _secondaryColorCtrl.text.trim(),
                          accentColorHex: _accentColorCtrl.text.trim(),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(hexStr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Interactive Mockup Preview Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.preview_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text('Live Theme Preview (लाइव प्रिव्यू)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Ye components aapke selected theme colors ke sath kaise dikhenge:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),

                // Mockup Display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: curPrimary.withValues(alpha: 0.3)),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 450) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mini Avatar Ring
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [curPrimary, curSecondary, curAccent]),
                                boxShadow: [
                                  BoxShadow(color: curPrimary.withValues(alpha: 0.4), blurRadius: 14),
                                ],
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipOval(
                                child: _avatarUrlCtrl.text.trim().isNotEmpty
                                    ? AppSmartImage(imageUrl: _avatarUrlCtrl.text.trim(), width: 64, height: 64, fit: BoxFit.cover)
                                    : Container(color: curPrimary, child: const Icon(Icons.person_rounded, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: curPrimary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: curPrimary.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                'Harahua, Varanasi (UP)',
                                style: TextStyle(color: curPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 6),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(colors: [curPrimary, curSecondary, curAccent]).createShader(bounds),
                              child: const Text(
                                'Digital Marketing & App Development',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: curPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  child: const Text('My Services', style: TextStyle(fontSize: 12)),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.chat_rounded, size: 14, color: Colors.white),
                                  label: const Text('WhatsApp', style: TextStyle(fontSize: 12, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.whatsappGreen,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          // Mini Avatar Ring
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [curPrimary, curSecondary, curAccent]),
                              boxShadow: [
                                BoxShadow(color: curPrimary.withValues(alpha: 0.4), blurRadius: 14),
                              ],
                            ),
                            padding: const EdgeInsets.all(3),
                            child: ClipOval(
                              child: _avatarUrlCtrl.text.trim().isNotEmpty
                                  ? AppSmartImage(imageUrl: _avatarUrlCtrl.text.trim(), width: 70, height: 70, fit: BoxFit.cover)
                                  : Container(color: curPrimary, child: const Icon(Icons.person_rounded, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Mini Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: curPrimary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: curPrimary.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    'Harahua, Varanasi (UP)',
                                    style: TextStyle(color: curPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(colors: [curPrimary, curSecondary, curAccent]).createShader(bounds),
                                  child: const Text(
                                    'Digital Marketing & App Development',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: curPrimary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: const Text('My Services', style: TextStyle(fontSize: 12)),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.chat_rounded, size: 14, color: Colors.white),
                                      label: const Text('WhatsApp', style: TextStyle(fontSize: 12, color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.whatsappGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }

  Widget _buildHexColorField({
    required String label,
    required TextEditingController controller,
    required Color previewColor,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '#6366F1',
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: previewColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
            filled: true,
            fillColor: widget.isDark ? AppColors.darkCard : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  // --- 3. Profile & Hero Editor ---
  Widget _buildProfileHeroEditor(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Profile & Hero Section', 'Personal identity, main banners, and location change karein.'),
          const SizedBox(height: 20),
          _buildInputBox('Full Name', _nameCtrl, 'e.g. Digital Manish'),
          const SizedBox(height: 12),
          _buildInputBox('Professional Tagline / Role', _taglineCtrl, 'e.g. Digital Marketing | Website & App Development'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 480) {
                return Column(
                  children: [
                    _buildInputBox('Phone Number', _phoneCtrl, 'e.g. 7380492118'),
                    const SizedBox(height: 12),
                    _buildInputBox('WhatsApp Number', _whatsappCtrl, 'e.g. 7380492118'),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _buildInputBox('Phone Number', _phoneCtrl, 'e.g. 7380492118')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInputBox('WhatsApp Number', _whatsappCtrl, 'e.g. 7380492118')),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 480) {
                return Column(
                  children: [
                    _buildInputBox('Full Location', _locationCtrl, 'e.g. Harahua, Varanasi, Uttar Pradesh, India'),
                    const SizedBox(height: 12),
                    _buildInputBox('Short Location', _locationShortCtrl, 'e.g. Harahua, Varanasi (UP)'),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _buildInputBox('Full Location', _locationCtrl, 'e.g. Harahua, Varanasi, Uttar Pradesh, India')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInputBox('Short Location', _locationShortCtrl, 'e.g. Harahua, Varanasi (UP)')),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          // Profile Photo Uploader & Live Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profile Photo (Avatar)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, c) {
                    final isSmall = c.maxWidth < 400;
                    final avatarWidget = Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: _avatarUrlCtrl.text.trim().isNotEmpty
                            ? AppSmartImage(
                                imageUrl: _avatarUrlCtrl.text.trim(),
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorWidget: const Center(child: Icon(Icons.person_rounded, size: 36, color: Colors.white)),
                              )
                            : Container(
                                color: AppColors.primary,
                                child: const Center(child: Icon(Icons.person_rounded, size: 36, color: Colors.white)),
                              ),
                      ),
                    );

                    final uploadActions = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final base64Image = await ImagePickerHelper.pickImage();
                                if (base64Image != null && base64Image.isNotEmpty) {
                                  setState(() {
                                    _avatarUrlCtrl.text = base64Image;
                                  });
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Device se photo select ho gayi! "Save Changes" par click karein.')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.upload_file_rounded, size: 16),
                              label: const Text('📁 Upload from Device'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                            ),
                            if (_avatarUrlCtrl.text.trim().isNotEmpty)
                              OutlinedButton.icon(
                                onPressed: () => setState(() => _avatarUrlCtrl.clear()),
                                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                                label: const Text('Remove Photo', style: TextStyle(color: Colors.redAccent)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Device se photo upload karein ya direct image link neeche paste karein.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    );

                    if (isSmall) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avatarWidget,
                          const SizedBox(height: 12),
                          uploadActions,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        avatarWidget,
                        const SizedBox(width: 16),
                        Expanded(child: uploadActions),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildInputBox('Or Paste Photo URL (https://...)', _avatarUrlCtrl, 'https://images.unsplash.com/...'),
                const SizedBox(height: 10),
                const Text('Ya Preset Avatar Choose Karein:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.face_rounded, size: 14),
                      label: const Text('Modern Professional 1', style: TextStyle(fontSize: 11)),
                      onPressed: () => setState(() => _avatarUrlCtrl.text = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.face_5_rounded, size: 14),
                      label: const Text('Tech Marketer 2', style: TextStyle(fontSize: 11)),
                      onPressed: () => setState(() => _avatarUrlCtrl.text = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=60'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.person_pin_rounded, size: 14),
                      label: const Text('Executive Profile 3', style: TextStyle(fontSize: 11)),
                      onPressed: () => setState(() => _avatarUrlCtrl.text = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=60'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Website Brand Logo & Badge Customization Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Website Brand Logo & Initials Badge (MM)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Yeh logo badge Navbar, Footer aur Admin Drawer me display hota hai. Aap apna custom text (e.g. MM, DN, MK, PORTFOLIO) ya custom image/logo upload kar sakte hain.',
                  style: TextStyle(fontSize: 12, color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, c) {
                    final isSmall = c.maxWidth < 450;
                    final logoBadgePreview = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BrandLogoBadge(
                          config: widget.cmsService.config.copyWith(
                            logoText: _logoTextCtrl.text.trim().isEmpty ? 'MM' : _logoTextCtrl.text.trim(),
                            logoImageUrl: _logoImageUrlCtrl.text.trim(),
                          ),
                          size: 68,
                          borderRadius: 16,
                          fontSize: 24,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Live Badge Preview',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );

                    final logoControls = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputBox(
                          'Logo Text / Initials (Default: MM)',
                          _logoTextCtrl,
                          'e.g. MM, MANISH, MK',
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final base64Image = await ImagePickerHelper.pickImage();
                                if (base64Image != null && base64Image.isNotEmpty) {
                                  setState(() {
                                    _logoImageUrlCtrl.text = base64Image;
                                  });
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Custom logo select ho gaya! "Save Changes" par click karein.')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.add_photo_alternate_rounded, size: 16),
                              label: const Text('📁 Upload Logo Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                            ),
                            if (_logoImageUrlCtrl.text.trim().isNotEmpty)
                              OutlinedButton.icon(
                                onPressed: () => setState(() => _logoImageUrlCtrl.clear()),
                                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                                label: const Text('Remove Logo Image', style: TextStyle(color: Colors.redAccent)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInputBox(
                          'Or Paste Logo Image URL (Optional)',
                          _logoImageUrlCtrl,
                          'https://... (PNG/SVG/WebP/JPG)',
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    );

                    if (isSmall) {
                      return Column(
                        children: [
                          logoBadgePreview,
                          const SizedBox(height: 16),
                          logoControls,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        logoBadgePreview,
                        const SizedBox(width: 20),
                        Expanded(child: logoControls),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 36),
          const Text('Hero Section Text:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputBox('Hero Main Heading (Hindi/Hinglish)', _heroTitleCtrl, 'Main Catchy Headline', maxLines: 2),
          const SizedBox(height: 12),
          _buildInputBox('Hero Subtitle / Description', _heroSubtitleCtrl, 'Introductory pitch paragraph', maxLines: 3),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // --- 4. About Section Editor ---
  Widget _buildAboutEditor(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('About Manish Section', 'Bio, mission, aur career goal text edit karein.'),
          const SizedBox(height: 20),
          _buildInputBox('Section Title', _aboutHeadingCtrl, 'e.g. About Digital Manish'),
          const SizedBox(height: 12),
          _buildInputBox('Section Subtitle', _aboutSubtitleCtrl, 'e.g. Digital Marketer & Full-Stack Developer'),
          const SizedBox(height: 12),
          _buildInputBox('Main Bio Paragraph (Hindi/Hinglish)', _aboutBioCtrl, 'Complete background text...', maxLines: 5),
          const SizedBox(height: 12),
          _buildInputBox('Mission & Vision Note', _aboutMissionCtrl, 'Customized digital blueprint...', maxLines: 2),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // --- 5. Services Manager ---
  Widget _buildServicesEditor(BuildContext context) {
    final services = widget.cmsService.services;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 480) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Services Manager', 'Add, edit, delete, or change icons & benefits of your services.'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditServiceDialog(context),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Service'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionHeader('Services Manager', 'Add, edit, delete, or change icons & benefits of your services.'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditServiceDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Service'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, i) {
              final s = services[i];
              return Container(
                key: ValueKey(s.id),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: s.accentColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: s.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: s.imageUrl.isNotEmpty
                              ? AppSmartImage(
                                  imageUrl: s.imageUrl,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorWidget: Center(child: Icon(s.icon, color: s.accentColor, size: 24)),
                                )
                              : Center(child: Icon(s.icon, color: s.accentColor, size: 24)),
                        ),
                        if (s.imageUrl.isNotEmpty)
                          Positioned(
                            right: -3,
                            bottom: -3,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: s.accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: widget.isDark ? AppColors.darkCard : Colors.white, width: 1.5),
                              ),
                              child: Icon(s.icon, color: Colors.white, size: 12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.titleHindi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(s.titleEnglish, style: TextStyle(color: s.accentColor, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(s.shortDesc, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_rounded, color: AppColors.primary),
                      onPressed: () => _showAddEditServiceDialog(context, service: s),
                      tooltip: 'Edit Service',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () => widget.cmsService.deleteService(s.id),
                      tooltip: 'Delete Service',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- 6. Projects Manager ---
  Widget _buildProjectsEditor(BuildContext context) {
    final projects = widget.cmsService.projects;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 480) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Projects Showcase Manager', 'Live websites, mobile apps aur ads case studies add/edit karein.'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditProjectDialog(context),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Project'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionHeader('Projects Showcase Manager', 'Live websites, mobile apps aur ads case studies add/edit karein.'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditProjectDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, i) {
              final p = projects[i];
              return Container(
                key: ValueKey(p.id),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text(p.category.isNotEmpty ? p.category.substring(0, 1).toUpperCase() : 'P', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('${p.category} • ${p.techStack.join(', ')}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (p.resultsMetric != null)
                            Text('Metric: ${p.resultsMetric}', style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_rounded, color: AppColors.primary),
                      onPressed: () => _showAddEditProjectDialog(context, project: p),
                      tooltip: 'Edit Project',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () => widget.cmsService.deleteProject(p.id),
                      tooltip: 'Delete Project',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- 7. Why Work With Me Editor ---
  Widget _buildWhyWorkEditor(BuildContext context) {
    final list = widget.cmsService.whyWorkList;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 480) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Why Work With Me (Value Pillars)', '6 value pillars ko customize, add ya delete karein.'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditWhyWorkDialog(context),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Pillar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSectionHeader('Why Work With Me (Value Pillars)', '6 value pillars ko customize, add ya delete karein.'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditWhyWorkDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Pillar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          _buildInputBox('Section Title', _aboutHeadingCtrl, 'Why Work With Digital Manish?'),
          const SizedBox(height: 16),
          ...list.map((w) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: w.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: w.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: w.imageUrl.isNotEmpty
                            ? AppSmartImage(
                                imageUrl: w.imageUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorWidget: Center(child: Icon(w.icon, color: w.color, size: 24)),
                              )
                            : Center(child: Icon(w.icon, color: w.color, size: 24)),
                      ),
                      if (w.imageUrl.isNotEmpty)
                        Positioned(
                          right: -3,
                          bottom: -3,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: w.color,
                              shape: BoxShape.circle,
                              border: Border.all(color: widget.isDark ? AppColors.darkCard : Colors.white, width: 1.5),
                            ),
                            child: Icon(w.icon, color: Colors.white, size: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(w.subtitleHindi, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_rounded, color: AppColors.primary),
                    onPressed: () => _showAddEditWhyWorkDialog(context, item: w),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () => widget.cmsService.deleteWhyWorkItem(w.id),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // --- 8. Contact & Socials Editor ---
  Widget _buildContactSocialsEditor(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Contact, Social Links & Security', 'WhatsApp automated greetings, maps query, links & Admin PIN.'),
          const SizedBox(height: 20),
          _buildInputBox('Contact Section Title', _contactHeadingCtrl, 'Let’s Discuss Your Next Big Project'),
          const SizedBox(height: 12),
          _buildInputBox('Contact Subtitle', _contactSubtitleCtrl, 'Aapke business requirements ke mutabik...'),
          const SizedBox(height: 12),
          _buildInputBox('Default WhatsApp Message Template', _whatsappMsgCtrl, 'Automated greeting message when client clicks WhatsApp', maxLines: 3),
          const SizedBox(height: 12),
          _buildInputBox('WhatsApp Floating Motivation / Hook Line', _whatsappMotivationCtrl, 'e.g. 🚀 Business grow karna hai? Abhi WhatsApp par baat karein!', maxLines: 2),
          const SizedBox(height: 12),
          _buildInputBox('Google Maps Location Search Query', _mapsQueryCtrl, 'e.g. Harahua, Varanasi, Uttar Pradesh, India'),
          const Divider(height: 36),
          const Text('Social Media & Channel Links:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputBox('YouTube Channel URL', _youtubeCtrl, 'https://youtube.com/@manishmaurya'),
          const SizedBox(height: 12),
          _buildInputBox('Instagram Profile URL', _instagramCtrl, 'https://instagram.com/manishmaurya'),
          const SizedBox(height: 12),
          _buildInputBox('Facebook Page / Profile URL', _facebookCtrl, 'https://facebook.com/manishmaurya'),
          const SizedBox(height: 12),
          _buildInputBox('LinkedIn Profile URL', _linkedinCtrl, 'https://linkedin.com/in/manishmaurya'),
          const Divider(height: 36),
          const Text('Footer & Security PIN Settings:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputBox('Footer Brand Description', _footerAboutCtrl, 'Helping businesses...', maxLines: 2),
          const SizedBox(height: 12),
          _buildInputBox('Copyright Notice', _copyrightCtrl, 'Digital Manish. All rights reserved.'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 480) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputBox('Admin Passcode / PIN', _adminPinCtrl, 'e.g. 1234'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Require PIN on Admin Open', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Spacer(),
                        Switch(
                          value: _pinRequired,
                          onChanged: (val) => setState(() => _pinRequired = val),
                          activeTrackColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _buildInputBox('Admin Passcode / PIN', _adminPinCtrl, 'e.g. 1234')),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Require PIN on Admin Open', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Switch(
                        value: _pinRequired,
                        onChanged: (val) => setState(() => _pinRequired = val),
                        activeTrackColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // --- 9. Backup & Restore Editor ---
  Widget _buildBackupRestoreEditor(BuildContext context) {
    final jsonBackup = widget.cmsService.exportAllDataAsJson();
    final jsonImportCtrl = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Backup, Export & Restore (JSON)', 'Apna pura website data export karke save karein ya doosre device par restore karein.'),
          const SizedBox(height: 20),

          // Export Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.download_rounded, color: AppColors.success),
                    SizedBox(width: 10),
                    Text('Export Full Website Data (JSON)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Ye pura JSON backup copy karke apne paas save rakh sakte hain:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                Container(
                  height: 140,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.black38 : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(jsonBackup, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: jsonBackup));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Complete JSON backup copied to clipboard! 📋')),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy JSON Backup'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Import Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.upload_rounded, color: AppColors.primary),
                    const SizedBox(width: 10),
                    const Text('Restore / Import JSON Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Saved JSON backup yahan paste karke "Restore Now" click karein:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                TextField(
                  controller: jsonImportCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Paste backup JSON string here...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (jsonImportCtrl.text.trim().isEmpty) return;
                    final ok = await widget.cmsService.importDataFromJson(jsonImportCtrl.text.trim());
                    if (ok && context.mounted) {
                      _initControllers(widget.cmsService.config);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data imported and restored successfully! 🎉'), backgroundColor: AppColors.success),
                      );
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid JSON format! Please check and retry.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.restore_page_rounded, size: 16),
                  label: const Text('Restore Now'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Factory Reset Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 520) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('Factory Reset All Website Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Sabhi customized data ko initial default state par reset kar dega.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Reset to Factory Default?'),
                              content: const Text('Kya aap sach me saara data default template par reset karna chahte hain?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Confirm Reset', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await widget.cmsService.resetToDefaults();
                            _initControllers(widget.cmsService.config);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Data reset to factory defaults!')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                        child: const Text('Reset Everything'),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Factory Reset All Website Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent)),
                          Text('Sabhi customized data ko initial default state par reset kar dega.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Reset to Factory Default?'),
                            content: const Text('Kya aap sach me saara data default template par reset karna chahte hain?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Confirm Reset', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await widget.cmsService.resetToDefaults();
                          _initControllers(widget.cmsService.config);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Data reset to factory defaults!')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                      child: const Text('Reset Everything'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInputBox(String label, TextEditingController ctrl, String hint, {int maxLines = 1, ValueChanged<String>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          onChanged: onChanged,
          style: TextStyle(
            color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: widget.isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: widget.isDark ? AppColors.darkCard : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveAllConfig,
        icon: const Icon(Icons.save_rounded),
        label: const Text('Save & Apply Live Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // --- Service Dialog ---
  void _showAddEditServiceDialog(BuildContext context, {ServiceModel? service}) {
    final titleHiCtrl = TextEditingController(text: service?.titleHindi ?? '');
    final titleEnCtrl = TextEditingController(text: service?.titleEnglish ?? '');
    final shortDescCtrl = TextEditingController(text: service?.shortDesc ?? '');
    final detailCtrl = TextEditingController(text: service?.detailedDesc ?? '');
    final imageUrlCtrl = TextEditingController(text: service?.imageUrl ?? '');
    final subOfferingsCtrl = TextEditingController(text: service?.subOfferings.join('\n') ?? 'Social Media Marketing\nLead Generation\nOnline Business Promotion');
    final benefitsCtrl = TextEditingController(text: service?.benefits.join('\n') ?? 'More qualified leads\nInstant customer reach');
    int selectedColor = service?.accentColorValue ?? 0xFF6366F1;
    int selectedIconCode = service?.iconCodePoint ?? Icons.miscellaneous_services_rounded.codePoint;

    final presetColors = [
      0xFF6366F1, 0xFFEC4899, 0xFF10B981, 0xFFF59E0B, 0xFF38BDF8, 0xFF8B5CF6, 0xFFEF4444, 0xFF14B8A6
    ];

    final presetIcons = [
      Icons.trending_up_rounded, Icons.campaign_rounded, Icons.search_rounded, Icons.ads_click_rounded,
      Icons.laptop_mac_rounded, Icons.phone_android_rounded, Icons.storefront_rounded, Icons.rocket_launch_rounded,
      Icons.code_rounded, Icons.cloud_done_rounded, Icons.auto_awesome_rounded, Icons.support_agent_rounded
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(service == null ? 'Add New Service' : 'Edit Service'),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(controller: titleHiCtrl, decoration: const InputDecoration(labelText: 'Title (Hindi/Hinglish) *')),
                  const SizedBox(height: 8),
                  TextField(controller: titleEnCtrl, decoration: const InputDecoration(labelText: 'Title (English subtitle)')),
                  const SizedBox(height: 8),
                  TextField(controller: shortDescCtrl, decoration: const InputDecoration(labelText: 'Short Description *')),
                  const SizedBox(height: 8),
                  TextField(controller: detailCtrl, decoration: const InputDecoration(labelText: 'Detailed Overview'), maxLines: 2),
                  const SizedBox(height: 14),

                  // Image Upload Section
                  const Text('Custom Service Image / Banner (Optional):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('Upload image from device or paste image URL to display on service cards and detail popup.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 400;
                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: imageUrlCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Service Image URL / Base64',
                                hintText: 'Paste link or upload below',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final base64Img = await ImagePickerHelper.pickImage();
                                      if (base64Img != null && base64Img.isNotEmpty) {
                                        setDialogState(() {
                                          imageUrlCtrl.text = base64Img;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.upload_file_rounded, size: 16),
                                    label: const Text('📁 Upload Image'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                if (imageUrlCtrl.text.trim().isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                                    tooltip: 'Remove Image',
                                    onPressed: () {
                                      setDialogState(() {
                                        imageUrlCtrl.clear();
                                      });
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: imageUrlCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Service Image URL / Base64',
                                hintText: 'Paste link or upload',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final base64Img = await ImagePickerHelper.pickImage();
                              if (base64Img != null && base64Img.isNotEmpty) {
                                setDialogState(() {
                                  imageUrlCtrl.text = base64Img;
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_file_rounded, size: 16),
                            label: const Text('📁 Upload'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            ),
                          ),
                          if (imageUrlCtrl.text.trim().isNotEmpty) ...[
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                              tooltip: 'Remove Image',
                              onPressed: () {
                                setDialogState(() {
                                  imageUrlCtrl.clear();
                                });
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  // Image Preview Box
                  if (imageUrlCtrl.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(selectedColor), width: 1.5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AppSmartImage(
                        imageUrl: imageUrlCtrl.text.trim(),
                        fit: BoxFit.cover,
                        errorWidget: const Center(
                          child: Icon(Icons.broken_image_rounded, color: Colors.redAccent, size: 28),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),
                  const Text('Pick Accent Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: presetColors.map((c) {
                      final isSel = selectedColor == c;
                      return InkWell(
                        onTap: () => setDialogState(() => selectedColor = c),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: Color(c), shape: BoxShape.circle, border: isSel ? Border.all(color: Colors.white, width: 3) : null),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Pick Icon:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presetIcons.map((ic) {
                      final isSel = selectedIconCode == ic.codePoint;
                      return InkWell(
                        onTap: () => setDialogState(() => selectedIconCode = ic.codePoint),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: isSel ? Color(selectedColor) : Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                          child: Icon(ic, size: 20, color: isSel ? Colors.white : Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: subOfferingsCtrl, decoration: const InputDecoration(labelText: 'Sub Offerings (One per line)'), maxLines: 3),
                  const SizedBox(height: 8),
                  TextField(controller: benefitsCtrl, decoration: const InputDecoration(labelText: 'Key Benefits (One per line)'), maxLines: 3),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleHiCtrl.text.trim().isEmpty) return;
                final subs = subOfferingsCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                final bens = benefitsCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

                final updated = ServiceModel(
                  id: service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  titleHindi: titleHiCtrl.text.trim(),
                  titleEnglish: titleEnCtrl.text.trim(),
                  shortDesc: shortDescCtrl.text.trim(),
                  detailedDesc: detailCtrl.text.trim(),
                  iconCodePoint: selectedIconCode,
                  accentColorValue: selectedColor,
                  subOfferings: subs,
                  benefits: bens,
                  imageUrl: imageUrlCtrl.text.trim(),
                );

                if (service == null) {
                  await widget.cmsService.addService(updated);
                } else {
                  await widget.cmsService.updateService(updated);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Save Service'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Project Dialog ---
  void _showAddEditProjectDialog(BuildContext context, {ProjectModel? project}) {
    final titleCtrl = TextEditingController(text: project?.title ?? '');
    String selectedCategory = project?.category ?? 'Website';
    final descCtrl = TextEditingController(text: project?.shortDesc ?? '');
    final detailCtrl = TextEditingController(text: project?.detailedDesc ?? '');
    final techCtrl = TextEditingController(text: project?.techStack.join(', ') ?? 'React, Next.js, Node.js');
    final demoCtrl = TextEditingController(text: project?.liveDemoUrl ?? '');
    final metricCtrl = TextEditingController(text: project?.resultsMetric ?? '');
    final imgCtrl = TextEditingController(text: project?.imageUrl ?? '');

    final categories = ['Website', 'App', 'Meta Ads', 'SEO', 'E-Commerce', 'Branding'];

    final presetMockupImages = [
      {'label': 'E-Commerce Web', 'url': 'https://images.unsplash.com/photo-1557821552-17105176677c?w=800&auto=format&fit=crop&q=60'},
      {'label': 'Meta Ads / Leads', 'url': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&auto=format&fit=crop&q=60'},
      {'label': 'Mobile App UI', 'url': 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&auto=format&fit=crop&q=60'},
      {'label': 'SEO / Analytics', 'url': 'https://images.unsplash.com/photo-1571786256017-aee7a0c009b6?w=800&auto=format&fit=crop&q=60'},
      {'label': 'Corporate Portal', 'url': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800&auto=format&fit=crop&q=60'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.rocket_launch_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(project == null ? 'Naya Project Upload Karein' : 'Project Edit Karein'),
            ],
          ),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Project Title / Client Name *',
                      hintText: 'e.g. Varanasi Sweets E-Commerce Portal',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category Dropdown
                  const Text('Project Category *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: categories.contains(selectedCategory) ? selectedCategory : 'Website',
                        isExpanded: true,
                        items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Short Description (Card par dikhega) *',
                      hintText: 'Brief summary of what was built or achieved...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: detailCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Detailed Case Study / Full Overview',
                      hintText: 'Client challenges, solution delivered and outcome...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: techCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tech Stack (Comma separated)',
                      hintText: 'Flutter, Next.js, Firebase, Meta Ads Manager',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  LayoutBuilder(
                    builder: (context, c) {
                      if (c.maxWidth < 440) {
                        return Column(
                          children: [
                            TextField(
                              controller: demoCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Live Demo URL / Website Link',
                                hintText: 'https://example.com',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: metricCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Result Metric (Badge)',
                                hintText: 'e.g. 450+ Leads, 3x Sales',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: demoCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Live Demo URL / Website Link',
                                hintText: 'https://example.com',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: metricCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Result Metric (Badge)',
                                hintText: 'e.g. 450+ Leads, 3x Sales',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Image URL input & Device Upload
                  LayoutBuilder(
                    builder: (context, c) {
                      if (c.maxWidth < 440) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: imgCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Project Screenshot / Image URL',
                                hintText: 'Paste image link or upload from device',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final base64Img = await ImagePickerHelper.pickImage();
                                if (base64Img != null && base64Img.isNotEmpty) {
                                  setDialogState(() {
                                    imgCtrl.text = base64Img;
                                  });
                                }
                              },
                              icon: const Icon(Icons.upload_file_rounded, size: 16),
                              label: const Text('📁 Upload from Device'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: imgCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Project Screenshot / Image URL',
                                hintText: 'Paste image link or upload from device',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final base64Img = await ImagePickerHelper.pickImage();
                              if (base64Img != null && base64Img.isNotEmpty) {
                                setDialogState(() {
                                  imgCtrl.text = base64Img;
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_file_rounded, size: 16),
                            label: const Text('📁 Upload'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Quick presets
                  const Text('Ya Sample Image Choose Karein:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presetMockupImages.map((p) {
                      return ActionChip(
                        label: Text(p['label']!, style: const TextStyle(fontSize: 11)),
                        onPressed: () {
                          imgCtrl.text = p['url']!;
                          setDialogState(() {});
                        },
                      );
                    }).toList(),
                  ),

                  // Image Preview Box
                  if (imgCtrl.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AppSmartImage(
                        imageUrl: imgCtrl.text.trim(),
                        fit: BoxFit.cover,
                        errorWidget: const Center(
                          child: Text('Invalid image format / URL', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton.icon(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter project title!')),
                  );
                  return;
                }
                final techList = techCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                final updated = ProjectModel(
                  id: project?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  category: selectedCategory,
                  shortDesc: descCtrl.text.trim().isEmpty ? 'Client project showcase' : descCtrl.text.trim(),
                  detailedDesc: detailCtrl.text.trim(),
                  techStack: techList.isEmpty ? ['Custom Tech'] : techList,
                  liveDemoUrl: demoCtrl.text.trim().isEmpty ? null : demoCtrl.text.trim(),
                  imageUrl: imgCtrl.text.trim(),
                  resultsMetric: metricCtrl.text.trim().isEmpty ? null : metricCtrl.text.trim(),
                );

                if (project == null) {
                  await widget.cmsService.addProject(updated);
                } else {
                  await widget.cmsService.updateProject(updated);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                setState(() {});
              },
              icon: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              label: Text(project == null ? 'Publish Project' : 'Update Project'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Why Work Dialog ---
  void _showAddEditWhyWorkDialog(BuildContext context, {WhyWorkModel? item}) {
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final subtitleCtrl = TextEditingController(text: item?.subtitleHindi ?? '');
    final imageUrlCtrl = TextEditingController(text: item?.imageUrl ?? '');
    int selectedColor = item?.colorValue ?? 0xFF6366F1;
    int selectedIconCode = item?.iconCodePoint ?? Icons.star_rounded.codePoint;

    final presetIcons = [
      Icons.sentiment_very_satisfied_rounded, Icons.bolt_rounded, Icons.devices_rounded,
      Icons.pie_chart_outline_rounded, Icons.mark_chat_read_rounded, Icons.auto_awesome_rounded,
      Icons.verified_rounded, Icons.security_rounded, Icons.support_agent_rounded, Icons.speed_rounded
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(item == null ? 'Add Value Pillar' : 'Edit Pillar'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title *')),
                  const SizedBox(height: 8),
                  TextField(controller: subtitleCtrl, decoration: const InputDecoration(labelText: 'Explanation (Hindi) *')),
                  const SizedBox(height: 14),

                  // Image Upload Section
                  const Text('Custom Icon / Image (Optional):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('Upload your custom icon/image or enter a URL. If set, it will be displayed instead of default icon.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 400;
                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: imageUrlCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Image URL or Upload Base64',
                                hintText: 'Paste link or upload below',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final base64Img = await ImagePickerHelper.pickImage();
                                      if (base64Img != null && base64Img.isNotEmpty) {
                                        setDialogState(() {
                                          imageUrlCtrl.text = base64Img;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.upload_file_rounded, size: 16),
                                    label: const Text('📁 Upload Image'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                if (imageUrlCtrl.text.trim().isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                                    tooltip: 'Remove Image',
                                    onPressed: () {
                                      setDialogState(() {
                                        imageUrlCtrl.clear();
                                      });
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: imageUrlCtrl,
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Image URL / Upload',
                                hintText: 'Paste link or upload',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final base64Img = await ImagePickerHelper.pickImage();
                              if (base64Img != null && base64Img.isNotEmpty) {
                                setDialogState(() {
                                  imageUrlCtrl.text = base64Img;
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_file_rounded, size: 16),
                            label: const Text('📁 Upload'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            ),
                          ),
                          if (imageUrlCtrl.text.trim().isNotEmpty) ...[
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                              tooltip: 'Remove Image',
                              onPressed: () {
                                setDialogState(() {
                                  imageUrlCtrl.clear();
                                });
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  // Image Preview Box if imageUrl is not empty
                  if (imageUrlCtrl.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(selectedColor), width: 2),
                        color: Color(selectedColor).withValues(alpha: 0.1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AppSmartImage(
                        imageUrl: imageUrlCtrl.text.trim(),
                        fit: BoxFit.cover,
                        errorWidget: const Center(
                          child: Icon(Icons.broken_image_rounded, color: Colors.redAccent, size: 24),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),
                  const Text('Or Pick Default Material Icon:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presetIcons.map((ic) {
                      final isSel = selectedIconCode == ic.codePoint;
                      return InkWell(
                        onTap: () => setDialogState(() => selectedIconCode = ic.codePoint),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: isSel ? Color(selectedColor) : Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                          child: Icon(ic, size: 20, color: isSel ? Colors.white : Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Pick Theme Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      0xFF6366F1, 0xFFEC4899, 0xFF10B981, 0xFFF59E0B, 0xFF38BDF8, 0xFF8B5CF6, 0xFFEF4444
                    ].map((c) {
                      final isSel = selectedColor == c;
                      return InkWell(
                        onTap: () => setDialogState(() => selectedColor = c),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(color: Color(c), shape: BoxShape.circle, border: isSel ? Border.all(color: Colors.white, width: 3) : null),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                final updated = WhyWorkModel(
                  id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  subtitleHindi: subtitleCtrl.text.trim(),
                  iconCodePoint: selectedIconCode,
                  colorValue: selectedColor,
                  imageUrl: imageUrlCtrl.text.trim(),
                );

                if (item == null) {
                  await widget.cmsService.addWhyWorkItem(updated);
                } else {
                  await widget.cmsService.updateWhyWorkItem(updated);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Save Pillar'),
            ),
          ],
        ),
      ),
    );
  }
}
