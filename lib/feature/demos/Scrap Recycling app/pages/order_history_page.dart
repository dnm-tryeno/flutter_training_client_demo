import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class OrderHistoryPage extends StatefulWidget {
  final Function(PickupRequest) onOpenOrderTracking;

  const OrderHistoryPage({
    super.key,
    required this.onOpenOrderTracking,
  });

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeOrders = state.orders.where((o) =>
      o.status != PickupStatus.completed && o.status != PickupStatus.cancelled
    ).toList();

    final completedOrders = state.orders.where((o) =>
      o.status == PickupStatus.completed || o.status == PickupStatus.cancelled
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Scrap Pickups',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ScrapAppTheme.primaryGreen,
          unselectedLabelColor: ScrapAppTheme.textSubLight,
          indicatorColor: ScrapAppTheme.primaryGreen,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Active (${activeOrders.length})'),
            Tab(text: 'Completed (${completedOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Pickups Tab
          activeOrders.isEmpty
              ? _buildEmptyState('No active pickup requests', 'Book a scrap pickup to get started.')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = activeOrders[index];
                    return _buildOrderCard(context, state, order, isDark, false);
                  },
                ),

          // Completed Pickups Tab
          completedOrders.isEmpty
              ? _buildEmptyState('No completed orders yet', 'Your past transactions will appear here.')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: completedOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = completedOrders[index];
                    return _buildOrderCard(context, state, order, isDark, true);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 56, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, ScrapState state, PickupRequest order, bool isDark, bool isCompleted) {
    return InkWell(
      onTap: () {
        if (!isCompleted) {
          widget.onOpenOrderTracking(order);
        } else {
          _showDigitalInvoiceReceipt(context, order);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: order.status.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.id,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: order.status.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.slotDate,
                      style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: order.status.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: order.status.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              order.items.map((i) => i.material.name).join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${order.actualWeight > 0 ? order.actualWeight.toStringAsFixed(1) : order.estimatedWeight.toStringAsFixed(1)} kg total scrap',
              style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
            ),
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Payout', style: TextStyle(fontSize: 10, color: ScrapAppTheme.textSubLight)),
                    Text(
                      '₹${order.actualTotal.toStringAsFixed(0)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ScrapAppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!isCompleted) {
                      widget.onOpenOrderTracking(order);
                    } else {
                      _showDigitalInvoiceReceipt(context, order);
                    }
                  },
                  icon: Icon(
                    isCompleted ? Icons.receipt_long_rounded : Icons.location_searching_rounded,
                    size: 14,
                  ),
                  label: Text(isCompleted ? 'View Receipt' : 'Track Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted ? const Color(0xFFF1F5F9) : ScrapAppTheme.primaryGreen,
                    foregroundColor: isCompleted ? ScrapAppTheme.textMainLight : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDigitalInvoiceReceipt(BuildContext context, PickupRequest order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Computerized Weighing Receipt',
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('KABADA RECYCLING PVT LTD', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        Text('ISO 14001:2015', style: TextStyle(fontSize: 10, color: Color(0xFF047857), fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const Text('GSTIN: 07AABCK9021R1Z8 • Certified Weighbridge', style: TextStyle(fontSize: 10, color: ScrapAppTheme.textSubLight)),
                    const Divider(height: 16),
                    Text('Receipt Ref: ${order.id} • Date: ${order.slotDate}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    Text('Party: ${order.userName} (${order.userPhone})', style: const TextStyle(fontSize: 11)),
                    Text('Pickup Location: ${order.address.fullAddress}', style: const TextStyle(fontSize: 10, color: ScrapAppTheme.textSubLight)),
                    const Divider(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Material Item', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        Text('Weight × Rate = Amount', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...order.items.map((it) {
                      final qty = it.actualQty ?? it.estimatedQty;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(it.material.name, style: const TextStyle(fontSize: 11)),
                            Text('${qty.toStringAsFixed(1)}${it.material.unit} × ₹${it.appliedRate.toInt()} = ₹${(qty * it.appliedRate).toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Net Payout Settled:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        Text('₹${order.actualTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF047857))),
                      ],
                    ),
                    Text('Payment Mode: ${order.paymentMethod} • Status: ${order.paymentStatus}', style: const TextStyle(fontSize: 10, color: ScrapAppTheme.textSubLight)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Official Weighbridge PDF Slip...')),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download Official PDF Slip'),
                style: ElevatedButton.styleFrom(backgroundColor: ScrapAppTheme.primaryGreen),
              ),
            ],
          ),
        );
      },
    );
  }
}
