import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';
import 'assignments_page.dart';
import 'courses_page.dart';
import 'live_schedule_page.dart';
import 'performance_page.dart';
import 'study_material_page.dart';
import 'videos_page.dart';

/// Home dashboard: greeting, quick actions, live class banner, and previews
/// of batches, courses and study material.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _greeting(),
        _searchBar(context),
        _quickActions(context),
        const LmsSectionHeader('Live Schedule'),
        _liveBanner(context),
        LmsSectionHeader('Continue Learning',
            onSeeAll: () => _push(context, const VideosPage())),
        _continueLearning(),
        LmsSectionHeader('Featured Courses',
            onSeeAll: () => _push(context, const CoursesPage())),
        _courseStrip(context),
      ],
    );
  }

  void _push(BuildContext c, Widget p) =>
      Navigator.of(c).push(MaterialPageRoute(builder: (_) => p));

  Widget _greeting() => const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,',
                    style: TextStyle(
                        color: LmsColors.textSecondary, fontSize: 14)),
                SizedBox(height: 2),
                Text('Harsh Patel 👋',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            LmsPill('🔥 12 day streak', color: Color(0xFFFFF4E5)),
          ],
        ),
      );

  Widget _searchBar(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: LmsColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: LmsColors.divider),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: LmsColors.textSecondary),
              SizedBox(width: 10),
              Text('Search courses, tests, material…',
                  style: TextStyle(
                      color: LmsColors.textSecondary, fontSize: 14)),
              Spacer(),
              Icon(Icons.tune, color: LmsColors.textSecondary),
            ],
          ),
        ),
      );

  Widget _quickActions(BuildContext context) {
    final actions = <_QA>[
      _QA(Icons.podcasts, 'Live', LmsColors.danger,
          () => _push(context, const LiveSchedulePage())),
      _QA(Icons.folder_open, 'Material', LmsColors.accent,
          () => _push(context, const StudyMaterialPage())),
      _QA(Icons.assignment_outlined, 'Tests', LmsColors.primary,
          () => _push(context, const _PerformanceRoute())),
      _QA(Icons.edit_note, 'Homework', LmsColors.purple,
          () => _push(context, const AssignmentsPage())),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final a in actions)
            GestureDetector(
              onTap: a.onTap,
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: a.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(a.icon, color: a.color, size: 26),
                  ),
                  const SizedBox(height: 6),
                  Text(a.label,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: LmsColors.textPrimary)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _liveBanner(BuildContext context) {
    final live = sampleLiveClasses.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _push(context, const LiveSchedulePage()),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [LmsColors.primary, LmsColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.play_arrow,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('● LIVE',
                              style: TextStyle(
                                  color: LmsColors.danger,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(live.time,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(live.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    Text('by ${live.teacher}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _continueLearning() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sampleVideos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final v = sampleVideos[i];
          return SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 96,
                  decoration: BoxDecoration(
                    color: v.thumb.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: v.thumb,
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(v.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text('${v.teacher} • ${v.duration}',
                    style: const TextStyle(
                        color: LmsColors.textSecondary, fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _courseStrip(BuildContext context) {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sampleCourses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final c = sampleCourses[i];
          return Container(
            width: 240,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: LmsColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: LmsColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: c.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.menu_book, color: c.color),
                ),
                const Spacer(),
                Text(c.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(c.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: LmsColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(c.price,
                        style: const TextStyle(
                            color: LmsColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(c.oldPrice,
                        style: const TextStyle(
                          color: LmsColors.textSecondary,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        )),
                    const Spacer(),
                    const Icon(Icons.star,
                        color: LmsColors.warning, size: 15),
                    Text(' ${c.rating}',
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QA {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _QA(this.icon, this.label, this.color, this.onTap);
}

/// PerformancePage is a bare page meant to live inside [MainScaffold]'s
/// Scaffold. When opened as a standalone route (from a quick action) it needs
/// its own Scaffold + AppBar so it has a Material ancestor and a back button.
class _PerformanceRoute extends StatelessWidget {
  const _PerformanceRoute();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance')),
      body: const PerformancePage(),
    );
  }
}
