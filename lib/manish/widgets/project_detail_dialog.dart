import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/url_helper.dart';

class ProjectDetailDialog extends StatelessWidget {
  final ProjectModel project;
  final bool isDark;

  const ProjectDetailDialog({
    super.key,
    required this.project,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image / Mockup Banner
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                        child: project.imageUrl.isNotEmpty
                            ? Image.network(
                                project.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildPlaceholderHeader(),
                              )
                            : _buildPlaceholderHeader(),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          project.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Result Metric
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              project.title,
                              style: AppTypography.displayMedium(context, isDark: isDark).copyWith(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                      if (project.resultsMetric != null && project.resultsMetric!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.trending_up_rounded, color: AppColors.success, size: 18),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Result: ${project.resultsMetric}',
                                  style: const TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Project Overview',
                        style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.detailedDesc.isNotEmpty ? project.detailedDesc : project.shortDesc,
                        style: AppTypography.bodyLarge(context, isDark: isDark),
                      ),
                      const SizedBox(height: 20),

                      // Key Features
                      if (project.keyFeatures.isNotEmpty) ...[
                        Text(
                          'Key Features & Deliverables',
                          style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ...project.keyFeatures.map((feat) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      feat,
                                      style: AppTypography.bodyMedium(context, isDark: isDark).copyWith(
                                        color: textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 20),
                      ],

                      // Tech Stack Chips
                      Text(
                        'Technologies Used',
                        style: AppTypography.headlineSmall(context, isDark: isDark).copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.techStack.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                              ),
                            ),
                            child: Text(
                              tech,
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // Action buttons
                      Row(
                        children: [
                          if (project.liveDemoUrl != null && project.liveDemoUrl!.isNotEmpty) ...[
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  UrlHelper.openLink(project.liveDemoUrl!, context: context);
                                },
                                icon: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
                                label: const Text('Live Demo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                UrlHelper.openWhatsApp(
                                  message:
                                      'Namaste Manish ji! Maine aapka "${project.title}" project dekha. Mujhe bhi aisi website/service banwani hai. Please quote provide karein.',
                                  context: context,
                                );
                              },
                              icon: const Icon(Icons.chat_rounded, color: AppColors.whatsappGreen, size: 18),
                              label: const Text('Want Similar Project?'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.whatsappGreen,
                                side: const BorderSide(color: AppColors.whatsappGreen, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
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
      ),
    );
  }

  Widget _buildPlaceholderHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.devices_rounded, size: 48, color: Colors.white70),
            const SizedBox(height: 8),
            Text(
              project.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
