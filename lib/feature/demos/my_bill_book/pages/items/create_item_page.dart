import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/item_model.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _nameController = TextEditingController();
  final _hsnController = TextEditingController();
  final _salesPriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _discountController = TextEditingController(text: '0');

  ItemType _itemType = ItemType.product;
  int _tabIndex = 0; // 0 = Pricing, 1 = Stock, 2 = Other, 3 = Party Wise Prices
  String _selectedUnit = 'PCS';
  String _selectedGst = 'None';
  final String _selectedTracking = 'IMEI/Serial No';

  final List<String> _units = ['PCS', 'BOX', 'KG', 'MTR', 'LITRE', 'BAG'];
  final List<String> _gstRates = ['None', '5%', '12%', '18%', '28%'];

  @override
  void dispose() {
    _nameController.dispose();
    _hsnController.dispose();
    _salesPriceController.dispose();
    _purchasePriceController.dispose();
    _openingStockController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _saveItem(BuildContext context, {bool saveAndNew = false}) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Item Name')),
      );
      return;
    }

    if (saveAndNew) {
      _nameController.clear();
      _hsnController.clear();
      _salesPriceController.clear();
      _purchasePriceController.clear();
      _openingStockController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item saved! Add next item:')),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item "${_nameController.text.trim()}" saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create New Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            onPressed: () {},
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
                  // Item Name * (screenshot 1000046143)
                  const Text('Item Name *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Kissan Fruit Jam 500 gm',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // HSN & Item Type Row
                  Row(
                    children: [
                      // HSN
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('HSN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _hsnController,
                              decoration: const InputDecoration(
                                hintText: 'Ex: 6704',
                                suffixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Item Type (Product / Service)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Item Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Center(child: Text('Product')),
                                    selected: _itemType == ItemType.product,
                                    onSelected: (val) {
                                      if (val) setState(() => _itemType = ItemType.product);
                                    },
                                    selectedColor: AppColors.purpleLightBg,
                                    backgroundColor: const Color(0xFFF3F4F6),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _itemType == ItemType.product ? FontWeight.bold : FontWeight.normal,
                                      color: _itemType == ItemType.product ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: _itemType == ItemType.product ? AppColors.primary : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Center(child: Text('Service')),
                                    selected: _itemType == ItemType.service,
                                    onSelected: (val) {
                                      if (val) setState(() => _itemType = ItemType.service);
                                    },
                                    selectedColor: AppColors.purpleLightBg,
                                    backgroundColor: const Color(0xFFF3F4F6),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _itemType == ItemType.service ? FontWeight.bold : FontWeight.normal,
                                      color: _itemType == ItemType.service ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: _itemType == ItemType.service ? AppColors.primary : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tabs: [Pricing], [Stock], [Other], [Party Wise Prices]
                  Row(
                    children: [
                      _buildTab('Pricing', 0),
                      _buildTab('Stock', 1),
                      _buildTab('Other', 2),
                      _buildTab('Party Wise Prices', 3),
                    ],
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 18),

                  if (_tabIndex == 0) ...[
                    // Inventory Tracking By
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Inventory Tracking By',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedTracking,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Unit
                    const Text('Unit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedUnit = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sales Price
                    const Text('Sales Price', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _salesPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '₹ ',
                              hintText: '130',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Without Tax', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                                Icon(Icons.arrow_drop_down, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Purchase Price
                    const Text('Purchase Price', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _purchasePriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '₹ ',
                              hintText: '115',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Without Tax', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                                Icon(Icons.arrow_drop_down, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // GST
                    const Text('GST', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedGst,
                      items: _gstRates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGst = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Discount on Sales Price
                    const Text('Discount on Sales Price', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _discountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '10',
                              suffixText: '%',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (_tabIndex == 1) ...[
                    const Text('Opening Stock Quantity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _openingStockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ex: 100',
                        suffixText: _selectedUnit,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Low Stock Alert Limit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ex: 10',
                      ),
                    ),
                  ] else ...[
                    const Text('Item Description & Notes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter specifications, barcode, category...',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Bar: "Save & New" + "Save" (screenshot 1000046143)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _saveItem(context, saveAndNew: true),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Save & New',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Create New Item',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _saveItem(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
