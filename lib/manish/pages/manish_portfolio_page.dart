import 'package:flutter/material.dart';
import '../data/cms_storage_service.dart';
import '../pages/admin_panel_page.dart';
import '../theme/app_colors.dart';
import '../utils/url_helper.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/projects_section.dart';
import '../widgets/services_section.dart';
import '../widgets/why_work_with_me.dart';

class ManishPortfolioPage extends StatefulWidget {
  final bool initialDarkMode;

  const ManishPortfolioPage({
    super.key,
    this.initialDarkMode = true,
  });

  @override
  State<ManishPortfolioPage> createState() => _ManishPortfolioPageState();
}

class _ManishPortfolioPageState extends State<ManishPortfolioPage> {
  late bool _isDark;
  final CmsStorageService _cmsService = CmsStorageService();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  // Global keys for smooth section scrolling
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isDark = widget.initialDarkMode;
    _cmsService.addListener(_onCmsUpdate);
    _scrollController.addListener(_onScroll);
  }

  void _onCmsUpdate() {
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (_scrollController.offset > 400 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 400 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  @override
  void dispose() {
    _cmsService.removeListener(_onCmsUpdate);
    _cmsService.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionKey) {
    GlobalKey? targetKey;
    switch (sectionKey) {
      case 'home':
        targetKey = _homeKey;
        break;
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'services':
        targetKey = _servicesKey;
        break;
      case 'projects':
        targetKey = _projectsKey;
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _openAdminPanel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdminPanelPage(
          cmsService: _cmsService,
          isDark: _isDark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isDark ? AppColors.darkBg : AppColors.lightBg;
    final config = _cmsService.config;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            PortfolioNavBar(
              isDark: _isDark,
              config: config,
              onToggleTheme: () => setState(() => _isDark = !_isDark),
              onOpenCms: _openAdminPanel,
              onNavigate: _scrollToSection,
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Home / Hero Section
                    Container(
                      key: _homeKey,
                      child: HeroSection(
                        isDark: _isDark,
                        config: config,
                        onNavigate: _scrollToSection,
                      ),
                    ),

                    // About Me Section
                    Container(
                      key: _aboutKey,
                      child: AboutSection(
                        isDark: _isDark,
                        config: config,
                      ),
                    ),

                    // My Services Section
                    Container(
                      key: _servicesKey,
                      child: ServicesSection(
                        isDark: _isDark,
                        services: _cmsService.services,
                        onOpenAdmin: _openAdminPanel,
                      ),
                    ),

                    // My Projects Section
                    Container(
                      key: _projectsKey,
                      child: ProjectsSection(
                        projects: _cmsService.projects,
                        isDark: _isDark,
                        onOpenCms: _openAdminPanel,
                      ),
                    ),

                    // Why Work With Me Section
                    WhyWorkWithMeSection(
                      isDark: _isDark,
                      items: _cmsService.whyWorkList,
                      config: config,
                    ),

                    // Contact & Location Section
                    Container(
                      key: _contactKey,
                      child: ContactSection(
                        isDark: _isDark,
                        config: config,
                      ),
                    ),

                    // Footer Section
                    FooterSection(
                      isDark: _isDark,
                      config: config,
                      onNavigate: _scrollToSection,
                      onOpenAdmin: _openAdminPanel,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Buttons for instant WhatsApp & Call
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showScrollToTop) ...[
            FloatingActionButton.small(
              heroTag: 'scroll_top',
              onPressed: () {
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
              },
              backgroundColor: _isDark ? AppColors.darkCard : Colors.white,
              foregroundColor: _isDark ? Colors.white : AppColors.lightTextPrimary,
              child: const Icon(Icons.keyboard_arrow_up_rounded),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton.extended(
            heroTag: 'whatsapp_float',
            onPressed: () => UrlHelper.openWhatsApp(
              phone: config.whatsappNumber,
              message: config.whatsappDefaultMessage,
              context: context,
            ),
            backgroundColor: AppColors.whatsappGreen,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.chat_bubble_rounded),
            label: const Text('WhatsApp Chat', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
