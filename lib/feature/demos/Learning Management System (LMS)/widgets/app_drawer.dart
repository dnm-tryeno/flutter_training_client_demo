import 'package:flutter/material.dart';

import '../pages/assignments_page.dart';
import '../pages/attendance_page.dart';
import '../pages/courses_page.dart';
import '../pages/live_schedule_page.dart';
import '../pages/notifications_page.dart';
import '../pages/payments_page.dart';
import '../pages/study_material_page.dart';
import '../pages/videos_page.dart';
import '../theme.dart';

/// Side navigation drawer modeled on the reference app's hamburger menu.
class LmsDrawer extends StatelessWidget {
  const LmsDrawer({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = <_DrawerItem>[
      _DrawerItem(Icons.podcasts, 'Live Schedule', () => _open(context, const LiveSchedulePage())),
      _DrawerItem(Icons.folder_open, 'Free Study Material', () => _open(context, const StudyMaterialPage())),
      _DrawerItem(Icons.play_circle_outline, 'Videos', () => _open(context, const VideosPage())),
      _DrawerItem(Icons.menu_book, 'Courses', () => _open(context, const CoursesPage())),
      _DrawerItem(Icons.assignment_outlined, 'Assignments', () => _open(context, const AssignmentsPage())),
      _DrawerItem(Icons.fact_check_outlined, 'Attendance', () => _open(context, const AttendancePage())),
      _DrawerItem(Icons.payments_outlined, 'Payments', () => _open(context, const PaymentsPage())),
      _DrawerItem(Icons.notifications_none, 'Notifications', () => _open(context, const NotificationsPage())),
    ];

    final secondary = <_DrawerItem>[
      _DrawerItem(Icons.help_outline, 'Help & Support', () => Navigator.pop(context)),
      _DrawerItem(Icons.settings_outlined, 'Settings', () => Navigator.pop(context)),
      _DrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () => Navigator.pop(context)),
    ];

    return Drawer(
      backgroundColor: LmsColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [LmsColors.primary, LmsColors.primaryDark],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Text('HP',
                            style: TextStyle(
                              color: LmsColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Harsh Patel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(height: 2),
                          Text('+91 98765 43210',
                              style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'All-in-one platform for your learning',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final i in items) _tile(i),
                  const Divider(height: 1),
                  for (final i in secondary) _tile(i),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: LmsColors.danger),
              title: const Text('Logout',
                  style: TextStyle(color: LmsColors.danger, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(_DrawerItem i) => ListTile(
        leading: Icon(i.icon, color: LmsColors.textSecondary),
        title: Text(i.label,
            style: const TextStyle(
              color: LmsColors.textPrimary,
              fontWeight: FontWeight.w500,
            )),
        onTap: i.onTap,
      );
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _DrawerItem(this.icon, this.label, this.onTap);
}
