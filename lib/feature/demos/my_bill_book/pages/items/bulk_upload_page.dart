import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class BulkUploadPage extends StatelessWidget {
  const BulkUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload items in bulk'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Section: Edit Items in Bulk
          _buildSectionHeader('Edit Items in Bulk'),
          _buildTile(
            context,
            icon: Icons.percent_rounded,
            title: 'Edit Bulk GST Tax Rate',
            subtitle: 'Quickly update GST rate for multiple items',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bulk GST Tax Rate updater opened')),
              );
            },
          ),

          const SizedBox(height: 16),

          // Section: Upload your items list
          _buildSectionHeader('Upload your items list'),
          _buildTile(
            context,
            icon: Icons.document_scanner_outlined,
            title: 'Scan & Add Item',
            subtitle: 'Instantly add items from bill image or PDF',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening AI invoice item scanner...')),
              );
            },
          ),
          _buildTile(
            context,
            icon: Icons.table_chart_outlined,
            title: 'Excel(.xlsx) file',
            subtitle: 'Upload your item list in xlsx format',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select an Excel (.xlsx) file to import')),
              );
            },
          ),
          _buildTile(
            context,
            icon: Icons.library_books_outlined,
            title: 'Items Library',
            subtitle: 'Add items from our database of 1 lakh+ items',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Searching pre-populated FMCG & Pharma item catalog...')),
              );
            },
          ),

          const SizedBox(height: 16),

          // Section: Import your items from other software
          _buildSectionHeader('Import your items from other software'),
          _buildSimpleTile(
            context,
            icon: Icons.change_circle_outlined,
            title: 'Vyapar app',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vyapar data backup importer ready')),
              );
            },
          ),
          _buildSimpleTile(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Tally',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tally XML master data importer ready')),
              );
            },
          ),
          _buildSimpleTile(
            context,
            icon: Icons.apps_outlined,
            title: 'Busy, Marg, Miracle or Others',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Custom software migration wizard ready')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.purpleLightBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSimpleTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        onTap: onTap,
      ),
    );
  }
}
