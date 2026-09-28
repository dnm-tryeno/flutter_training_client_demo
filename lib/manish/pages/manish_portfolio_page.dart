import 'package:flutter/material.dart';
import '../data/cms_storage_service.dart';
import '../models/profile_config_model.dart';
import '../models/project_model.dart';
import '../models/service_model.dart';
import '../pages/admin_panel_page.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import '../widgets/about_section.dart';
import '../widgets/app_smart_image.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/project_detail_dialog.dart';
import '../widgets/projects_section.dart';
import '../widgets/service_detail_dialog.dart';
import '../widgets/services_section.dart';
import '../widgets/whatsapp_icon.dart';
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
  String _currentTab = 'home';

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

  void _onTabSelected(String tabKey) {
    setState(() {
      _currentTab = tabKey;
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 860;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar with active tab indicator
            PortfolioNavBar(
              isDark: _isDark,
              currentTab: _currentTab,
              config: config,
              onToggleTheme: () => setState(() => _isDark = !_isDark),
              onOpenCms: _openAdminPanel,
              onNavigate: _onTabSelected,
            ),

            // Main Tab Content View
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: KeyedSubtree(
                    key: ValueKey<String>(_currentTab),
                    child: _buildCurrentTabContent(config, isDesktop),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),



      // Floating Action Buttons for WhatsApp & Scroll To Top
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
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
          // Unified Floating WhatsApp Button with Motivation Text
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => UrlHelper.openWhatsApp(
                phone: config.whatsappNumber,
                message: config.whatsappDefaultMessage,
                context: context,
              ),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 340),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.5),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const WhatsAppIcon(
                      size: 28,
                      color: Colors.white,
                    ),
                    if (config.whatsappMotivationText.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          config.whatsappMotivationText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCurrentTabContent(ProfileConfigModel config, bool isDesktop) {
    switch (_currentTab) {
      case 'about':
        return _buildAboutTab(config, isDesktop);
      case 'services':
        return _buildServicesTab(config, isDesktop);
      case 'projects':
        return _buildProjectsTab(config, isDesktop);
      case 'contact':
        return _buildContactTab(config, isDesktop);
      case 'home':
      default:
        return _buildHomeTab(config, isDesktop);
    }
  }

  // ==================== HOME TAB ====================
  Widget _buildHomeTab(ProfileConfigModel config, bool isDesktop) {
    return Column(
      children: [
        // Hero Section
        HeroSection(
          isDark: _isDark,
          config: config,
          onNavigate: _onTabSelected,
        ),

        // Why Work With Me Highlights
        WhyWorkWithMeSection(
          isDark: _isDark,
          items: _cmsService.whyWorkList,
          config: config,
        ),

        // Featured Services Preview
        _buildHomeFeaturedServices(isDesktop),

        // Featured Projects Preview
        _buildHomeFeaturedProjects(isDesktop),

        // Quick CTA Section
        _buildHomeContactCta(config, isDesktop),

        // Footer
        FooterSection(
          isDark: _isDark,
          config: config,
          onNavigate: _onTabSelected,
          onOpenAdmin: _openAdminPanel,
        ),
      ],
    );
  }

  // ==================== ABOUT TAB ====================
  Widget _buildAboutTab(ProfileConfigModel config, bool isDesktop) {
    return Column(
      children: [
        // Full About Section
        AboutSection(
          isDark: _isDark,
          config: config,
        ),

        // Why Work With Me
        WhyWorkWithMeSection(
          isDark: _isDark,
          items: _cmsService.whyWorkList,
          config: config,
        ),

        // Bottom CTA
        _buildTabBottomCta(
          title: 'Ready to collaborate on your next project?',
          subtitle: 'Let\'s turn your ideas into high-converting digital realities.',
          buttonText: 'Contact Digital Manish',
          targetTab: 'contact',
        ),

        // Footer
        FooterSection(
          isDark: _isDark,
          config: config,
          onNavigate: _onTabSelected,
          onOpenAdmin: _openAdminPanel,
        ),
      ],
    );
  }

  // ==================== SERVICES TAB ====================
  Widget _buildServicesTab(ProfileConfigModel config, bool isDesktop) {
    return Column(
      children: [
        // Full Services Section
        ServicesSection(
          isDark: _isDark,
          services: _cmsService.services,
          onOpenAdmin: _openAdminPanel,
        ),

        // Custom Requirements CTA
        _buildTabBottomCta(
          title: 'Need a Custom Marketing or Dev Strategy?',
          subtitle: 'I craft custom end-to-end solutions tailored specifically for your business growth.',
          buttonText: 'Discuss Your Requirements',
          targetTab: 'contact',
        ),

        // Footer
        FooterSection(
          isDark: _isDark,
          config: config,
          onNavigate: _onTabSelected,
          onOpenAdmin: _openAdminPanel,
        ),
      ],
    );
  }

  // ==================== PROJECTS TAB ====================
  Widget _buildProjectsTab(ProfileConfigModel config, bool isDesktop) {
    return Column(
      children: [
        // Full Projects Section with Category Filters
        ProjectsSection(
          projects: _cmsService.projects,
          isDark: _isDark,
          onOpenCms: _openAdminPanel,
        ),

        // Project Proposal CTA
        _buildTabBottomCta(
          title: 'Have a project or website in mind?',
          subtitle: 'Get top quality development with fast turnaround and modern tech stack.',
          buttonText: 'Start Your Project Today',
          targetTab: 'contact',
        ),

        // Footer
        FooterSection(
          isDark: _isDark,
          config: config,
          onNavigate: _onTabSelected,
          onOpenAdmin: _openAdminPanel,
        ),
      ],
    );
  }

  // ==================== CONTACT TAB ====================
  Widget _buildContactTab(ProfileConfigModel config, bool isDesktop) {
    return Column(
      children: [
        // Full Contact Section
        ContactSection(
          isDark: _isDark,
          config: config,
        ),

        // Footer
        FooterSection(
          isDark: _isDark,
          config: config,
          onNavigate: _onTabSelected,
          onOpenAdmin: _openAdminPanel,
        ),
      ],
    );
  }

  // ==================== HOME TAB PREVIEW SECTIONS ====================
  Widget _buildHomeFeaturedServices(bool isDesktop) {
    final services = _cmsService.services.take(3).toList();
    if (services.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 60 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 500;
                  final titleCol = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Services Overview',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'What I Specialize In',
                        style: AppTypography.displayMedium(context, isDark: _isDark),
                      ),
                    ],
                  );

                  final viewAllBtn = TextButton.icon(
                    onPressed: () => _onTabSelected('services'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View All Services', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                    ),
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleCol,
                        const SizedBox(height: 8),
                        viewAllBtn,
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: titleCol),
                      viewAllBtn,
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: services.map((service) {
                  return SizedBox(
                    width: isDesktop ? 370 : double.infinity,
                    child: _buildServicePreviewCard(service),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _onTabSelected('services'),
                icon: const Icon(Icons.miscellaneous_services_rounded, size: 18),
                label: const Text('Explore All Specialized Services', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicePreviewCard(ServiceModel service) {
    final hasImage = service.imageUrl.isNotEmpty;
    final textPrimary = _isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = _isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // Full background image covering entire box
          if (hasImage) ...[
            Positioned.fill(
              child: AppSmartImage(
                imageUrl: service.imageUrl,
                fit: BoxFit.cover,
                errorWidget: Container(color: service.accentColor.withValues(alpha: 0.15)),
              ),
            ),
            Positioned.fill(
              child: Container(
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
            ),
          ],

          // Card Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: hasImage ? service.accentColor.withValues(alpha: 0.95) : AppColors.primary.withValues(alpha: 0.12),
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
                          color: hasImage ? Colors.white : AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    if (hasImage)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                            const SizedBox(width: 4),
                            const Text(
                              'Featured',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  service.titleEnglish,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: hasImage ? Colors.white : textPrimary,
                    shadows: hasImage ? const [Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 2))] : null,
                  ),
                ),
                if (service.titleHindi.isNotEmpty && service.titleHindi != service.titleEnglish) ...[
                  const SizedBox(height: 3),
                  Text(
                    service.titleHindi,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasImage ? Colors.white70 : service.accentColor,
                      shadows: hasImage ? const [Shadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 1))] : null,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  service.shortDesc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: hasImage ? Colors.white70 : textSecondary,
                    shadows: hasImage ? const [Shadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 1))] : null,
                  ),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ServiceDetailDialog(service: service, isDark: _isDark),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: hasImage ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8) : EdgeInsets.zero,
                    decoration: hasImage
                        ? BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white30, width: 1),
                          )
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Learn More',
                          style: TextStyle(
                            color: hasImage ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: hasImage ? Colors.white : AppColors.primary,
                        ),
                      ],
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

  Widget _buildHomeFeaturedProjects(bool isDesktop) {
    final projects = _cmsService.projects.take(3).toList();
    if (projects.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 60 : 40,
      ),
      decoration: BoxDecoration(
        color: _isDark ? const Color(0xFF0C101B) : const Color(0xFFF1F5F9),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 500;
                  final titleCol = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Portfolio Showcase',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Featured Work',
                        style: AppTypography.displayMedium(context, isDark: _isDark),
                      ),
                    ],
                  );

                  final viewAllBtn = TextButton.icon(
                    onPressed: () => _onTabSelected('projects'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View All Projects', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                    ),
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleCol,
                        const SizedBox(height: 8),
                        viewAllBtn,
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: titleCol),
                      viewAllBtn,
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: projects.map((project) {
                  return SizedBox(
                    width: isDesktop ? 370 : double.infinity,
                    child: _buildProjectPreviewCard(project),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _onTabSelected('projects'),
                icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                label: const Text('See Full Projects Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectPreviewCard(ProjectModel project) {
    return Container(
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image
          SizedBox(
            height: 180,
            width: double.infinity,
            child: AppSmartImage(
              imageUrl: project.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    project.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project.shortDesc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: _isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ProjectDetailDialog(
                            project: project,
                            isDark: _isDark,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (project.liveDemoUrl != null && project.liveDemoUrl!.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        color: AppColors.primary,
                        tooltip: 'Live Demo',
                        onPressed: () => UrlHelper.openLink(project.liveDemoUrl!, context: context),
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

  Widget _buildHomeContactCta(ProfileConfigModel config, bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : 24,
              vertical: isDesktop ? 40 : 32,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Have a Project or Campaign in Mind?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Get in touch today for top-tier digital marketing results and high performance web & app development.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _onTabSelected('contact'),
                      icon: Icon(Icons.alternate_email_rounded, color: AppColors.primary),
                      label: Text('Contact Me Tab', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => UrlHelper.openWhatsApp(
                        phone: config.whatsappNumber,
                        message: config.whatsappDefaultMessage,
                        context: context,
                      ),
                      icon: const Icon(Icons.chat_rounded, color: Colors.white),
                      label: const Text('Chat on WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.whatsappGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBottomCta({
    required String title,
    required String subtitle,
    required String buttonText,
    required String targetTab,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            decoration: BoxDecoration(
              color: _isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isDark ? 0.2 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _onTabSelected(targetTab),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
