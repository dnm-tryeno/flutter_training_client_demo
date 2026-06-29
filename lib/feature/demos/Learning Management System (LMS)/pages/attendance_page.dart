import 'package:flutter/material.dart';

import '../theme.dart';

/// Attendance summary + a simple month calendar grid (present/absent/leave).
class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 0 = none, 1 = present, 2 = absent, 3 = leave/holiday
    const days = <int>[
      0, 0, 1, 1, 1, 2, 3, //
      1, 1, 1, 1, 2, 1, 3, //
      1, 1, 2, 1, 1, 1, 3, //
      1, 1, 1, 1, 1, 2, 3, //
      1, 1,
    ];

    Color cellColor(int v) {
      switch (v) {
        case 1:
          return LmsColors.success;
        case 2:
          return LmsColors.danger;
        case 3:
          return LmsColors.warning.withValues(alpha: 0.5);
        default:
          return LmsColors.background;
      }
    }

    final present = days.where((d) => d == 1).length;
    final absent = days.where((d) => d == 2).length;
    final total = present + absent;
    final pct = total == 0 ? 0 : (present / total * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _stat('$pct%', 'Overall', LmsColors.primary)),
              const SizedBox(width: 12),
              Expanded(
                  child: _stat('$present', 'Present', LmsColors.success)),
              const SizedBox(width: 12),
              Expanded(child: _stat('$absent', 'Absent', LmsColors.danger)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LmsColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: LmsColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('June 2026',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _Dow('S'),
                    _Dow('M'),
                    _Dow('T'),
                    _Dow('W'),
                    _Dow('T'),
                    _Dow('F'),
                    _Dow('S'),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (_, i) {
                    final v = days[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: cellColor(v),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text('${i + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: v == 0
                                ? LmsColors.textSecondary
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    );
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    _Legend(LmsColors.success, 'Present'),
                    SizedBox(width: 16),
                    _Legend(LmsColors.danger, 'Absent'),
                    SizedBox(width: 16),
                    _Legend(LmsColors.warning, 'Holiday'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: LmsColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LmsColors.divider),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: LmsColors.textSecondary, fontSize: 12)),
          ],
        ),
      );
}

class _Dow extends StatelessWidget {
  final String d;
  const _Dow(this.d);
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 28,
        child: Text(d,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: LmsColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      );
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend(this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: LmsColors.textSecondary, fontSize: 12)),
        ],
      );
}
