import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/party_model.dart';

class RecordPaymentPage extends StatefulWidget {
  const RecordPaymentPage({super.key});

  @override
  State<RecordPaymentPage> createState() => _RecordPaymentPageState();
}

class _RecordPaymentPageState extends State<RecordPaymentPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  PartyModel? _selectedParty;
  String _paymentMode = 'Cash';
  bool _showNote = false;

  final List<String> _paymentModes = ['Cash', 'Online/UPI', 'Bank Transfer', 'Cheque'];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  static final List<PartyModel> _defaultParties = [
    PartyModel(id: '1', name: 'Ankit Mishra', phone: '9876543210', balance: 14500, type: PartyType.customer),
    PartyModel(id: '2', name: 'Gupta Garments', phone: '9812345678', balance: -8200, type: PartyType.supplier),
    PartyModel(id: '3', name: 'Cash Sale', phone: '9999999999', balance: 0, type: PartyType.customer),
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
                itemCount: _defaultParties.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final party = _defaultParties[idx];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.purpleLightBg,
                      child: Text(party.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(party.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Current Balance: ₹ ${party.balance.abs().toStringAsFixed(0)}'),
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

  void _savePayment(BuildContext context) {
    if (_selectedParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Party')),
      );
      return;
    }
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment of ₹ ${amount.toStringAsFixed(0)} received from ${_selectedParty!.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Record Payment In'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top summary header (screenshot 1000046133)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Received Payment #1',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${now.day} Oct ${now.year}',
                            style: const TextStyle(
                              fontSize: 13,
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

                  const SizedBox(height: 20),

                  // AMOUNT *
                  const Text('AMOUNT *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: '₹ ',
                      hintText: 'Enter payment amount',
                    ),
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        '+ Add Payment In Discount',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Sales Invoice Unpaid link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sales Invoice',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          '+ Add Unpaid Sales Invoice',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Payment Mode
                  const Text('Payment Mode', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _paymentMode,
                    items: _paymentModes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMode = val);
                    },
                  ),

                  const SizedBox(height: 16),

                  if (!_showNote)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => _showNote = true),
                        child: const Text(
                          '+ Note',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    )
                  else ...[
                    const Text('Note', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(hintText: 'Add payment remarks or reference ID'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom sticky Save button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: ElevatedButton(
              onPressed: () => _savePayment(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save Payment In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
