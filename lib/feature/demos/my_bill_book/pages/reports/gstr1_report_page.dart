import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class Gstr1ReportPage extends StatefulWidget {
  const Gstr1ReportPage({super.key});

  @override
  State<Gstr1ReportPage> createState() => _Gstr1ReportPageState();
}

class _Gstr1ReportPageState extends State<Gstr1ReportPage> {
  bool _showCaBanner = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('GSTR-1(sales)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFFEF4444)),
            tooltip: 'PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting GSTR-1 as PDF...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_view_outlined, color: Color(0xFF10B981)),
            tooltip: 'Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting GSTR-1 as Excel (.xlsx)...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.code_rounded, color: Color(0xFF3B82F6)),
            tooltip: 'JSON for Govt Portal',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting GSTR-1 JSON for GST Portal upload...')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date selector bar (screenshot 1000046150)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 20, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Last Month  01 Sept 2026 - 30 Sept 2026',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('CHANGE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Yellow helper banner
            if (_showCaBanner)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFCE8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Now you can automatically share the reports to your CA',
                        style: TextStyle(fontSize: 12, color: Color(0xFF854D0E), fontWeight: FontWeight.w500),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Color(0xFFCA8A04)),
                      ),
                      child: const Text('Try Now', style: TextStyle(fontSize: 12, color: Color(0xFF854D0E))),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => setState(() => _showCaBanner = false),
                      child: const Icon(Icons.close, size: 16, color: Color(0xFF854D0E)),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Header summary (hardcoded matching screenshot 1000046150)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GSTR-1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Business Name', style: TextStyle(fontSize: 13)),
                  Text('Mobile: 9198011787', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('GST No:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Date Range: 01/09/2026 to 30/09/2026', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sales Table
            const Text('Sales', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            _buildGstTable([
              ['24AAACC1206D1ZM', 'Customer Name', 'Gujarat', 'INV-001', '18%', '₹ 12,288', '₹ 2,212'],
            ]),

            const SizedBox(height: 20),

            // Sales Return Table
            const Text('Sales Return', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            _buildEmptyGstSection('No sales returns in this period'),

            const SizedBox(height: 20),

            // Purchase Return Table
            const Text('Purchase Return', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            _buildEmptyGstSection('No purchase returns in this period'),
          ],
        ),
      ),
    );
  }

  Widget _buildGstTable(List<List<String>> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
        dataTextStyle: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
        columns: const [
          DataColumn(label: Text('GSTIN')),
          DataColumn(label: Text('Customer Name')),
          DataColumn(label: Text('Place of Supply')),
          DataColumn(label: Text('Invoice No.')),
          DataColumn(label: Text('Tax %')),
          DataColumn(label: Text('Taxable Value')),
          DataColumn(label: Text('Tax Amount')),
        ],
        rows: rows.map((r) {
          return DataRow(
            cells: r.map((c) => DataCell(Text(c))).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyGstSection(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Center(
        child: Text(msg, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ),
    );
  }
}
