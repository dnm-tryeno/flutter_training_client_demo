import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../widgets/please_keep_in_mind_sheet.dart';
import 'material_selection_page.dart';

class CustomerHomePage extends StatefulWidget {
  final VoidCallback onOpenBookPickup;
  final VoidCallback onOpenRateCard;
  final VoidCallback? onOpenOrderHistory;
  final Function(PickupRequest) onOpenOrderTracking;

  const CustomerHomePage({
    super.key,
    required this.onOpenBookPickup,
    required this.onOpenRateCard,
    this.onOpenOrderHistory,
    required this.onOpenOrderTracking,
  });

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  ScrapCategoryType? _selectedCategory;

  void _openSelectionWorkflow(ScrapCategoryType category) {
    PleaseKeepInMindSheet.show(
      context,
      onProceed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => MaterialSelectionPage(initialCategory: category),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);

    // Active order check
    final activeOrders = state.orders.where((o) =>
      o.status != PickupStatus.completed && o.status != PickupStatus.cancelled
    ).toList();
    final latestActiveOrder = activeOrders.isNotEmpty ? activeOrders.first : null;

    // Trending items (from Screenshot 2)
    final trendingList = state.materials.where((m) =>
      m.id == 'ewaste_monitor_crt' ||
      m.id == 'ewaste_printer' ||
      m.id == 'others_inverter_battery' ||
      m.id == 'ewaste_monitor_lcd' ||
      m.id == 'others_alkaline_cell'
    ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top Location Picker Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF0284C7), size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => _showLocationSelector(context, state),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    state.currentCity,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E293B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFF64748B)),
                              ],
                            ),
                          ),
                        ),
                        if (widget.onOpenOrderHistory != null)
                          IconButton(
                            icon: Badge(
                              isLabelVisible: activeOrders.isNotEmpty,
                              label: Text('${activeOrders.length}'),
                              backgroundColor: const Color(0xFF1E7E34),
                              child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF1E293B), size: 22),
                            ),
                            tooltip: 'My Pickups',
                            onPressed: widget.onOpenOrderHistory,
                          ),
                      ],
                    ),
                  ),

                  // 2. Blue Hero Banner ("Sell scrap in seconds!")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          // Right Collage Photo
                          Positioned(
                            right: -10,
                            top: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                              child: Opacity(
                                opacity: 0.95,
                                child: Image.asset(
                                  'assets/images/scrap/hero_scrap_3d.png',
                                  width: 175,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Subtle Dark overlay on image side
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF0284C7),
                                    const Color(0xFF0284C7).withValues(alpha: 0.85),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Left Content
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sell scrap in\nseconds!',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    _openSelectionWorkflow(_selectedCategory ?? ScrapCategoryType.paper);
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Sell Now',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                                      ],
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

                  // 3. Purple "Continue where you left off?" Card (if order exists or draft)
                  if (latestActiveOrder != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: InkWell(
                        onTap: () => widget.onOpenOrderTracking(latestActiveOrder),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: Color(0xFFFDE68A), size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Continue where you left off?',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Order #${latestActiveOrder.id} is in progress (${latestActiveOrder.status.label}).',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  // 4. Section: "What do you want to sell?"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What do you want to sell?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Select scrap categories you want to sell',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 5. 3x2 Grid of Category Cards (Exact matching Screenshot 1 & 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: ScrapCategoryType.values.length,
                      itemBuilder: (context, index) {
                        final cat = ScrapCategoryType.values[index];
                        final isSelected = cat == _selectedCategory;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (_selectedCategory == cat) {
                                _selectedCategory = null;
                              } else {
                                _selectedCategory = cat;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF1E7E34) : const Color(0xFFE2E8F0),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Category Image Cutout
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            cat.assetPath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      // Top Right Radio Button Circle when selected
                                      if (isSelected)
                                        Positioned(
                                          top: 7,
                                          right: 7,
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1E7E34),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cat.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 6. Section: "Trending rates" (Matching Screenshot 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trending rates',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'These rates are provided by The Kabadiwala in your area',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3-Column Grid of Trending Rates Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: trendingList.length,
                      itemBuilder: (context, index) {
                        final it = trendingList[index];

                        return InkWell(
                          onTap: () {
                            _openSelectionWorkflow(it.category);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Image.asset(
                                        it.displayAsset,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                it.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹${it.retailRate.toInt()}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    '/${it.unit}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 7. Blue Info Banner (Matching Screenshot 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0369A1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'These rates are for regular quantities. For bulk quantities (100+ kg), you will get better rates.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              state.setRole(UserRole.vendor);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0369A1),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Get Bulk Quote',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 8. Section: "Sell bulk scrap"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sell bulk scrap',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Got 100+ kg of scrap? List it and get better rates.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildFeaturePill(Icons.star_rounded, 'BEST RATES', const Color(0xFFD97706)),
                            const SizedBox(width: 8),
                            _buildFeaturePill(Icons.assignment_turned_in_rounded, 'COMPLIANCE', const Color(0xFF047857)),
                            const SizedBox(width: 8),
                            _buildFeaturePill(Icons.search_rounded, 'TRANSPARENT', const Color(0xFF0284C7)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 9. Section: "Refer your friends & Earn"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer your friends & Earn',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Earn ₹100 on each successful referral.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 10. Floating Green Bottom Action Bar (Matching Screenshot 3)
            if (_selectedCategory != null) ...[
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E7E34),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E7E34).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Circular category thumbnail
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  _selectedCategory!.assetPath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _selectedCategory!.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // "Sell Now" white button
                          ElevatedButton(
                            onPressed: () {
                              _openSelectionWorkflow(_selectedCategory!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1E7E34),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              elevation: 0,
                            ),
                            child: Text(
                              'Sell Now',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E7E34),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Close "X" button
                    Positioned(
                      top: -10,
                      right: 12,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E293B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                        ),
                      ),
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

  Widget _buildFeaturePill(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationSelector(BuildContext context, ScrapState state) {
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
                'Select Operating City',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _buildCityTile(ctx, state, 'Pune, Ambegaon Budruk', '411046'),
              _buildCityTile(ctx, state, 'Indiranagar, Bengaluru', '560001'),
              _buildCityTile(ctx, state, 'Connaught Place, New Delhi', '110001'),
              _buildCityTile(ctx, state, 'Andheri West, Mumbai', '400053'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCityTile(BuildContext ctx, ScrapState state, String city, String pincode) {
    final isSelected = state.currentCity == city;
    return ListTile(
      leading: const Icon(Icons.location_city_rounded, color: Color(0xFF1E7E34)),
      title: Text(city, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text('Pincode: $pincode'),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1E7E34)) : null,
      onTap: () {
        state.setLocation(city, pincode);
        Navigator.pop(ctx);
      },
    );
  }
}
