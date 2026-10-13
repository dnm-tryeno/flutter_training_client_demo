import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'balance_sheet_page.dart';
import 'gstr1_report_page.dart';

class ReportsListPage extends StatelessWidget {
  const ReportsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Section: Popular
          _buildSectionHeader('Popular'),
          _buildReportTile(
            context,
            icon: Icons.receipt_long_outlined,
            title: 'Bill wise profit',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Displaying Bill Wise Gross Profit margin...')),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.currency_rupee,
            title: 'Sales Summary',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Monthly & Daily Sales Summary generated')),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.menu_book_outlined,
            title: 'Daybook',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Daybook of all daily vouchers and cash flows')),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.trending_up,
            title: 'Profit and Loss',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('P&L Statement: Trading, Operating & Net Profit')),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.contact_page_outlined,
            title: 'Party Statement (Ledger)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Party Statement & Ledger export')),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Stock Summary',
            subtitle: 'A summary of price & stock of all items',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening stock, closing stock and valuation report')),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.balance_outlined,
            title: 'Balance Sheet',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BalanceSheetPage()),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.account_balance_outlined,
            title: 'Cash and Bank (All Payments)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cash in hand & Bank accounts reconciliation')),
              );
            },
          ),

          const SizedBox(height: 16),

          // Section: More
          _buildSectionHeader('More'),
          _buildReportTile(
            context,
            icon: Icons.people_outline,
            title: 'Party Reports',
            onTap: () {},
          ),
          _buildReportTile(
            context,
            icon: Icons.category_outlined,
            title: 'Item Reports',
            onTap: () {},
          ),
          _buildReportTile(
            context,
            icon: Icons.percent_outlined,
            title: 'GST Reports',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const Gstr1ReportPage()),
              );
            },
          ),
          _buildReportTile(
            context,
            icon: Icons.swap_horiz_outlined,
            title: 'Transaction Reports',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildReportTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: AppColors.primary, size: 22),
            title: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
            subtitle: subtitle != null
                ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))
                : null,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
            onTap: onTap,
          ),
          const Divider(height: 1, indent: 56, color: AppColors.divider),
        ],
      ),
    );
  }
}
