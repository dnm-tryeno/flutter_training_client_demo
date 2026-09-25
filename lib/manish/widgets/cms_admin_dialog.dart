import 'package:flutter/material.dart';
import '../data/cms_storage_service.dart';
import '../models/project_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CmsAdminDialog extends StatefulWidget {
  final CmsStorageService cmsService;
  final bool isDark;

  const CmsAdminDialog({
    super.key,
    required this.cmsService,
    required this.isDark,
  });

  @override
  State<CmsAdminDialog> createState() => _CmsAdminDialogState();
}

class _CmsAdminDialogState extends State<CmsAdminDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Profile controllers
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final cfg = widget.cmsService.config;
    _phoneCtrl = TextEditingController(text: cfg.phone);
    _emailCtrl = TextEditingController(text: cfg.email);
    _locCtrl = TextEditingController(text: cfg.location);
    _bioCtrl = TextEditingController(text: cfg.aboutBio);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _locCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary = widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 720),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portfolio Content Manager (CMS)',
                            style: AppTypography.headlineSmall(context, isDark: widget.isDark).copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Update projects & contact info instantly',
                            style: TextStyle(color: AppColors.primaryLight, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Tab bar
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                tabs: const [
                  Tab(icon: Icon(Icons.rocket_launch_rounded, size: 18), text: 'Projects'),
                  Tab(icon: Icon(Icons.person_rounded, size: 18), text: 'Profile & Contact'),
                ],
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProjectsTab(context, textPrimary),
                    _buildProfileTab(context, textPrimary),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Reset to Default?'),
                            content: const Text('Kya aap saare projects aur profile data ko default par reset karna chahte hain?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Reset', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await widget.cmsService.resetToDefaults();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Data reset to default templates!')),
                            );
                            setState(() {
                              final cfg = widget.cmsService.config;
                              _phoneCtrl.text = cfg.phone;
                              _emailCtrl.text = cfg.email;
                              _locCtrl.text = cfg.location;
                              _bioCtrl.text = cfg.aboutBio;
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.redAccent),
                      label: const Text('Reset to Defaults', style: TextStyle(color: Colors.redAccent)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Done / Close'),
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

  // --- Projects Tab ---
  Widget _buildProjectsTab(BuildContext context, Color textPrimary) {
    final projects = widget.cmsService.projects;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Projects: ${projects.length}',
                style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditProjectDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add New Project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = projects[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            p.category.substring(0, 1),
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${p.category} • ${p.techStack.join(', ')}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_rounded, color: AppColors.primary, size: 20),
                        onPressed: () => _showAddEditProjectDialog(context, project: p),
                        tooltip: 'Edit Project',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          await widget.cmsService.deleteProject(p.id);
                          setState(() {});
                        },
                        tooltip: 'Delete Project',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Profile Tab ---
  Widget _buildProfileTab(BuildContext context, Color textPrimary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Phone Number', _phoneCtrl, 'e.g. 7380492118'),
          const SizedBox(height: 14),
          _buildTextField('Email Address', _emailCtrl, 'e.g. manishmaurya.digital@gmail.com'),
          const SizedBox(height: 14),
          _buildTextField('Location', _locCtrl, 'e.g. Harahua, Varanasi, Uttar Pradesh, India'),
          const SizedBox(height: 14),
          _buildTextField('About Me (Bio in Hindi/Hinglish)', _bioCtrl, 'Enter your introduction...', maxLines: 4),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final updated = widget.cmsService.config.copyWith(
                  phone: _phoneCtrl.text.trim(),
                  email: _emailCtrl.text.trim(),
                  location: _locCtrl.text.trim(),
                  aboutBio: _bioCtrl.text.trim(),
                );
                await widget.cmsService.updateConfig(updated);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile information updated successfully!')),
                  );
                }
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Profile Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, String hint, {int maxLines = 1}) {
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

  // Dialog to Add/Edit Project
  void _showAddEditProjectDialog(BuildContext context, {ProjectModel? project}) {
    final titleCtrl = TextEditingController(text: project?.title ?? '');
    final catCtrl = TextEditingController(text: project?.category ?? 'Website');
    final descCtrl = TextEditingController(text: project?.shortDesc ?? '');
    final detailCtrl = TextEditingController(text: project?.detailedDesc ?? '');
    final techCtrl = TextEditingController(text: project?.techStack.join(', ') ?? 'React, Next.js, Node.js');
    final demoCtrl = TextEditingController(text: project?.liveDemoUrl ?? '');
    final metricCtrl = TextEditingController(text: project?.resultsMetric ?? '');
    final imgCtrl = TextEditingController(text: project?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(project == null ? 'Add New Project' : 'Edit Project'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Project Title *')),
                const SizedBox(height: 8),
                TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Category (Website / App / Meta Ads / SEO)')),
                const SizedBox(height: 8),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Short Description *')),
                const SizedBox(height: 8),
                TextField(controller: detailCtrl, decoration: const InputDecoration(labelText: 'Detailed Description'), maxLines: 2),
                const SizedBox(height: 8),
                TextField(controller: techCtrl, decoration: const InputDecoration(labelText: 'Tech Stack (comma separated)')),
                const SizedBox(height: 8),
                TextField(controller: demoCtrl, decoration: const InputDecoration(labelText: 'Live Demo URL')),
                const SizedBox(height: 8),
                TextField(controller: metricCtrl, decoration: const InputDecoration(labelText: 'Result Metric (e.g. 3x Sales, 450+ Leads)')),
                const SizedBox(height: 8),
                TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: 'Image / Mockup URL')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              final techList = techCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              final updated = ProjectModel(
                id: project?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleCtrl.text.trim(),
                category: catCtrl.text.trim().isEmpty ? 'Website' : catCtrl.text.trim(),
                shortDesc: descCtrl.text.trim(),
                detailedDesc: detailCtrl.text.trim(),
                techStack: techList,
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save Project'),
          ),
        ],
      ),
    );
  }
}
