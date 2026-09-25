import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';
import 'app_smart_image.dart';
import 'project_detail_dialog.dart';

class ProjectsSection extends StatefulWidget {
  final List<ProjectModel> projects;
  final bool isDark;
  final VoidCallback onOpenCms;

  const ProjectsSection({
    super.key,
    required this.projects,
    required this.isDark,
    required this.onOpenCms,
  });

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Website',
    'App',
    'Meta Ads',
    'SEO',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 950;
    final isTablet = width > 600 && width <= 950;
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    final filteredProjects = _selectedCategory == 'All'
        ? widget.projects
        : widget.projects.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 64 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Badge & Add Project CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Case Studies & Work Portfolio',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Featured Projects Showcase',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium(context, isDark: widget.isDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Live digital campaigns, modern responsive websites aur dynamic cross-platform mobile apps.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(context, isDark: widget.isDark),
              ),
              const SizedBox(height: 24),

              // Category Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = cat);
                          }
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        backgroundColor: widget.isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Grid of Projects
              filteredProjects.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'Is category me abhi koi project nahi hai.',
                            style: AppTypography.bodyLarge(context, isDark: widget.isDark),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: widget.onOpenCms,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add Project Now'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: isDesktop ? 0.78 : (isTablet ? 0.82 : 0.88),
                      ),
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, i) {
                        final project = filteredProjects[i];
                        return _buildProjectCard(context, project);
                      },
                    ),

              const SizedBox(height: 32),

              // Add Project Floating / Banner CTA for easy addition
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.darkCard : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isDark ? AppColors.darkCardBorder : const Color(0xFFC7D2FE),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Want to add or update your live client projects?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            'Use the integrated CMS editor to add new screenshots, links & metrics anytime.',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: widget.onOpenCms,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text('+ Add Project'),
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

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    final textPrimary = widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail / Mockup Header
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                child: project.imageUrl.isNotEmpty
                    ? AppSmartImage(
                        imageUrl: project.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: _buildCardMockupPlaceholder(project),
                      )
                    : _buildCardMockupPlaceholder(project),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project.category,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (project.resultsMetric != null && project.resultsMetric!.isNotEmpty)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      project.resultsMetric!,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),

          // Card Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      project.shortDesc,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium(context, isDark: widget.isDark),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tech Stack Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: project.techStack.take(3).map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Buttons: Live Demo & Project Details
                  Row(
                    children: [
                      if (project.liveDemoUrl != null && project.liveDemoUrl!.isNotEmpty) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => UrlHelper.openLink(project.liveDemoUrl!, context: context),
                            icon: const Icon(Icons.open_in_new_rounded, size: 14),
                            label: const Text('Live Demo', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => ProjectDetailDialog(project: project, isDark: widget.isDark),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(
                              color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                            ),
                          ),
                          child: const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardMockupPlaceholder(ProjectModel project) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.laptop_chromebook_rounded, size: 40, color: Colors.white70),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                project.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
