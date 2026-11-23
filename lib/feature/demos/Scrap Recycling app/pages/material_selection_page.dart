import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import 'order_summary_page.dart';

class MaterialSelectionPage extends StatefulWidget {
  final ScrapCategoryType? initialCategory;

  const MaterialSelectionPage({
    super.key,
    this.initialCategory,
  });

  @override
  State<MaterialSelectionPage> createState() => _MaterialSelectionPageState();
}

class _MaterialSelectionPageState extends State<MaterialSelectionPage> {
  late ScrapCategoryType? _selectedCategory;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? ScrapCategoryType.paper;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);

    final filtered = state.materials.where((m) {
      final matchesCat = _selectedCategory == null || m.category == _selectedCategory;
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.hindiName.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();

    final selectedCount = state.cartQuantities.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select scrap items to sell',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search material',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  suffixIcon: Icon(Icons.search_rounded, color: Color(0xFF475569)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Horizontal Category Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _buildCategoryPill(
                  label: 'All',
                  isSelected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                ...ScrapCategoryType.values.map((cat) {
                  return _buildCategoryPill(
                    label: cat.title,
                    isSelected: _selectedCategory == cat,
                    onTap: () => setState(() => _selectedCategory = cat),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Materials List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final mat = filtered[index];
                final inCart = state.cartQuantities.containsKey(mat.id);
                final qty = state.cartQuantities[mat.id] ?? 0.0;
                final rate = mat.getRateFor(qty > 0 ? qty : 10, state.previewMode);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: inCart ? const Color(0xFF1E7E34) : const Color(0xFFE2E8F0),
                      width: inCart ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Square material image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 58,
                          height: 58,
                          child: Image.asset(
                            mat.displayAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Title & Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mat.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  '₹${rate.toStringAsFixed(0)}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'per ${mat.unit}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // + Add / Stepper Counter
                      if (!inCart)
                        OutlinedButton(
                          onPressed: () {
                            state.updateCartQuantity(mat.id, mat.unit == 'kg' ? 10.0 : 1.0);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0FDF4),
                            side: const BorderSide(color: Color(0xFF86EFAC), width: 1.2),
                            foregroundColor: const Color(0xFF15803D),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            '+ Add',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        )
                      else
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                final step = mat.unit == 'kg' ? 5.0 : 1.0;
                                state.updateCartQuantity(mat.id, qty - step);
                              },
                              icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.red, size: 22),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${qty.toInt()} ${mat.unit}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final step = mat.unit == 'kg' ? 5.0 : 1.0;
                                state.updateCartQuantity(mat.id, qty + step);
                              },
                              icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF1E7E34), size: 22),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Blue Bulk Quote Info Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFE0F2FE),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF0369A1)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'These rates are for regular quantities. For bulk quantities (100+ kg), you will get better rates.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0369A1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    state.setRole(UserRole.vendor);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Get Bulk Quote',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar: [ X items selected ]  [ Continue > ]
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: SafeArea(
              child: InkWell(
                onTap: selectedCount > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const OrderSummaryPage(),
                          ),
                        );
                      }
                    : null,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: selectedCount > 0 ? const Color(0xFF1E7E34) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$selectedCount item${selectedCount == 1 ? "" : "s"} selected',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Continue',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E7E34) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF1E7E34) : const Color(0xFFCBD5E1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}
