import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/party_model.dart';
import '../../models/transaction_model.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  PartyModel? _selectedParty;
  final List<InvoiceItemLine> _selectedItems = [];
  bool _isPaid = false;

  final List<PartyModel> _sampleParties = [
    PartyModel(id: 'p-1', name: 'Ankit Mishra', phone: '9876543210', balance: 14500),
    PartyModel(id: 'p-2', name: 'Gupta Garments', phone: '9812345678', balance: 9060),
    PartyModel(id: 'p-3', name: 'Cash Sale', phone: '', balance: 0),
  ];

  final List<Map<String, dynamic>> _sampleItems = [
    {'id': 'item-1', 'name': 'Sample Item', 'price': 220.0, 'unit': 'BOX'},
    {'id': 'item-2', 'name': 'Kissan Fruit Jam 500 gm', 'price': 130.0, 'unit': 'PCS'},
    {'id': 'item-3', 'name': 'Fortune Kachi Ghani 1L', 'price': 175.0, 'unit': 'PCS'},
  ];

  void _showPartyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Party',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _sampleParties.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final party = _sampleParties[idx];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.purpleLightBg,
                      child: Text(party.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(party.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(party.phone ?? 'Customer'),
                    trailing: Text('₹ ${party.balance.abs().toStringAsFixed(0)}'),
                    onTap: () {
                      setState(() => _selectedParty = party);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Item to Invoice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _sampleItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final item = _sampleItems[idx];
                  return ListTile(
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Rate: ₹ ${item['price']} / ${item['unit']}'),
                    trailing: const Icon(Icons.add_circle, color: AppColors.primary),
                    onTap: () {
                      setState(() {
                        _selectedItems.add(
                          InvoiceItemLine(
                            itemId: item['id'],
                            itemName: item['name'],
                            quantity: 1,
                            unitPrice: item['price'],
                            unit: item['unit'],
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _totalAmount {
    return _selectedItems.fold(0.0, (sum, i) => sum + i.total);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Bill / Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: AppColors.primary),
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
                  // Orange Scan & Record banner (screenshot 1000046134)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFEDD5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Now create Invoices instantly',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Instantly add Invoices Bills from bill Image or PDF',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('AI OCR Scan active: Choose invoice image or PDF')),
                            );
                          },
                          icon: const Icon(Icons.crop_free, size: 18),
                          label: const Text('Scan & Record Invoices Bills'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEA580C),
                            minimumSize: const Size.fromHeight(42),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sales Invoice #1 & Date Info (screenshot 1000046134)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sales Invoice #1',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${now.day} Oct ${now.year} - 7 day(s) to due',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'EDIT',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 24, color: AppColors.cardBorder),

                  // PARTY NAME *
                  const Text('PARTY NAME *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _showPartyPicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, color: AppColors.textMuted, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedParty?.name ?? 'Search/Create Party',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedParty != null ? AppColors.textPrimary : AppColors.textMuted,
                                fontWeight: _selectedParty != null ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ITEMS SECTION
                  const Text('ITEMS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(height: 10),

                  // Add Items Button (Light Purple block)
                  InkWell(
                    onTap: () => _showItemPicker(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.purpleLightBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Add Items',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Selected item lines
                  if (_selectedItems.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedItems.length,
                      itemBuilder: (ctx, i) {
                        final item = _selectedItems[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text('${item.quantity} ${item.unit} x ₹ ${item.unitPrice}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Text('₹ ${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
                                onPressed: () {
                                  setState(() => _selectedItems.removeAt(i));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // Payment mode switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mark as Fully Paid', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Switch(
                        value: _isPaid,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _isPaid = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom summary & CTA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        '₹ ${_totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invoice generated for ₹ ${_totalAmount.toStringAsFixed(0)}!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save & Generate', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
