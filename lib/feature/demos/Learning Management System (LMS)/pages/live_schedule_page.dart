import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Live class schedule for the day.
class LiveSchedulePage extends StatelessWidget {
  const LiveSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Schedule')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sampleLiveClasses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final c = sampleLiveClasses[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LmsColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: c.isLive ? LmsColors.danger : LmsColors.divider,
                width: c.isLive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: (c.isLive ? LmsColors.danger : LmsColors.primary)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(c.isLive ? Icons.sensors : Icons.schedule,
                      color: c.isLive ? LmsColors.danger : LmsColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (c.isLive)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: LmsColors.danger,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('● LIVE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          Text(c.time,
                              style: const TextStyle(
                                  color: LmsColors.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(c.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${c.subject} • ${c.teacher}',
                          style: const TextStyle(
                              color: LmsColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        c.isLive ? LmsColors.danger : LmsColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Joining ${c.title}…')),
                  ),
                  child: Text(c.isLive ? 'Join' : 'Remind'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
