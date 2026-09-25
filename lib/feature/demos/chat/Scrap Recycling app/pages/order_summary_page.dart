import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/scrap_state.dart';
import 'order_tracking_page.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final double _platformCharge = 10.0;
  final double _handlingCharge = 10.0;

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);

    final estWeight = state.cartEstimatedWeight;
    final estTotal = state.cartEstimatedTotal;
    final isFreePickup = estWeight >= 15.0 || estTotal >= 150.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              state.clearCart();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626), size: 18),
            label: const Text(
              'Discard',
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Receive payment through
            _buildSectionHeader('Receive payment through'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showPaymentMethodSelector(context, state),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.paymentMethod,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF15803D), size: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. Fixed charges
            _buildSectionHeader('Fixed charges'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Platform Charge',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dashed,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '₹${_platformCharge.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Handling Charge',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dashed,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '₹${_handlingCharge.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Pickup charge
            _buildSectionHeader('Pickup charge'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFreePickup ? const Color(0xFF86EFAC) : const Color(0xFFE5E7EB),
                  width: isFreePickup ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.scale_rounded, size: 16, color: Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              'Weight above 15kg',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 22),
                          child: Text('or', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ),
                        Row(
                          children: [
                            const Text('₹', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Text(
                              'Amount above ₹150',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Free',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Below threshold card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !isFreePickup ? const Color(0xFFFDE68A) : const Color(0xFFE5E7EB),
                  width: !isFreePickup ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.scale_rounded, size: 16, color: Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              'Weight below 15kg',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 22),
                          child: Text('and', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ),
                        Row(
                          children: [
                            const Text('₹', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Text(
                              'Amount below ₹150',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '₹ 30',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Materials
            _buildSectionHeader('Materials (${state.cartQuantities.length})'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  ...state.cartQuantities.entries.map((entry) {
                    final mat = state.materials.firstWhere((m) => m.id == entry.key);
                    final qty = entry.value;
                    final rate = mat.getRateFor(qty, state.previewMode);
                    final itemTotal = qty * rate;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: Image.asset(
                                mat.displayAsset,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mat.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  '${qty.toInt()} ${mat.unit} × ₹${rate.toInt()}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${itemTotal.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimated Value',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      Text(
                        '₹${estTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF15803D),
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
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.location_on_outlined, color: Color(0xFFB45309), size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'From where should we pick\nup your scrap?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => _showAddressAndSlotPicker(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E7E34),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'Add or select address',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
      ],
    );
  }

  void _showPaymentMethodSelector(BuildContext context, ScrapState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Payout Method',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF15803D)),
                title: const Text('Instant UPI (PhonePe / GPay / Paytm)'),
                onTap: () {
                  state.setPaymentMethod('Instant UPI (PhonePe/GPay)');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.payments_rounded, color: Color(0xFF15803D)),
                title: const Text('Cash on Weighing'),
                onTap: () {
                  state.setPaymentMethod('Cash on Weighing');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_rounded, color: Color(0xFF15803D)),
                title: const Text('Direct Bank NEFT / IMPS'),
                onTap: () {
                  state.setPaymentMethod('Direct Bank Transfer');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddressAndSlotPicker(BuildContext context, ScrapState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Pickup Address',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...state.addresses.map((addr) {
                final isSel = addr.id == state.selectedAddress.id;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSel ? const Color(0xFF1E7E34) : const Color(0xFFE5E7EB),
                      width: isSel ? 1.5 : 1,
                    ),
                  ),
                  leading: const Icon(Icons.location_on_rounded, color: Color(0xFF1E7E34)),
                  title: Text(addr.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(addr.fullAddress, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: isSel ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1E7E34)) : null,
                  onTap: () {
                    state.setSelectedAddress(addr);
                    Navigator.pop(ctx);
                    _confirmAndPlaceBooking(context, state);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _confirmAndPlaceBooking(BuildContext context, ScrapState state) {
    final order = state.submitBooking();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderTrackingPage(order: order),
      ),
    );
  }
}
