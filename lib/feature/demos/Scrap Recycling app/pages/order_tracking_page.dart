import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';
import '../widgets/digital_signature_pad.dart';

class OrderTrackingPage extends StatefulWidget {
  final PickupRequest order;

  const OrderTrackingPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late PickupRequest _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    // Find updated order reference in state
    final updated = state.orders.firstWhere((o) => o.id == _order.id, orElse: () => _order);
    _order = updated;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rider = _order.assignedRider;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ${_order.id}',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              'Booked: ${_order.slotDate} • ${_order.slotTime}',
              style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
            ),
          ],
        ),
        actions: [
          // Demo advance button
          if (_order.status != PickupStatus.completed && _order.status != PickupStatus.cancelled)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () {
                  state.advanceOrderStatus(_order.id);
                },
                icon: const Icon(Icons.fast_forward_rounded, size: 16, color: ScrapAppTheme.accentAmberDark),
                label: const Text(
                  'Next Stage',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ScrapAppTheme.accentAmberDark,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF3C7),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card with dynamic color
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _order.status.color.withValues(alpha: 0.15),
                    _order.status.color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _order.status.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _order.status.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_order.status.icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _order.status.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _order.status.color,
                          ),
                        ),
                        Text(
                          _order.status.hindiLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ScrapAppTheme.textSubLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusDescription(_order.status),
                          style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pickup Security OTP Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security_rounded, color: Color(0xFFB45309), size: 22),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pickup Security Code (OTP)',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF92400E)),
                          ),
                          const Text(
                            'Share with agent only after scrap is loaded',
                            style: TextStyle(fontSize: 10, color: Color(0xFFB45309)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB45309),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _order.otp,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Rider Map Simulation (when On The Way or Reached)
            if (_order.status == PickupStatus.onTheWay || _order.status == PickupStatus.reached) ...[
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  color: const Color(0xFFE2E8F0),
                ),
                child: Stack(
                  children: [
                    // Simulated Map Graphic Grid
                    CustomPaint(
                      painter: _SimulatedMapPainter(),
                      size: Size.infinite,
                    ),
                    // ETA Pill
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_rounded, size: 13, color: Color(0xFF34D399)),
                            SizedBox(width: 5),
                            Text(
                              'Arriving in ~12 mins (3.2 km)',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Moving Agent Marker
                    Positioned(
                      top: 55,
                      left: 140,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: ScrapAppTheme.primaryGreen,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ScrapAppTheme.primaryGreen.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.two_wheeler_rounded, size: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            ),
                            child: Text(
                              rider?.name ?? 'Pickup Agent',
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Destination Marker
                    Positioned(
                      bottom: 30,
                      right: 40,
                      child: Column(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 28, color: Colors.red),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Your Godown/Home', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Assigned Rider Card
            if (rider != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFD1FAE5),
                      child: Text(
                        rider.name[0],
                        style: const TextStyle(
                          color: ScrapAppTheme.primaryGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                rider.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, size: 12, color: Color(0xFFD97706)),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${rider.rating}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${rider.vehicleModel} • ${rider.vehicleNumber}',
                            style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                          ),
                          Text(
                            '${rider.totalPickups}+ verified pickups completed',
                            style: const TextStyle(fontSize: 10, color: ScrapAppTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone_in_talk_rounded, color: ScrapAppTheme.primaryGreen),
                      tooltip: 'Call Rider',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling ${rider.name} at ${rider.phone}...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Actual Weighed Quantities & Final Amount Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _order.status == PickupStatus.completed
                            ? 'Official Weighing Receipt'
                            : 'Scrap Materials & Weighing',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _order.status == PickupStatus.completed
                              ? const Color(0xFFD1FAE5)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _order.status == PickupStatus.completed ? 'VERIFIED' : 'ESTIMATED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: _order.status == PickupStatus.completed
                                ? ScrapAppTheme.primaryDark
                                : ScrapAppTheme.textSubLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  ..._order.items.map((it) {
                    final isWeighed = it.actualQty != null;
                    final displayQty = isWeighed ? it.actualQty! : it.estimatedQty;
                    final total = displayQty * it.appliedRate;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(it.material.icon, size: 18, color: it.material.color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  it.material.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  isWeighed
                                      ? 'Scale Weight: ${displayQty.toStringAsFixed(1)} ${it.material.unit} @ ₹${it.appliedRate.toInt()}'
                                      : 'Approx: ${displayQty.toStringAsFixed(1)} ${it.material.unit} @ ₹${it.appliedRate.toInt()}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isWeighed ? ScrapAppTheme.primaryGreen : ScrapAppTheme.textSubLight,
                                    fontWeight: isWeighed ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Cash Payout',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(
                        '₹${_order.actualTotal.toStringAsFixed(0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: ScrapAppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Settlement Status', style: TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight)),
                      Text(
                        _order.paymentStatus,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _order.status == PickupStatus.completed ? ScrapAppTheme.primaryGreen : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pickup Address Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_rounded, color: ScrapAppTheme.primaryGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_order.address.label} • ${_order.userName}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        Text(
                          _order.address.fullAddress,
                          style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight),
                        ),
                        Text(
                          'City: ${_order.address.city} (${_order.address.pincode})',
                          style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Digital Signature Pad (if in Reached / Weighing stage)
            if (_order.status == PickupStatus.reached && !_order.hasDigitalSignature) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ScrapAppTheme.primaryGreen),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Handover Signature',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sign below to confirm digital scale weighing & payout handover.',
                      style: TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                    ),
                    const SizedBox(height: 10),
                    DigitalSignaturePad(
                      onSignatureChanged: (hasSig) {
                        setState(() {
                          _order.hasDigitalSignature = hasSig;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        state.riderCompletePickup(_order.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order verified and marked completed! Cash payout released.'),
                            backgroundColor: ScrapAppTheme.primaryGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('Confirm Weight & Complete Handover'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScrapAppTheme.primaryGreen,
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Completed Feedback Rating (if completed)
            if (_order.status == PickupStatus.completed) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_rounded, size: 36, color: ScrapAppTheme.primaryGreen),
                    const SizedBox(height: 8),
                    Text(
                      'Pickup Completed & Settled!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ScrapAppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_order.actualTotal.toStringAsFixed(0)} received via ${_order.paymentMethod}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 24);
                      }),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _order.feedback ?? 'Rated 5/5 Stars for punctuality and accurate scale weighing.',
                      style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusDescription(PickupStatus status) {
    switch (status) {
      case PickupStatus.requested:
        return 'Our dispatch center is reviewing materials and slot availability.';
      case PickupStatus.accepted:
        return 'Request confirmed! Hub is assigning a verified pickup agent.';
      case PickupStatus.riderAssigned:
        return 'Pickup agent assigned with electronic weighing scale.';
      case PickupStatus.onTheWay:
        return 'Agent is navigating to your address with digital weighing machine.';
      case PickupStatus.reached:
        return 'Agent is weighing scrap items on certified digital scale.';
      case PickupStatus.completed:
        return 'Weight verified, digital signature captured, payout settled.';
      case PickupStatus.cancelled:
        return 'This pickup was cancelled.';
    }
  }
}

class _SimulatedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roadBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(20, size.height * 0.2);
    path.cubicTo(
      size.width * 0.35, size.height * 0.2,
      size.width * 0.45, size.height * 0.75,
      size.width - 30, size.height * 0.75,
    );

    canvas.drawPath(path, roadBorder);
    canvas.drawPath(path, roadPaint);

    // Green route trace
    final routePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routeSubPath = Path();
    routeSubPath.moveTo(20, size.height * 0.2);
    routeSubPath.cubicTo(
      size.width * 0.35, size.height * 0.2,
      size.width * 0.42, size.height * 0.45,
      140, 55,
    );
    canvas.drawPath(routeSubPath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
