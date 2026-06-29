import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Batches the learner is enrolled in, with progress.
class BatchesPage extends StatelessWidget {
  const BatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        const Text('My Batches',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Continue where you left off',
            style: TextStyle(color: LmsColors.textSecondary)),
        const SizedBox(height: 16),
        for (final b in sampleBatches) ...[
          _batchCard(b),
          const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _batchCard(Batch b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LmsColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LmsColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: b.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(b.icon, color: b.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(b.description,
                        style: const TextStyle(
                            color: LmsColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('${(b.progress * 100).round()}% complete',
                  style: TextStyle(
                      color: b.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
              const Spacer(),
              Text('${b.students} students',
                  style: const TextStyle(
                      color: LmsColors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: b.progress,
              minHeight: 8,
              backgroundColor: LmsColors.background,
              valueColor: AlwaysStoppedAnimation(b.color),
            ),
          ),
        ],
      ),
    );
  }
}
