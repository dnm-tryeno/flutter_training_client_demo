import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/item_model.dart';

class ItemDetailsPage extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int _tabIndex = 0; // 0 = Item Timeline, 1 = Details, 2 = Party Wise Prices
  late ItemModel _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  void _showAdjustStockDialog(BuildContext context) {
    final stockController = TextEditingController(text: _currentItem.stockQuantity.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Adjust Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item: ${_currentItem.name}'),
            const SizedBox(height: 12),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Stock (${_currentItem.unit})',
                suffixText: _currentItem.unit,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = double.tryParse(stockController.text.trim()) ?? _currentItem.stockQuantity;
              setState(() {
                _currentItem = _currentItem.copyWith(stockQuantity: newStock);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stock updated to $newStock ${_currentItem.unit}')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing item details...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit item configuration')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.red),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cannot delete sample item')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Report Link + S Thumbnail (screenshot 1000046145)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentItem.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Opening report for ${_currentItem.name}')),
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View Item Report',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _currentItem.name.isNotEmpty ? _currentItem.name[0].toUpperCase() : 'I',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Metrics Row: Sales Price | Purchase Price | Stock Quantity (screenshot 1000046145)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricColumn(
                        'Sales Price',
                        '₹ ${_currentItem.salesPrice.toStringAsFixed(0)}',
                        'Without Tax',
                      ),
                      _buildMetricColumn(
                        'Purchase Price',
                        '₹ ${_currentItem.purchasePrice.toStringAsFixed(0)}',
                        'Without Tax',
                      ),
                      _buildMetricColumn(
                        'Stock Quantity',
                        '${_currentItem.stockQuantity} ${_currentItem.unit}',
                        '',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Stock Value with ⓘ (₹ 23,560)
                  const Row(
                    children: [
                      Text(
                        'Stock Value',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '₹ 23,560',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Manage Inventory By
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Manage Inventory By',
                        style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentItem.inventoryTracking,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tabs: [Item Timeline], [Details], [Party Wise Prices]
                  Row(
                    children: [
                      _buildTab('Item Timeline', 0),
                      _buildTab('Details', 1),
                      _buildTab('Party Wise Prices', 2),
                    ],
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 16),

                  if (_tabIndex == 0) ...[
                    // Item Timeline Entry (screenshot 1000046145)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Opening Stock',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_currentItem.stockQuantity} ${_currentItem.unit}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_currentItem.stockQuantity} ${_currentItem.unit}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else if (_tabIndex == 1) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('HSN Code'),
                      trailing: Text(_currentItem.hsn ?? 'None', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('GST Tax Rate'),
                      trailing: Text(_currentItem.gstRate, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No party-wise custom pricing assigned yet.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom button: Adjust Stock
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: ElevatedButton(
              onPressed: () => _showAdjustStockDialog(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Adjust Stock', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        if (sub.isNotEmpty)
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
