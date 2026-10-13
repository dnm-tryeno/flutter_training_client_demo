import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../reports/reports_list_page.dart';
import '../subscription/subscription_plans_page.dart';
import '../for_you/connect_desktop_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('More Options'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Business card header (hardcoded matching screenshot 1000046138)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF10B981),
                  child: Text(
                    'B',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Business Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('GST: 24AAACC1206D1ZM', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Ph: 9198011787', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubscriptionPlansPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEA580C)),
                    foregroundColor: const Color(0xFFEA580C),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Upgrade', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tools list
          _buildItem(
            context,
            icon: Icons.star_border_purple500_rounded,
            iconColor: const Color(0xFFEA580C),
            title: 'Subscription Plans',
            subtitle: 'Try Plus plan for 7 days at ₹2',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SubscriptionPlansPage()),
              );
            },
          ),
          _buildItem(
            context,
            icon: Icons.assessment_outlined,
            iconColor: AppColors.primary,
            title: 'All Reports & GST Filings',
            subtitle: 'GSTR-1, P&L, Balance Sheet, Daybook',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReportsListPage()),
              );
            },
          ),
          _buildItem(
            context,
            icon: Icons.computer,
            iconColor: const Color(0xFF0284C7),
            title: 'Connect to Computer',
            subtitle: 'Sync real-time with desktop & thermal printer',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ConnectDesktopPage()),
              );
            },
          ),
          _buildItem(
            context,
            icon: Icons.badge_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'Staff & Attendance Management',
            subtitle: 'Track salesman live location & check-ins',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Staff Attendance portal opened')),
              );
            },
          ),
          _buildItem(
            context,
            icon: Icons.settings_outlined,
            iconColor: AppColors.textSecondary,
            title: 'Settings & Invoice Templates',
            subtitle: 'Print header, logo, signature & UPI QR code',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice template customizer ready')),
              );
            },
          ),
          _buildItem(
            context,
            icon: Icons.headset_mic_outlined,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Help & 24/7 Support',
            subtitle: 'Chat with billing specialists on WhatsApp',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connecting to myBillBook Customer Support...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
            onTap: onTap,
          ),
          const Divider(height: 1, indent: 64, color: AppColors.divider),
        ],
      ),
    );
  }
}
