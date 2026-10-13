import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SortFilterSheet extends StatefulWidget {
  const SortFilterSheet({super.key});

  @override
  State<SortFilterSheet> createState() => _SortFilterSheetState();
}

class _SortFilterSheetState extends State<SortFilterSheet> {
  String _selectedSort = 'A-Z';
  String _selectedCategory = 'Customer';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (screenshot 1000046141)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sort By Row + CLEAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSort = 'A-Z';
                    _selectedCategory = 'Customer';
                  });
                },
                child: const Text(
                  'CLEAR',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          // Radio options
          _buildRadioOption('Party name - A to Z', 'A-Z', Icons.sort_by_alpha),
          _buildRadioOption('Party name - Z to A', 'Z-A', Icons.sort_by_alpha),
          _buildRadioOption('Amount - High to Low', 'High-Low', Icons.arrow_downward),
          _buildRadioOption('Amount - Low to High', 'Low-High', Icons.arrow_upward),

          const SizedBox(height: 16),

          // Filter By
          const Text(
            'Filter By',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Filter Pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('Customer'),
              _buildCategoryChip('Supplier'),
              _buildCategoryChip('New Customers'),
              _buildCategoryChip('Old Customers'),
              _buildCategoryChip('Active Customer'),
              _buildCategoryChip('Inactive Customer'),
            ],
          ),

          const SizedBox(height: 24),

          // Apply Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Apply', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, String value, IconData icon) {
    return InkWell(
      onTap: () => setState(() => _selectedSort = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedSort,
              activeColor: AppColors.primary,
              onChanged: (val) {
                if (val != null) setState(() => _selectedSort = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    final isSelected = _selectedCategory == title;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedCategory = title);
      },
      selectedColor: AppColors.purpleLightBg,
      backgroundColor: const Color(0xFFF3F4F6),
      labelStyle: TextStyle(
        fontSize: 13,
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
}
