import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Parties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.link_rounded, color: AppColors.primary),
            tooltip: 'SharedLedger Portal',
            onPressed: () => _showSharedLedgerPortal(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text('Category', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
                          ],
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
                            // Notebook illustration
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

                      // If To Collect has no parties (screenshot 1000046130)
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Importing parties from Excel / Phone contacts...')),
                      );
                    },
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
