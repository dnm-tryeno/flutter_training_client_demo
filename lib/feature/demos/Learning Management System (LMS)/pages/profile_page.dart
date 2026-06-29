import 'package:flutter/material.dart';

import '../theme.dart';
import 'attendance_page.dart';
import 'payments_page.dart';

/// Profile management with the reference app's profile sections
/// (Basic, Parent, Personal, Address, Educational details).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_Section>[
      _Section(Icons.badge_outlined, 'Basic Details', 'Name, DOB, gender'),
      _Section(Icons.family_restroom, 'Parent Details', 'Father / mother info'),
      _Section(Icons.person_outline, 'Personal Details', 'Category, language'),
      _Section(Icons.home_outlined, 'Address', 'City, state, pincode'),
      _Section(Icons.school_outlined, 'Educational Details',
          'School, class, stream'),
    ];

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _header(),
        _quickStats(context),
        const LmsSectionHeader('Profile Setup'),
        for (final s in sections) _sectionTile(context, s),
        const LmsSectionHeader('More'),
        _link(context, Icons.payments_outlined, 'Payments & Receipts',
            () => _push(context, const PaymentsPage())),
        _link(context, Icons.fact_check_outlined, 'Attendance',
            () => _push(context, const AttendancePage())),
        _link(context, Icons.settings_outlined, 'Settings', null),
        _link(context, Icons.help_outline, 'Help & Support', null),
        _link(context, Icons.logout, 'Logout', null, danger: true),
      ],
    );
  }

  void _push(BuildContext c, Widget p) =>
      Navigator.of(c).push(MaterialPageRoute(builder: (_) => p));

  Widget _header() => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [LmsColors.primary, LmsColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              child: Text('HP',
                  style: TextStyle(
                      color: LmsColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Harsh Patel',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('+91 98765 43210',
                    style: TextStyle(color: Colors.white70)),
                SizedBox(height: 2),
                Text('UPSC Foundation 2026',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ],
        ),
      );

  Widget _quickStats(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: const [
            Expanded(child: _MiniStat('12', 'Day streak')),
            SizedBox(width: 12),
            Expanded(child: _MiniStat('9', 'Tests taken')),
            SizedBox(width: 12),
            Expanded(child: _MiniStat('78%', 'Attendance')),
          ],
        ),
      );

  Widget _sectionTile(BuildContext context, _Section s) => ListTile(
        leading: CircleAvatar(
          backgroundColor: LmsColors.primary.withValues(alpha: 0.12),
          child: Icon(s.icon, color: LmsColors.primary),
        ),
        title: Text(s.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(s.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${s.title} — demo')),
        ),
      );

  Widget _link(BuildContext context, IconData icon, String label,
          VoidCallback? onTap,
          {bool danger = false}) =>
      ListTile(
        leading: Icon(icon,
            color: danger ? LmsColors.danger : LmsColors.textSecondary),
        title: Text(label,
            style: TextStyle(
                color: danger ? LmsColors.danger : LmsColors.textPrimary,
                fontWeight: FontWeight.w500)),
        trailing: danger ? null : const Icon(Icons.chevron_right),
        onTap: onTap ??
            () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label — demo')),
                ),
      );
}

class _Section {
  final IconData icon;
  final String title;
  final String subtitle;
  _Section(this.icon, this.title, this.subtitle);
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: LmsColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LmsColors.divider),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: LmsColors.primary)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: LmsColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
