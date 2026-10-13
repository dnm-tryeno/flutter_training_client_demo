import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/party_model.dart';

class CreatePartyPage extends StatefulWidget {
  const CreatePartyPage({super.key});

  @override
  State<CreatePartyPage> createState() => _CreatePartyPageState();
}

class _CreatePartyPageState extends State<CreatePartyPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gstController = TextEditingController();
  final _panController = TextEditingController();
  final _addressController = TextEditingController();

  PartyType _partyType = PartyType.customer;
  int _tabIndex = 0; // 0 = Business Info, 1 = Credit Info, 2 = Other Details
  bool _showGstBanner = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveParty(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Party Name')),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Party "${_nameController.text.trim()}" created successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create New Party'),
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
          // Yellow Autofill banner (screenshot 1000046140)
          if (_showGstBanner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFFFEFCE8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Autofill party details with GST number',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF854D0E),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _gstController.text = '24AAACC1206D1ZM';
                      _nameController.text = 'Bharat Logistics Pvt Ltd';
                      _panController.text = 'AAACC1206D';
                      _addressController.text = 'GIDC Estate, Ahmedabad, Gujarat';
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: const BorderSide(color: Color(0xFFCA8A04)),
                    ),
                    child: const Text('Add', style: TextStyle(color: Color(0xFF854D0E), fontSize: 13)),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _showGstBanner = false),
                    child: const Icon(Icons.close, size: 18, color: Color(0xFF854D0E)),
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Party Name *
                  const Text('Party Name *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Ankit Mishra',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contact Number & Party Type Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Number
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Contact Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'Ex: 9876543210',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Party Type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Party Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Center(child: Text('Customer')),
                                    selected: _partyType == PartyType.customer,
                                    onSelected: (val) {
                                      if (val) setState(() => _partyType = PartyType.customer);
                                    },
                                    selectedColor: AppColors.purpleLightBg,
                                    backgroundColor: const Color(0xFFF3F4F6),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _partyType == PartyType.customer ? FontWeight.bold : FontWeight.normal,
                                      color: _partyType == PartyType.customer ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: _partyType == PartyType.customer ? AppColors.primary : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Center(child: Text('Supplier')),
                                    selected: _partyType == PartyType.supplier,
                                    onSelected: (val) {
                                      if (val) setState(() => _partyType = PartyType.supplier);
                                    },
                                    selectedColor: AppColors.purpleLightBg,
                                    backgroundColor: const Color(0xFFF3F4F6),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _partyType == PartyType.supplier ? FontWeight.bold : FontWeight.normal,
                                      color: _partyType == PartyType.supplier ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: _partyType == PartyType.supplier ? AppColors.primary : Colors.transparent,
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

                  const SizedBox(height: 24),

                  // Tabs: [Business Info], [Credit Info], [Other Details]
                  Row(
                    children: [
                      _buildFormTab('Business Info', 0),
                      _buildFormTab('Credit Info', 1),
                      _buildFormTab('Other Details', 2),
                    ],
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 20),

                  if (_tabIndex == 0) ...[
                    // GST Number
                    const Text('GST Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _gstController,
                      decoration: const InputDecoration(
                        hintText: 'Ex: 24AAACC1206D1ZM',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // PAN Number
                    const Text('PAN Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _panController,
                      decoration: const InputDecoration(
                        hintText: 'Ex: AAACC1206D',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Billing Address
                    const Text('Billing Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Enter complete street & billing address',
                        prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.primary),
                      ),
                    ),
                  ] else if (_tabIndex == 1) ...[
                    const Text('Credit Limit (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Ex: 50000'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Payment Due Period (Days)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Ex: 30'),
                    ),
                  ] else ...[
                    const Text('Shipping Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Same as Billing Address or custom'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom sticky Save button (screenshot 1000046140)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: ElevatedButton(
              onPressed: () => _saveParty(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormTab(String title, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
