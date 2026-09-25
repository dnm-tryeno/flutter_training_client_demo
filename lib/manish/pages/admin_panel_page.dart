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

  // Profile Form Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _taglineCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _locationShortCtrl;
  late TextEditingController _avatarUrlCtrl;

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
  late TextEditingController _mapsQueryCtrl;

  // Social & Footer Controllers
  late TextEditingController _githubCtrl;
  late TextEditingController _linkedinCtrl;
  late TextEditingController _instagramCtrl;
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
    _mapsQueryCtrl = TextEditingController(text: cfg.mapsEmbedQuery);

    _githubCtrl = TextEditingController(text: cfg.githubUrl);
    _linkedinCtrl = TextEditingController(text: cfg.linkedinUrl);
    _instagramCtrl = TextEditingController(text: cfg.instagramUrl);
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
    _mapsQueryCtrl.dispose();
    _githubCtrl.dispose();
    _linkedinCtrl.dispose();
    _instagramCtrl.dispose();
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
      mapsEmbedQuery: _mapsQueryCtrl.text.trim(),
      githubUrl: _githubCtrl.text.trim(),
      linkedinUrl: _linkedinCtrl.text.trim(),
      instagramUrl: _instagramCtrl.text.trim(),
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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
            const SizedBox(width: 10),
            const Text(
              'Master Admin Panel (100% Customizable)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: widget.isDark ? AppColors.darkSurface : Colors.white,
        elevation: 1,
        actions: [
          ElevatedButton.icon(
            onPressed: _saveAllConfig,
            icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
            label: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.remove_red_eye_rounded, color: AppColors.success),
            tooltip: 'View Live Portfolio',
          ),
          const SizedBox(width: 16),
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
          : Column(
              children: [
                // Mobile Tab Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: _sidebarItems.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      final isSelected = _selectedTabIndex == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: Icon(item['icon'] as IconData, size: 16, color: isSelected ? Colors.white : AppColors.primary),
                          label: Text(item['title'] as String),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedTabIndex = i);
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (widget.isDark ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildSelectedTabContent(context),
                  ),
                ),
              ],
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
    {'title': 'Dashboard', 'icon': Icons.dashboard_rounded},
    {'title': 'Theme & Colors', 'icon': Icons.palette_rounded},
    {'title': 'Profile & Hero', 'icon': Icons.person_rounded},
    {'title': 'About Manish', 'icon': Icons.badge_rounded},
    {'title': 'Services Manager', 'icon': Icons.miscellaneous_services_rounded},
    {'title': 'Projects Showcase', 'icon': Icons.rocket_launch_rounded},
    {'title': 'Why Work With Me', 'icon': Icons.star_rounded},
    {'title': 'Contact & Socials', 'icon': Icons.contacts_rounded},
    {'title': 'Backup & Restore', 'icon': Icons.backup_rounded},
  ];

  Widget _buildSidebarList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _sidebarItems.length,
      itemBuilder: (context, i) {
        final isSelected = _selectedTabIndex == i;
        final item = _sidebarItems[i];
        return Material(
          color: Colors.transparent,
          child: ListTile(
            selected: isSelected,
            selectedTileColor: AppColors.primary.withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Icon(item['icon'] as IconData, color: isSelected ? AppColors.primary : Colors.grey),
            title: Text(
              item['title'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : (widget.isDark ? Colors.white70 : Colors.black87),
              ),
            ),
            onTap: () => setState(() => _selectedTabIndex = i),
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
            'Manish Maurya Portfolio CMS v2.0 - Har cheez live edit karein.',
          ),
          const SizedBox(height: 24),

          // Stat Cards
          Row(
            children: [
              _buildStatCard('Active Services', '${services.length}', Icons.miscellaneous_services_rounded, const Color(0xFF6366F1)),
              const SizedBox(width: 16),
              _buildStatCard('Showcase Projects', '${projects.length}', Icons.rocket_launch_rounded, const Color(0xFFEC4899)),
              const SizedBox(width: 16),
              _buildStatCard('Value Pillars', '${whyWork.length}', Icons.star_rounded, const Color(0xFF10B981)),
            ],
          ),
          const SizedBox(height: 28),

          // Quick Action Cards
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
                const Text('⚡ Quick Actions:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedTabIndex = 1),
                      icon: const Icon(Icons.palette_rounded),
                      label: const Text('🎨 Change Theme / Color'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedTabIndex = 5),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('+ Add New Project'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC4899), foregroundColor: Colors.white),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedTabIndex = 4),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('+ Add New Service'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedTabIndex = 2),
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Edit Profile & Photo'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.white),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.visibility_rounded),
                      label: const Text('Preview Live Website'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

                Row(
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
                  child: Row(
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
          _buildInputBox('Full Name', _nameCtrl, 'e.g. Manish Maurya'),
          const SizedBox(height: 12),
          _buildInputBox('Professional Tagline / Role', _taglineCtrl, 'e.g. Digital Marketing | Website & App Development'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInputBox('Phone Number', _phoneCtrl, 'e.g. 7380492118')),
              const SizedBox(width: 12),
              Expanded(child: _buildInputBox('WhatsApp Number', _whatsappCtrl, 'e.g. 7380492118')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInputBox('Full Location', _locationCtrl, 'e.g. Harahua, Varanasi, Uttar Pradesh, India')),
              const SizedBox(width: 12),
              Expanded(child: _buildInputBox('Short Location', _locationShortCtrl, 'e.g. Harahua, Varanasi (UP)')),
            ],
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Live Avatar Preview
                    Container(
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                      ),
                    ),
                  ],
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
          const Divider(height: 36),
          const Text('Hero Section Text & Badges:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputBox('Hero Main Heading (Hindi/Hinglish)', _heroTitleCtrl, 'Main Catchy Headline', maxLines: 2),
          const SizedBox(height: 12),
          _buildInputBox('Hero Subtitle / Description', _heroSubtitleCtrl, 'Introductory pitch paragraph', maxLines: 3),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInputBox('Floating Badge 1', _heroBadge1Ctrl, 'e.g. Available for Projects')),
              const SizedBox(width: 12),
              Expanded(child: _buildInputBox('Floating Badge 2', _heroBadge2Ctrl, 'e.g. ROI Focused')),
            ],
          ),
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
          _buildInputBox('Section Title', _aboutHeadingCtrl, 'e.g. About Manish Maurya'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Services Manager', 'Add, edit, delete, or change icons & benefits of your services.'),
              ElevatedButton.icon(
                onPressed: () => _showAddEditServiceDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('+ Add Service'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            onReorder: (oldIndex, newIndex) => widget.cmsService.reorderServices(oldIndex, newIndex),
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: s.accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                      child: Icon(s.icon, color: s.accentColor, size: 24),
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
                    const Icon(Icons.drag_handle_rounded, color: Colors.grey),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Projects Showcase Manager', 'Live websites, mobile apps aur ads case studies add/edit karein.'),
              ElevatedButton.icon(
                onPressed: () => _showAddEditProjectDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('+ Add Project'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            onReorder: (oldIndex, newIndex) => widget.cmsService.reorderProjects(oldIndex, newIndex),
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
                      child: Center(child: Text(p.category.substring(0, 1), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18))),
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
                    const Icon(Icons.drag_handle_rounded, color: Colors.grey),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Why Work With Me (Value Pillars)', '6 value pillars ko customize, add ya delete karein.'),
              ElevatedButton.icon(
                onPressed: () => _showAddEditWhyWorkDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('+ Add Pillar'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputBox('Section Title', _aboutHeadingCtrl, 'Why Work With Manish Maurya?'),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: w.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                    child: Icon(w.icon, color: w.color, size: 24),
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
          _buildInputBox('Google Maps Location Search Query', _mapsQueryCtrl, 'e.g. Harahua, Varanasi, Uttar Pradesh, India'),
          const Divider(height: 36),
          const Text('Social Media & External Links:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputBox('GitHub Profile URL', _githubCtrl, 'https://github.com/...'),
          const SizedBox(height: 12),
          _buildInputBox('LinkedIn Profile URL', _linkedinCtrl, 'https://linkedin.com/...'),
          const SizedBox(height: 12),
          _buildInputBox('Instagram / Social URL', _instagramCtrl, 'https://instagram.com/...'),
          const Divider(height: 36),
          const Text('Footer & Security PIN Settings:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputBox('Footer Brand Description', _footerAboutCtrl, 'Helping businesses...', maxLines: 2),
          const SizedBox(height: 12),
          _buildInputBox('Copyright Notice', _copyrightCtrl, 'Manish Maurya. All rights reserved.'),
          const SizedBox(height: 12),
          Row(
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
            child: Row(
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
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInputBox(String label, TextEditingController ctrl, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: widget.isDark ? AppColors.darkCard : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                  const SizedBox(height: 12),
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

                  Row(
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
                  ),
                  const SizedBox(height: 14),

                  // Image URL input & Device Upload
                  Row(
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
