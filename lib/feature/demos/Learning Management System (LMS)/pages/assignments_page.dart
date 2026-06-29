import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Assignments / homework with status (pending, submitted, graded).
class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  ({Color color, String label, IconData icon}) _status(AssignmentStatus s) {
    switch (s) {
      case AssignmentStatus.pending:
        return (color: LmsColors.warning, label: 'Pending', icon: Icons.schedule);
      case AssignmentStatus.submitted:
        return (
          color: LmsColors.accent,
          label: 'Submitted',
          icon: Icons.upload_file
        );
      case AssignmentStatus.graded:
        return (
          color: LmsColors.success,
          label: 'Graded',
          icon: Icons.grading
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sampleAssignments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final a = sampleAssignments[i];
          final st = _status(a.status);
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
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: st.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(st.icon, color: st.color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('${a.subject} • ${a.due}',
                          style: const TextStyle(
                              color: LmsColors.textSecondary, fontSize: 12)),
                      const SizedBox(height: 8),
                      LmsPill(st.label, textColor: st.color),
                    ],
                  ),
                ),
                if (a.status == AssignmentStatus.pending)
                  TextButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Open ${a.title}')),
                    ),
                    child: const Text('Submit'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
