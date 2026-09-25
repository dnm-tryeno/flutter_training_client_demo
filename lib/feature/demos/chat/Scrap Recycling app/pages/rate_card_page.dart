import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class RateCardPage extends StatefulWidget {
  final VoidCallback? onOpenBookPickup;

  const RateCardPage({super.key, this.onOpenBookPickup});

  @override
  State<RateCardPage> createState() => _RateCardPageState();
}

class _RateCardPageState extends State<RateCardPage> {
  String _searchQuery = '';
  ScrapCategoryType? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = state.materials.where((m) {
      final matchesCat = _selectedCategory == null || m.category == _selectedCategory;
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.hindiName.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Live Scrap Rate Card',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search scrap: newspaper, iron, लोहा, copper...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          selected: _selectedCategory == null,
                          onSelected: (val) {
                            if (val) setState(() => _selectedCategory = null);
                          },
                          label: const Text('All Scrap'),
                          selectedColor: ScrapAppTheme.primaryGreen,
                          labelStyle: TextStyle(
                            color: _selectedCategory == null ? Colors.white : ScrapAppTheme.textMainLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      ...ScrapCategoryType.values.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            selected: isSel,
                            onSelected: (val) {
                              setState(() {
                                _selectedCategory = val ? cat : null;
                              });
                            },
                            avatar: Icon(cat.icon, size: 14, color: isSel ? Colors.white : cat.color),
                            label: Text(cat.title),
                            selectedColor: ScrapAppTheme.primaryGreen,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : ScrapAppTheme.textMainLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Rate Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final mat = filtered[index];
                final inCart = state.cartQuantities.containsKey(mat.id);
                final rate = mat.getRateFor(10, state.previewMode);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: inCart ? ScrapAppTheme.primaryGreen : const Color(0xFFCBD5E1),
                      width: inCart ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 58,
                              height: 58,
                              child: Image.network(
                                mat.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: mat.color.withValues(alpha: 0.15),
                                    child: Icon(mat.icon, color: mat.color, size: 26),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mat.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  mat.hindiName,
                                  style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${rate.toStringAsFixed(0)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: ScrapAppTheme.primaryGreen,
                                ),
                              ),
                              Text(
                                'per ${mat.unit}',
                                style: const TextStyle(fontSize: 10, color: ScrapAppTheme.textSubLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mat.description,
                        style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                      ),
                      if (mat.vendorSlabs.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: mat.vendorSlabs.map((slab) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${slab.slabLabel}: ₹${slab.ratePerKg.toInt()}/kg',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: inCart
                            ? TextButton.icon(
                                onPressed: () {
                                  state.updateCartQuantity(mat.id, 0);
                                },
                                icon: const Icon(Icons.check, size: 14, color: ScrapAppTheme.primaryGreen),
                                label: const Text('Added in Cart (Remove)', style: TextStyle(color: ScrapAppTheme.primaryGreen, fontSize: 11)),
                              )
                            : OutlinedButton.icon(
                                onPressed: () {
                                  state.updateCartQuantity(mat.id, mat.unit == 'kg' ? 10.0 : 1.0);
                                },
                                icon: const Icon(Icons.add, size: 14),
                                label: const Text('Sell This Item', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
