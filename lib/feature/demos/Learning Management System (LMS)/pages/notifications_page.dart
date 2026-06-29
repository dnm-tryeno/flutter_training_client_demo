import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Notification centre.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sampleNotifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (_, i) {
          final n = sampleNotifications[i];
          return Container(
            color: n.unread
                ? LmsColors.primary.withValues(alpha: 0.04)
                : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: n.color.withValues(alpha: 0.12),
                child: Icon(n.icon, color: n.color),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(n.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                  ),
                  if (n.unread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: LmsColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(n.body),
              ),
              trailing: Text(n.time,
                  style: const TextStyle(
                      color: LmsColors.textSecondary, fontSize: 11)),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
