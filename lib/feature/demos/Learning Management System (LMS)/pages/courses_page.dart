import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Paid courses catalogue.
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sampleCourses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final c = sampleCourses[i];
          return Container(
            decoration: BoxDecoration(
              color: LmsColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: LmsColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c.color, c.color.withValues(alpha: 0.6)],
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book,
                        color: Colors.white, size: 44),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 2),
                      Text(c.subtitle,
                          style: const TextStyle(
                              color: LmsColors.textSecondary)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.play_lesson_outlined,
                              size: 16, color: LmsColors.textSecondary),
                          Text(' ${c.lessons} lessons',
                              style: const TextStyle(
                                  color: LmsColors.textSecondary,
                                  fontSize: 13)),
                          const SizedBox(width: 14),
                          const Icon(Icons.star,
                              size: 16, color: LmsColors.warning),
                          Text(' ${c.rating}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(c.price,
                              style: const TextStyle(
                                  color: LmsColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(c.oldPrice,
                              style: const TextStyle(
                                color: LmsColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              )),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LmsColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Enrolling in ${c.title}…')),
                            ),
                            child: const Text('Buy now'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
