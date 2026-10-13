import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/item_model.dart';
import 'create_item_page.dart';
import 'item_details_page.dart';
import 'bulk_upload_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String _selectedCategory = 'All';

  final List<ItemModel> _hardcodedItems = [
    ItemModel(
      id: 'item-1',
      name: 'Sample Item',
      hsn: '8471',
      type: ItemType.product,
      salesPrice: 220.0,
      purchasePrice: 190.0,
      stockQuantity: 124.0,
      unit: 'BOX',
      gstRate: 'None',
      inventoryTracking: 'IMEI/Serial No',
    ),
    ItemModel(
      id: 'item-2',
      name: 'Kissan Fruit Jam 500 gm',
      hsn: '2007',
      type: ItemType.product,
      salesPrice: 130.0,
      purchasePrice: 115.0,
      stockQuantity: 45.0,
      unit: 'PCS',
      gstRate: '12%',
      inventoryTracking: 'Standard',
    ),
    ItemModel(
      id: 'item-3',
      name: 'Fortune Kachi Ghani 1L',
      hsn: '1514',
      type: ItemType.product,
      salesPrice: 175.0,
      purchasePrice: 155.0,
      stockQuantity: 60.0,
      unit: 'PCS',
      gstRate: '5%',
      inventoryTracking: 'Standard',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
            tooltip: 'Barcode Scanner',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.upload_file_outlined, color: AppColors.primary),
            tooltip: 'Upload items in bulk',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BulkUploadPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category Selector Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildCategoryTab('All'),
                const SizedBox(width: 8),
                _buildCategoryTab('Products'),
                const SizedBox(width: 8),
                _buildCategoryTab('Services'),
              ],
            ),
          ),

          // Total Stock Value Summary Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Stock Value', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    SizedBox(height: 2),
                    Text(
                      '₹ 23,560',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
                Text(
                  '3 Items Listed',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: _hardcodedItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _hardcodedItems[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ItemDetailsPage(item: item),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.purpleLightBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.name.isNotEmpty ? item.name[0].toUpperCase() : 'I',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Sale: ₹ ${item.salesPrice.toStringAsFixed(0)} • Pur: ₹ ${item.purchasePrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.stockQuantity} ${item.unit}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹ ${item.stockValue.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateItemPage()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCategoryTab(String cat) {
    final isSelected = _selectedCategory == cat;
    return ChoiceChip(
      label: Text(cat),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedCategory = cat);
      },
      selectedColor: AppColors.purpleLightBg,
      backgroundColor: const Color(0xFFF3F4F6),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
