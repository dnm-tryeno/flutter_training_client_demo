import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';
import '../widgets/charts.dart';

/// Performance analytics — modeled directly on the reference "educator"
/// dashboard: a Learner Deep Dive header card, score trend line chart,
/// subject-wise bars, and recent test attempts.
class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _deepDiveCard(),
        const SizedBox(height: 16),
        _statsRow(),
        const SizedBox(height: 16),
        _card(
          title: 'Student Score Trend',
          child: ScoreTrendChart(
            values: scoreTrend,
            labels: scoreTrendLabels,
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: 'Subject-wise Performance',
          child: const SubjectBarChart(data: subjectScores),
        ),
        const SizedBox(height: 16),
        _recentAttempts(),
      ],
    );
  }

  Widget _deepDiveCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B6CFF), Color(0xFF6A4CF0)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: const Text('R',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Rishit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text('skylord@gmail.com',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _GlassPill('Joined May 2'),
              _GlassPill('Last seen May 29'),
              _GlassPill('ACTIVE'),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Learner Deep Dive — detailed analytics and progress for this learner.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: const [
        Expanded(
            child: _StatTile(label: 'Attempts', value: '9', sub: '9 completed')),
        SizedBox(width: 12),
        Expanded(
            child: _StatTile(
                label: 'Completed Tests',
                value: '9',
                sub: '0 pending/incomplete')),
        SizedBox(width: 12),
        Expanded(
            child: _StatTile(
                label: 'Avg. Score', value: '52%', sub: 'across tests')),
      ],
    );
  }

  Widget _card({required String title, required Widget child}) {
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
          Text(title,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _recentAttempts() {
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
          const Text('Recent Attempts',
              style:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (final a in sampleAttempts) _attemptTile(a),
        ],
      ),
    );
  }

  Widget _attemptTile(TestAttempt a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LmsColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LmsColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(a.name,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text('${a.subject} • ${a.date}',
              style: const TextStyle(
                  color: LmsColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              const LmsPill('submitted',
                  icon: Icons.check, textColor: LmsColors.primary),
              const SizedBox(width: 8),
              LmsPill('${a.score}/${a.total}',
                  color: LmsColors.primary.withValues(alpha: 0.1),
                  textColor: LmsColors.primary),
              const SizedBox(width: 8),
              LmsPill(a.duration, icon: Icons.timer_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  final String text;
  const _GlassPill(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _StatTile(
      {required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LmsColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LmsColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 2,
              style: const TextStyle(
                  color: LmsColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub,
              maxLines: 2,
              style: const TextStyle(
                  color: LmsColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}
