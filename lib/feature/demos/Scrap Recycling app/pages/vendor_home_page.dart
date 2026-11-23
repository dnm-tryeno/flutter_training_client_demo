import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class VendorHomePage extends StatefulWidget {
  final VoidCallback onOpenBookPickup;
  final Function(PickupRequest) onOpenOrderTracking;

  const VendorHomePage({
    super.key,
    required this.onOpenBookPickup,
    required this.onOpenOrderTracking,
  });

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  String _selectedMaterialId = 'metal_iron';
  double _bulkWeightInput = 850.0;
  final TextEditingController _weightCtrl = TextEditingController(text: '850');

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vendor = state.vendorProfile;

    // Filter materials that have bulk slabs
    final bulkMaterials = state.materials.where((m) => m.vendorSlabs.isNotEmpty).toList();
    final activeMaterial = state.materials.firstWhere((m) => m.id == _selectedMaterialId);

    // Active slab for current weight
    final matchingSlab = activeMaterial.getActiveSlab(_bulkWeightInput);
    final currentSlabRate = activeMaterial.getRateFor(_bulkWeightInput, UserRole.vendor);
    final estimatedBulkPayout = _bulkWeightInput * currentSlabRate;

    // Find any ongoing vendor orders
    final vendorOrders = state.orders.where((o) => o.userRole == UserRole.vendor).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Vendor Business Profile Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.warehouse_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  vendor.businessName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF10B981)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'KYC APPROVED',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'GST: ${vendor.gstin}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ScrapAppTheme.textSubLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Vendor Delivery Mode Toggle Card
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dispatch / Delivery Preference',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => state.setDeliveryMode('Doorstep Pickup'),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: state.deliveryMode == 'Doorstep Pickup'
                                      ? ScrapAppTheme.primaryGreen
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: state.deliveryMode == 'Doorstep Pickup'
                                        ? ScrapAppTheme.primaryGreen
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_shipping_rounded,
                                      size: 16,
                                      color: state.deliveryMode == 'Doorstep Pickup'
                                          ? Colors.white
                                          : ScrapAppTheme.textMainLight,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Godown Pickup',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: state.deliveryMode == 'Doorstep Pickup'
                                            ? Colors.white
                                            : ScrapAppTheme.textMainLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => state.setDeliveryMode('Self-Delivery to Hub'),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: state.deliveryMode == 'Self-Delivery to Hub'
                                      ? ScrapAppTheme.accentAmberDark
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: state.deliveryMode == 'Self-Delivery to Hub'
                                        ? ScrapAppTheme.accentAmberDark
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.storefront_rounded,
                                      size: 16,
                                      color: state.deliveryMode == 'Self-Delivery to Hub'
                                          ? Colors.white
                                          : ScrapAppTheme.textMainLight,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Hub Drop (+₹2/kg)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: state.deliveryMode == 'Self-Delivery to Hub'
                                            ? Colors.white
                                            : ScrapAppTheme.textMainLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Ongoing Vendor Orders Alert
              if (vendorOrders.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: InkWell(
                    onTap: () => widget.onOpenOrderTracking(vendorOrders.first),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sync_rounded, color: Color(0xFFB45309)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bulk Order #${vendorOrders.first.id} in progress',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  'Status: ${vendorOrders.first.status.label} • ${vendorOrders.first.items.length} materials (${vendorOrders.first.estimatedWeight.toInt()} kg)',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFB45309)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // Interactive Bulk Slab Rates Engine
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bulk Quantity Slab Engine',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'LIVE SLABS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'As per requirements, rates automatically step up with higher volume.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: ScrapAppTheme.textSubLight,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Material Selector Horizontal Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: bulkMaterials.map((mat) {
                            final isSel = mat.id == _selectedMaterialId;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                selected: isSel,
                                onSelected: (val) {
                                  if (val) {
                                    setState(() {
                                      _selectedMaterialId = mat.id;
                                    });
                                  }
                                },
                                label: Text(
                                  mat.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : ScrapAppTheme.textMainLight,
                                  ),
                                ),
                                selectedColor: ScrapAppTheme.accentAmberDark,
                                backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Selected Material Visual Header
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Image.network(
                                  activeMaterial.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(activeMaterial.icon, color: activeMaterial.color),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeMaterial.name,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                  ),
                                  Text(
                                    activeMaterial.hindiName,
                                    style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Base: ₹${activeMaterial.retailRate.toInt()}/kg',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Weight Input Box & Auto-detector
                      Text(
                        'Enter Expected Bulk Weight (Kg)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _weightCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: ScrapAppTheme.accentAmberDark,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.scale_rounded, color: ScrapAppTheme.accentAmberDark),
                                suffixText: 'kg',
                                hintText: 'e.g. 850',
                                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              ),
                              onChanged: (val) {
                                final d = double.tryParse(val) ?? 0.0;
                                setState(() {
                                  _bulkWeightInput = d;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              state.updateCartQuantity(activeMaterial.id, _bulkWeightInput);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added ${_bulkWeightInput.toInt()} kg of ${activeMaterial.name} to bulk booking!',
                                  ),
                                  backgroundColor: ScrapAppTheme.primaryGreen,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ScrapAppTheme.accentAmberDark,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            child: const Text('Add to Batch'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Slabs visual comparison cards
                      Text(
                        'Applicable Slabs for ${activeMaterial.name}:',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: activeMaterial.vendorSlabs.map((slab) {
                          final isMatched = slab == matchingSlab;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? const Color(0xFFECFDF5)
                                  : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isMatched ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
                                width: isMatched ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isMatched ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  size: 18,
                                  color: isMatched ? ScrapAppTheme.primaryGreen : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  slab.slabLabel,
                                  style: TextStyle(
                                    fontWeight: isMatched ? FontWeight.w800 : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹${slab.ratePerKg.toStringAsFixed(1)} / kg',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isMatched ? ScrapAppTheme.primaryGreen : ScrapAppTheme.textMainLight,
                                  ),
                                ),
                                if (isMatched) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: ScrapAppTheme.primaryGreen,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'APPLIED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      // Payout Summary Card for this calculation
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ESTIMATED BULK PAYOUT',
                                  style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '${_bulkWeightInput.toInt()} kg × ₹$currentSlabRate',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${estimatedBulkPayout.toStringAsFixed(0)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF34D399),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weighbridge Slip & Tax Invoice feature highlight
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ScrapAppTheme.primaryGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long_rounded, color: ScrapAppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Computerized Weighbridge Slips',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Official electronic gross/tare slips & GST tax invoices generated automatically upon pickup.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: ScrapAppTheme.textSubLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Primary Bulk Booking CTA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: widget.onOpenBookPickup,
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: const Text('Book Bulk Godown Pickup Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ScrapAppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
