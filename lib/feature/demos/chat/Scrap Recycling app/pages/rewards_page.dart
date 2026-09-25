import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class RewardsPage extends StatefulWidget {
  final VoidCallback onOpenBookPickup;

  const RewardsPage({super.key, required this.onOpenBookPickup});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _ecoPoints = 480;
  final String _referralCode = 'KABADA50';

  final List<Map<String, dynamic>> _coupons = [
    {
      'title': 'Plant a Tree in Your Name',
      'partner': 'SankalpTaru NGO Partner',
      'cost': 250,
      'tag': 'ECO IMPACT',
      'icon': Icons.park_rounded,
      'color': const Color(0xFF047857),
      'redeemed': false,
    },
    {
      'title': 'Zero-Waste Bamboo Kit',
      'partner': 'EcoLiving Co.',
      'cost': 350,
      'tag': 'PHYSICAL GIFT',
      'icon': Icons.shopping_bag_outlined,
      'color': const Color(0xFFD97706),
      'redeemed': false,
    },
    {
      'title': '₹100 Amazon Pay Gift Voucher',
      'partner': 'Amazon India',
      'cost': 1000,
      'tag': 'CASH VOUCHER',
      'icon': Icons.card_giftcard_rounded,
      'color': const Color(0xFF0284C7),
      'redeemed': false,
    },
    {
      'title': '10% Extra Bonus on Next Pickup',
      'partner': 'KABADA Green Club',
      'cost': 150,
      'tag': 'EXCLUSIVE',
      'icon': Icons.auto_awesome_rounded,
      'color': const Color(0xFF7C3AED),
      'redeemed': true,
    },
  ];

  void _redeemCoupon(int index) {
    final coupon = _coupons[index];
    if (coupon['redeemed'] == true) return;
    final cost = coupon['cost'] as int;

    if (_ecoPoints < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough points! You need ${cost - _ecoPoints} more points to redeem.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    setState(() {
      _ecoPoints -= cost;
      coupon['redeemed'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully redeemed: ${coupon['title']}! Code: KBD-${1000 + index}'),
        backgroundColor: ScrapAppTheme.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Rewards & Impact',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Eco Points Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF047857).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.eco_rounded, color: Color(0xFFFDE68A), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'GREEN CLUB MEMBER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '1 pt = ₹0.10',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Available Eco-Points',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$_ecoPoints',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'pts (≈ ₹${(_ecoPoints * 0.1).toStringAsFixed(0)})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFDE68A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sell more scrap to earn points',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: widget.onOpenBookPickup,
                          child: Row(
                            children: const [
                              Text(
                                'Book Now',
                                style: TextStyle(
                                  color: Color(0xFFFDE68A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFFFDE68A)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Environmental Impact Matrix
            Text(
              'Your Lifetime Green Impact',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildImpactCard('18', 'Trees Saved', Icons.forest_rounded, const Color(0xFF047857), isDark)),
                const SizedBox(width: 10),
                Expanded(child: _buildImpactCard('340 kg', 'Waste Diverted', Icons.recycling_rounded, const Color(0xFF0284C7), isDark)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildImpactCard('3,200 L', 'Water Conserved', Icons.water_drop_rounded, const Color(0xFF0284C7), isDark)),
                const SizedBox(width: 10),
                Expanded(child: _buildImpactCard('140 kWh', 'Energy Saved', Icons.bolt_rounded, const Color(0xFFD97706), isDark)),
              ],
            ),

            const SizedBox(height: 22),

            // 3. Refer & Earn Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0284C7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Refer & Earn ₹50 Each',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0369A1),
                              ),
                            ),
                            const Text(
                              'When your friend completes their 1st pickup',
                              style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF93C5FD)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('YOUR REFERRAL CODE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                            const SizedBox(height: 2),
                            Text(
                              _referralCode,
                              style: GoogleFonts.spaceMono(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0284C7),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Referral code copied to clipboard!')),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 14),
                          label: const Text('Copy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Redeem Rewards & Coupons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Redeem Points',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${_coupons.length} available',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(_coupons.length, (index) {
              final item = _coupons[index];
              final isRedeemed = item['redeemed'] as bool;
              final canAfford = _ecoPoints >= (item['cost'] as int);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['tag'] as String,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: item['color'] as Color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['partner'] as String,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: isRedeemed ? null : () => _redeemCoupon(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRedeemed
                            ? Colors.grey.shade400
                            : (canAfford ? ScrapAppTheme.primaryGreen : Colors.grey.shade300),
                        foregroundColor: isRedeemed || !canAfford ? Colors.white : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        isRedeemed ? 'Redeemed' : '${item['cost']} pts',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(String value, String label, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
