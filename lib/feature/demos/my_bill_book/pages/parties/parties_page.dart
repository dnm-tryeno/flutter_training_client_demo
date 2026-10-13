import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/party_model.dart';
import 'create_party_page.dart';
import 'sort_filter_sheet.dart';
import 'shared_ledgers_page.dart';
import 'shared_ledger_portal_sheet.dart';

class PartiesPage extends StatefulWidget {
  final String? initialFilter;

  const PartiesPage({super.key, this.initialFilter});

  @override
  State<PartiesPage> createState() => _PartiesPageState();
}

class _PartiesPageState extends State<PartiesPage> {
  late bool _toCollectActive;
  late bool _toPayActive;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  // Parties dataset
  final List<PartyModel> _allParties = [
    PartyModel(
      id: 'p-1',
      name: 'Ankit Mishra',
      phone: '9876543210',
      type: PartyType.customer,
      balance: 14500.0,
      category: 'Retailers',
      billingAddress: 'B-12, Sector 62, Noida, UP',
    ),
    PartyModel(
      id: 'p-2',
      name: 'Gupta Garments',
      phone: '9812345678',
      type: PartyType.supplier,
      balance: -7500.0,
      category: 'Wholesalers',
      billingAddress: 'Main Market, Karol Bagh, Delhi',
    ),
    PartyModel(
      id: 'p-3',
      name: 'Sharma Traders',
      phone: '9988776655',
      type: PartyType.customer,
      balance: 9060.0,
      category: 'Distributors',
      billingAddress: 'Shop 4, Ring Road, Surat',
    ),
    PartyModel(
      id: 'p-4',
      name: 'Modern Fabrics',
      phone: '9823456789',
      type: PartyType.supplier,
      balance: -4200.0,
      category: 'Manufacturers',
      billingAddress: 'GIDC Industrial Area, Ahmedabad',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter == 'to_pay') {
      _toCollectActive = false;
      _toPayActive = true;
    } else {
      _toCollectActive = true;
      _toPayActive = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PartyModel> get _filteredParties {
    return _allParties.where((party) {
      if (_toPayActive && party.balance >= 0) return false;
      if (_toCollectActive && party.balance <= 0) return false;

      if (_selectedCategory != 'All' && party.category != _selectedCategory) {
        return false;
      }

      if (_searchController.text.trim().isNotEmpty) {
        final query = _searchController.text.trim().toLowerCase();
        final nameMatches = party.name.toLowerCase().contains(query);
        final phoneMatches = (party.phone ?? '').contains(query);
        if (!nameMatches && !phoneMatches) return false;
      }

      return true;
    }).toList();
  }

  void _showSortFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SortFilterSheet(),
    );
  }

  void _showSharedLedgerPortal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SharedLedgerPortalSheet(),
    );
  }

  void _showPartySettings(BuildContext context) {
    bool groupCategories = true;
    bool autoReminders = true;
    bool creditAlerts = true;
    bool showZeroBalance = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Party Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Text(
                'Configure display, reminder alerts, and party preferences.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: const Text('Group by Categories', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Group parties by Retailer, Wholesaler & Distributor', style: TextStyle(fontSize: 12)),
                value: groupCategories,
                onChanged: (val) => setModalState(() => groupCategories = val),
              ),
              const Divider(height: 1, color: AppColors.divider),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: const Text('Automatic WhatsApp Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Send gentle payment reminders 3 days before due date', style: TextStyle(fontSize: 12)),
                value: autoReminders,
                onChanged: (val) => setModalState(() => autoReminders = val),
              ),
              const Divider(height: 1, color: AppColors.divider),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: const Text('Credit Limit Exceeded Alerts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Block creating new bill if credit limit is exceeded', style: TextStyle(fontSize: 12)),
                value: creditAlerts,
                onChanged: (val) => setModalState(() => creditAlerts = val),
              ),
              const Divider(height: 1, color: AppColors.divider),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: const Text('Show Zero Balance Parties', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Display parties with settled balance in main list', style: TextStyle(fontSize: 12)),
                value: showZeroBalance,
                onChanged: (val) => setModalState(() => showZeroBalance = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Party settings updated successfully!'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryFilterSheet(BuildContext context) {
    final categories = [
      'All',
      'Retailers',
      'Wholesalers',
      'Distributors',
      'Manufacturers',
      'Customers',
      'Suppliers',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat == 'All' ? 'All Categories' : cat),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: const Color(0xFFF3F4F6),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      Navigator.pop(ctx);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showImportPartiesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Import & Add Parties',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Text(
              'Quickly import your customers and suppliers in bulk.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            _buildImportOption(
              icon: Icons.contacts_rounded,
              iconColor: const Color(0xFF2563EB),
              title: 'Import from Phone Contacts',
              subtitle: 'Select parties directly from device contact book',
              onTap: () {
                Navigator.pop(ctx);
                _showPhoneContactsPicker(context);
              },
            ),
            const SizedBox(height: 10),
            _buildImportOption(
              icon: Icons.table_view_rounded,
              iconColor: const Color(0xFF16A34A),
              title: 'Upload Excel (.xlsx / .csv)',
              subtitle: 'Bulk upload party list with balances from spreadsheet',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selecting Excel sheet to import parties...'),
                    backgroundColor: Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildImportOption(
              icon: Icons.sync_alt_rounded,
              iconColor: const Color(0xFF7C3AED),
              title: 'Import from Other Billing Apps',
              subtitle: 'Migrate from Vyapar, Tally, Busy or Khatabook',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting to migration service...'),
                    backgroundColor: Color(0xFF7C3AED),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildImportOption(
              icon: Icons.share_rounded,
              iconColor: const Color(0xFFEA580C),
              title: 'Share Self-Registration Portal',
              subtitle: 'Share link on WhatsApp for parties to enter their details',
              onTap: () {
                Navigator.pop(ctx);
                _showSharedLedgerPortal(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  void _showPhoneContactsPicker(BuildContext context) {
    final mockContacts = [
      {'name': 'Rahul Verma', 'phone': '9876543210', 'selected': true},
      {'name': 'Kunal Shah', 'phone': '9811223344', 'selected': true},
      {'name': 'Suresh Patel', 'phone': '9822334455', 'selected': false},
      {'name': 'Amit Sharma', 'phone': '9833445566', 'selected': false},
      {'name': 'Priya Traders', 'phone': '9844556677', 'selected': false},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.contacts_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Select Phone Contacts'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mockContacts.length,
              itemBuilder: (context, i) {
                final c = mockContacts[i];
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: c['selected'] as bool,
                  title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(c['phone'] as String, style: const TextStyle(fontSize: 12)),
                  onChanged: (val) {
                    setDialogState(() {
                      c['selected'] = val ?? false;
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final selected = mockContacts.where((c) => c['selected'] == true).toList();
                Navigator.pop(ctx);
                setState(() {
                  for (final s in selected) {
                    _allParties.add(
                      PartyModel(
                        id: 'p-${DateTime.now().millisecondsSinceEpoch}-${s['name']}',
                        name: s['name'] as String,
                        phone: s['phone'] as String,
                        type: PartyType.customer,
                        balance: 0.0,
                        category: 'Customers',
                      ),
                    );
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${selected.length} contacts imported into Parties!'),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Import Selected'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredParties;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search by party name or phone...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                ),
                style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                onChanged: (_) => setState(() {}),
              )
            : const Text('Parties'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.primary),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary),
              tooltip: 'Search Parties',
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.link_rounded, color: AppColors.primary),
              tooltip: 'SharedLedger Portal',
              onPressed: () => _showSharedLedgerPortal(context),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
              tooltip: 'Party Settings',
              onPressed: () => _showPartySettings(context),
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Filter Chips Row (screenshot 1000046130)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // To Pay chip
                      _buildFilterChip(
                        label: 'To Pay',
                        isSelected: _toPayActive,
                        onTap: () {
                          setState(() {
                            _toPayActive = !_toPayActive;
                            if (_toPayActive) _toCollectActive = false;
                          });
                        },
                      ),
                      const SizedBox(width: 8),

                      // To Collect chip (active with X as in screenshot)
                      _buildFilterChip(
                        label: 'To Collect',
                        isSelected: _toCollectActive,
                        showClose: _toCollectActive,
                        onTap: () {
                          setState(() {
                            _toCollectActive = !_toCollectActive;
                            if (_toCollectActive) _toPayActive = false;
                          });
                        },
                      ),
                      const SizedBox(width: 8),

                      // Category dropdown chip
                      InkWell(
                        onTap: () => _showCategoryFilterSheet(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _selectedCategory != 'All'
                                ? AppColors.purpleLightBg
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedCategory != 'All' ? AppColors.primary : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _selectedCategory == 'All' ? 'Category' : _selectedCategory,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _selectedCategory != 'All' ? FontWeight.bold : FontWeight.normal,
                                  color: _selectedCategory != 'All' ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (_selectedCategory != 'All')
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = 'All';
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 14, color: AppColors.primary),
                                )
                              else
                                const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Filter By icon chip
                      InkWell(
                        onTap: () => _showSortFilter(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Text('Filter By', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                              SizedBox(width: 4),
                              Icon(Icons.tune, size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  child: Column(
                    children: [
                      // Promo Banner (screenshot 1000046130)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292524),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tired of asking Party\'s Ledger',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const SharedLedgersPage()),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'View SharedLedgers >',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF38BDF8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 32),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Parties List or Empty State
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_search_outlined,
                                size: 90,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No Parties Found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'Please search for a different party or create a new party.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final party = filtered[index];
                            final isReceivable = party.balance > 0;
                            final isPayable = party.balance < 0;

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                    child: Text(
                                      party.name.isNotEmpty ? party.name[0].toUpperCase() : 'P',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          party.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${party.phone ?? 'No phone'} • ${party.category ?? 'General'}',
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
                                        '₹ ${party.balance.abs().toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isReceivable
                                              ? AppColors.green
                                              : (isPayable ? AppColors.red : AppColors.textSecondary),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        isReceivable
                                            ? 'To Collect ↓'
                                            : (isPayable ? 'To Pay ↑' : 'Settled'),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: isReceivable
                                              ? AppColors.green
                                              : (isPayable ? AppColors.red : AppColors.textMuted),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Floating Action Buttons (screenshot 1000046130)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                // SharedLedgers button (Blue pill)
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SharedLedgersPage()),
                      );
                    },
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: const Text('SharedLedgers', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Bulk import icon (Circular)
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.file_upload_outlined, color: Colors.white, size: 22),
                    tooltip: 'Import Parties',
                    onPressed: () => _showImportPartiesSheet(context),
                  ),
                ),
                const SizedBox(width: 10),

                // + Create Party button (Purple pill)
                Expanded(
                  flex: 4,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CreatePartyPage()),
                      );
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Create Party', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    bool showClose = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purpleLightBg : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (showClose) ...[
              const SizedBox(width: 6),
              const Icon(Icons.close, size: 14, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
