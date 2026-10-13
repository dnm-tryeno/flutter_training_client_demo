import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../dashboard/refer_and_earn_page.dart';

class SharedLedgersPage extends StatefulWidget {
  const SharedLedgersPage({super.key});

  @override
  State<SharedLedgersPage> createState() => _SharedLedgersPageState();
}

class _SharedLedgersPageState extends State<SharedLedgersPage> {
  String _activeTab = 'To Pay';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SharedLedgers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: AppColors.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabChip('To Pay'),
                const SizedBox(width: 8),
                _buildTabChip('To Collect'),
              ],
            ),
          ),
          const Spacer(),

          // Empty state cards illustration
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMockItem(isUp: true),
                      const SizedBox(height: 10),
                      _buildMockItem(isUp: false),
                      const SizedBox(height: 10),
                      _buildMockItem(isUp: true),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'No SharedLedgers Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Ask your parties to join myBillBook — once they record transactions, their SharedLedgers will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReferAndEarnPage()),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.card_giftcard, color: AppColors.primary, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Refer Now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label) {
    final isSelected = _activeTab == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _activeTab = label);
      },
      selectedColor: AppColors.purpleLightBg,
      backgroundColor: const Color(0xFFF3F4F6),
      labelStyle: TextStyle(
        fontSize: 13,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildMockItem({required bool isUp}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFFED7AA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.arrow_right, size: 16, color: Color(0xFFC2410C)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 6, width: 80, color: const Color(0xFFE5E7EB)),
                const SizedBox(height: 4),
                Container(height: 5, width: 45, color: const Color(0xFFF3F4F6)),
              ],
            ),
          ),
          Icon(
            isUp ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: isUp ? AppColors.red : AppColors.green,
          ),
        ],
      ),
    );
  }
}
