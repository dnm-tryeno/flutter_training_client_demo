import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

    // Calculate Admin KPIs
    final totalRequests = state.orders.length;
    final activeRequests = state.orders.where((o) =>
      o.status != PickupStatus.completed && o.status != PickupStatus.cancelled
    ).length;
    double totalTonnage = 0.0;
    double totalDisbursed = 0.0;
    for (final o in state.orders) {
      totalTonnage += o.actualWeight;
      if (o.status == PickupStatus.completed) {
        totalDisbursed += o.actualTotal;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Command Center', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
            const Text('HQ Dispatch & Rate Control Panel', style: TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ScrapAppTheme.primaryGreen,
          unselectedLabelColor: ScrapAppTheme.textSubLight,
          indicatorColor: ScrapAppTheme.primaryGreen,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Requests & Fleet'),
            Tab(text: 'Scrap Rates & Slabs'),
            Tab(text: 'Vendor Approvals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Requests & Fleet Dispatch
          _buildRequestsAndFleetTab(context, state, isDark, totalRequests, activeRequests, totalTonnage, totalDisbursed),

          // TAB 2: Scrap Rates & Slabs Management
          _buildRatesManagementTab(context, state, isDark),

          // TAB 3: Vendor Commercial Godown Approvals
          _buildVendorApprovalsTab(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildRequestsAndFleetTab(
    BuildContext context,
    ScrapState state,
    bool isDark,
    int totalRequests,
    int activeRequests,
    double totalTonnage,
    double totalDisbursed,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // KPI Metric Grid
          Row(
            children: [
              Expanded(
                child: _buildAdminKpiCard(
                  'Active Bookings',
                  '$activeRequests pending',
                  Icons.pending_actions_rounded,
                  const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAdminKpiCard(
                  'Tonnage Collected',
                  '${(totalTonnage / 1000).toStringAsFixed(2)} Tonnes',
                  Icons.scale_rounded,
                  const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildAdminKpiCard(
                  'Payouts Disbursed',
                  '₹${totalDisbursed.toStringAsFixed(0)}',
                  Icons.payments_rounded,
                  const Color(0xFF047857),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAdminKpiCard(
                  'Field Riders',
                  '${state.riders.length} Active',
                  Icons.two_wheeler_rounded,
                  const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // All Pickup Requests List with Assign Action
          Text(
            'Dispatch Queue (${state.orders.length})',
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          ...state.orders.map((order) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCBD5E1)),
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
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: order.status.color),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.userRole == UserRole.vendor ? 'Commercial Bulk' : 'Retail',
                            style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: order.status.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status.label,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: order.status.color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.userName} • ${order.userPhone}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  Text(
                    'Address: ${order.address.fullAddress}',
                    style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                  ),
                  Text(
                    'Slot: ${order.slotDate} • ${order.slotTime}',
                    style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                  ),
                  Text(
                    'Items: ${order.items.map((i) => "${i.material.name} (${i.estimatedQty.toInt()}${i.material.unit})").join(", ")}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),

                  const Divider(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assigned Rider: ${order.assignedRider?.name ?? "Unassigned"}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: order.assignedRider != null ? ScrapAppTheme.primaryGreen : Colors.orange,
                        ),
                      ),
                      if (order.status == PickupStatus.requested)
                        ElevatedButton(
                          onPressed: () => _showAssignRiderDialog(context, state, order),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ScrapAppTheme.primaryGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Assign Rider', style: TextStyle(fontSize: 11)),
                        )
                      else if (order.status != PickupStatus.completed)
                        OutlinedButton(
                          onPressed: () {
                            state.advanceOrderStatus(order.id);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Advance Status', style: TextStyle(fontSize: 11)),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdminKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
          ),
        ],
      ),
    );
  }

  // TAB 2: Live Rate Control
  Widget _buildRatesManagementTab(BuildContext context, ScrapState state, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.materials.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final mat = state.materials[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: mat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(mat.icon, color: mat.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mat.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(
                      'Retail: ₹${mat.retailRate.toStringAsFixed(0)}/${mat.unit} • ${mat.vendorSlabs.length} Bulk Slabs',
                      style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: ScrapAppTheme.primaryGreen, size: 20),
                tooltip: 'Edit Scrap Rate',
                onPressed: () => _showEditRateDialog(context, state, mat),
              ),
            ],
          ),
        );
      },
    );
  }

  // TAB 3: Vendor Commercial Approvals
  Widget _buildVendorApprovalsTab(BuildContext context, ScrapState state, bool isDark) {
    final vendor = state.vendorProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Commercial Vendor Godown Registrations',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(vendor.businessName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('APPROVED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF047857))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Owner: ${vendor.ownerName} • Phone: ${vendor.phone}', style: const TextStyle(fontSize: 12)),
                Text('GSTIN: ${vendor.gstin}', style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight)),
                Text('Godown: ${vendor.godownAddress}, ${vendor.city}', style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight)),
                Text('Partner Tier: ${vendor.tier}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ScrapAppTheme.primaryGreen)),
                const Divider(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Commercial bulk rates slab verified.')),
                        );
                      },
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text('Verified Partner', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(backgroundColor: ScrapAppTheme.primaryGreen),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Godown GST & weighbridge documents verified.')),
                        );
                      },
                      child: const Text('View Godown KYC', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignRiderDialog(BuildContext context, ScrapState state, PickupRequest order) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Assign Rider to ${order.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: state.riders.map((r) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.two_wheeler)),
                title: Text(r.name),
                subtitle: Text('${r.vehicleModel} • ⭐${r.rating}'),
                onTap: () {
                  state.adminAssignRider(order.id, r);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Assigned ${r.name} to pickup #${order.id}')),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showEditRateDialog(BuildContext context, ScrapState state, ScrapMaterial mat) {
    final ctrl = TextEditingController(text: mat.retailRate.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Update Rate: ${mat.name}'),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Retail Rate (₹ / ${mat.unit})',
              prefixText: '₹ ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final d = double.tryParse(ctrl.text);
                if (d != null && d > 0) {
                  state.adminUpdateRate(mat.id, d);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save Rate'),
            ),
          ],
        );
      },
    );
  }
}
