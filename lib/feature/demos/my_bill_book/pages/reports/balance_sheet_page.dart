import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class BalanceSheetPage extends StatefulWidget {
  const BalanceSheetPage({super.key});

  @override
  State<BalanceSheetPage> createState() => _BalanceSheetPageState();
}

class _BalanceSheetPageState extends State<BalanceSheetPage> {
  int _tabIndex = 0; // 0 = Liabilities, 1 = Assets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Balance Sheet (As of Today)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_view_outlined, color: Color(0xFF10B981)),
            tooltip: 'Export Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading BalanceSheet.xlsx...')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Yellow update note (screenshot 1000046151)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFFEFCE8),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Color(0xFF854D0E)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Balance sheet is updated once per day. Last updated at: 12 Oct 2026, 10:39 am',
                    style: TextStyle(fontSize: 12, color: Color(0xFF854D0E)),
                  ),
                ),
              ],
            ),
          ),

          // Tabs: Liabilities vs Assets
          Row(
            children: [
              _buildTab('Liabilities', 0),
              _buildTab('Assets', 1),
            ],
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          Expanded(
            child: _tabIndex == 0
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    children: [
                      _buildRow('Capital', '₹ 0'),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildRow('Current Liability', '₹ 0'),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: [
                            _buildSubRow('Tax Payable', '₹ 0'),
                            _buildSubRow('Tcs Payable', '₹ 0'),
                            _buildSubRow('Tds Payable', '₹ 0'),
                            _buildSubRow('Account Payable', '₹ 0'),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildRow('Loans', '₹ 0'),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildRow('Net Income', '₹ 23,560'),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    children: [
                      _buildRow('Current Assets', '₹ 23,560'),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: [
                            _buildSubRow('Cash in Hand', '₹ 15,000'),
                            _buildSubRow('Bank Balance', '₹ 8,560'),
                            _buildSubRow('Sundry Debtors', '₹ 14,500'),
                            _buildSubRow('Closing Stock', '₹ 23,560'),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildRow('Fixed Assets', '₹ 0'),
                    ],
                  ),
          ),

          // Floating Entry Button
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom Journal / Ledger entry created')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('+ Create New Entry', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          // Dark purple bottom bar: Total Liabilities
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: const Color(0xFF312E81),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _tabIndex == 0 ? 'Total Liabilities' : 'Total Assets',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '₹ 23,560',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(width: 6),
              const Icon(Icons.info_outline, size: 15, color: AppColors.textMuted),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSubRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(amount, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
