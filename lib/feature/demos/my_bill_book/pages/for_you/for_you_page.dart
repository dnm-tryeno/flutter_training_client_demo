import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'whatsapp_marketing_page.dart';
import 'reward_points_page.dart';
import 'online_store_page.dart';
import 'automated_bills_page.dart';
import 'ca_sharing_page.dart';
import 'connect_desktop_page.dart';
import 'e_invoice_page.dart';
import '../subscription/subscription_plans_page.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  void _showTallyExportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MOVE DATA WITHOUT RE-ENTRY',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Text(
              'Export your business data to Tally',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Create a Tally-compatible export of your myBillBook records for accounting and CA review.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            _buildCheckItem('Export sales, purchases, parties and items'),
            _buildCheckItem('Choose the date range your accountant needs'),
            _buildCheckItem('Avoid entering the same records again in Tally'),
            const SizedBox(height: 20),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹6840 / year', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Billed yearly • Cancel anytime', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubscriptionPlansPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  child: const Text('Talk to Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'STAY ORGANISED',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Text(
              'Manage appointments and share them on WhatsApp',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Save important details, schedule appointments, and send appointment information to customers on WhatsApp.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            _buildCheckItem('Record important customer and business notes'),
            _buildCheckItem('Schedule appointments and follow-ups easily'),
            _buildCheckItem('Share appointment details with customers on WhatsApp'),
            const SizedBox(height: 20),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹2 for First 7 Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('then ₹199 every month', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubscriptionPlansPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9333EA)),
                  child: const Text('Upgrade Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('For You ✨'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Features designed specially for your business',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Recommended for you cards
            const Text(
              'Recommended for you',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            // Horizontal Carousel cards
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPromoCard(
                    context,
                    title: 'Export data to Tally',
                    subtitle: 'Direct XML accounting export',
                    gradient: const [Color(0xFF0D9488), Color(0xFF115E59)],
                    icon: Icons.account_balance_wallet,
                    onTap: () => _showTallyExportModal(context),
                  ),
                  const SizedBox(width: 12),
                  _buildPromoCard(
                    context,
                    title: 'Manage Appointments',
                    subtitle: 'Share bookings on WhatsApp',
                    gradient: const [Color(0xFF9333EA), Color(0xFF6B21A8)],
                    icon: Icons.calendar_month,
                    onTap: () => _showAppointmentModal(context),
                  ),
                  const SizedBox(width: 12),
                  _buildPromoCard(
                    context,
                    title: 'Sync on Computer',
                    subtitle: 'Real-time multi-device sync',
                    gradient: const [Color(0xFF4338CA), Color(0xFF312E81)],
                    icon: Icons.computer,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ConnectDesktopPage()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Marketing & Sales Tools Grid
            const Text(
              'Marketing & Sales Tools',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context,
              icon: Icons.chat_outlined,
              iconColor: const Color(0xFF25D366),
              title: 'WhatsApp Marketing',
              subtitle: 'Send festive greetings, offers and updates',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WhatsappMarketingPage()),
                );
              },
            ),
            _buildActionTile(
              context,
              icon: Icons.storefront_outlined,
              iconColor: const Color(0xFFEA580C),
              title: 'Create Your Online Store',
              subtitle: 'Take online orders on website and mobile app',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnlineStorePage()),
                );
              },
            ),
            _buildActionTile(
              context,
              icon: Icons.loyalty_outlined,
              iconColor: const Color(0xFF6366F1),
              title: 'Reward Points',
              subtitle: 'Reward loyalty and grow repetitive business',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RewardPointsPage()),
                );
              },
            ),

            const SizedBox(height: 24),

            // Automation & Compliance Tools
            const Text(
              'Automation & Compliance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context,
              icon: Icons.replay_circle_filled_outlined,
              iconColor: const Color(0xFF0284C7),
              title: 'Automated Bills',
              subtitle: 'Generate repeated invoices automatically',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AutomatedBillsPage()),
                );
              },
            ),
            _buildActionTile(
              context,
              icon: Icons.supervisor_account_outlined,
              iconColor: const Color(0xFF059669),
              title: 'CA Reports Sharing',
              subtitle: 'Auto-share monthly reports on 1st of every month',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CaSharingPage()),
                );
              },
            ),
            _buildActionTile(
              context,
              icon: Icons.qr_code_2,
              iconColor: const Color(0xFFD97706),
              title: 'e-Invoice Generation',
              subtitle: 'Govt NIC IRN and QR code enabled invoicing',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EInvoicePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          onTap: onTap,
        ),
      ),
    );
  }
}
