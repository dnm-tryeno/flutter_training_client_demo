import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Free study material — downloadable PDF/DOC/PPT resources.
class StudyMaterialPage extends StatelessWidget {
  const StudyMaterialPage({super.key});

  Color _typeColor(String type) {
    switch (type) {
      case 'PDF':
        return LmsColors.danger;
      case 'DOC':
        return LmsColors.accent;
      default:
        return LmsColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free Study Material')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sampleMaterials.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final m = sampleMaterials[i];
          final color = _typeColor(m.type);
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: LmsColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: LmsColors.divider),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.description, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('${m.subject} • ${m.type} • ${m.size}',
                          style: const TextStyle(
                              color: LmsColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined,
                      color: LmsColors.primary),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading ${m.title}…')),
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
