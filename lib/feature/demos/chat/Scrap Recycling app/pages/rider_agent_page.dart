import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';
import '../widgets/digital_signature_pad.dart';

class RiderAgentPage extends StatefulWidget {
  const RiderAgentPage({super.key});

  @override
  State<RiderAgentPage> createState() => _RiderAgentPageState();
}

class _RiderAgentPageState extends State<RiderAgentPage> {
  final TextEditingController _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rider = state.riders.first; // Demo active rider: Rajesh Kumar

    // Find assigned or available jobs
    final assignedJobs = state.orders.where((o) =>
      o.status != PickupStatus.completed && o.status != PickupStatus.cancelled
    ).toList();

    final completedJobs = state.orders.where((o) => o.status == PickupStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pickup Agent Portal', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
            Text('${rider.name} • ${rider.vehicleNumber}', style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: Color(0xFF047857)),
                SizedBox(width: 4),
                Text('ON DUTY', style: TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rider Dashboard Summary Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF047857)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF047857).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricTile('Assigned Pickups', '${assignedJobs.length}', Icons.assignment_rounded),
                      _buildMetricTile('Completed Today', '${completedJobs.length}', Icons.task_alt_rounded),
                      _buildMetricTile('Daily Earnings', '₹1,850', Icons.currency_rupee_rounded),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Digital Scale Status: Calibrated & Ready',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34D399),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('BLUETOOTH CONNECTED', style: TextStyle(color: Color(0xFF064E3B), fontSize: 9, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Active or Assigned Jobs Section
            Text(
              'Assigned Pickup Tasks (${assignedJobs.length})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),

            if (assignedJobs.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Center(
                  child: Text('No active pickups pending. All orders completed!'),
                ),
              )
            else
              ...assignedJobs.map((job) {
                return _buildRiderJobCard(context, state, job, isDark);
              }),

            const SizedBox(height: 20),

            // Past Completed History
            Text(
              'Completed Pickups (${completedJobs.length})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...completedJobs.map((job) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: ScrapAppTheme.primaryGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${job.id} • ${job.userName}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text('${job.actualWeight.toStringAsFixed(1)} kg collected • ₹${job.actualTotal.toStringAsFixed(0)} paid', style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight)),
                        ],
                      ),
                    ),
                    const Text('Completed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ScrapAppTheme.primaryGreen)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF34D399), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildRiderJobCard(BuildContext context, ScrapState state, PickupRequest job, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: job.userRole == UserRole.vendor ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job.userRole == UserRole.vendor ? 'COMMERCIAL BULK' : 'RETAIL HOUSEHOLD',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: job.userRole == UserRole.vendor ? const Color(0xFF92400E) : const Color(0xFF047857),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: job.status.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: job.status.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${job.userName} • Order #${job.id}',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: ScrapAppTheme.textSubLight),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  job.address.fullAddress,
                  style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time_filled_rounded, size: 14, color: ScrapAppTheme.textSubLight),
              const SizedBox(width: 4),
              Text(
                'Slot: ${job.slotDate} • ${job.slotTime}',
                style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
              ),
            ],
          ),

          const Divider(height: 20),

          // Action Workflow Buttons based on status
          if (job.status == PickupStatus.requested || job.status == PickupStatus.accepted) ...[
            ElevatedButton.icon(
              onPressed: () {
                state.advanceOrderStatus(job.id); // moves to riderAssigned or onTheWay
                state.advanceOrderStatus(job.id);
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Accept Job & Start Navigation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ScrapAppTheme.primaryGreen,
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ] else if (job.status == PickupStatus.riderAssigned || job.status == PickupStatus.onTheWay) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Starting Google Maps navigation to ${job.address.fullAddress}...')),
                      );
                    },
                    icon: const Icon(Icons.navigation_rounded, size: 16),
                    label: const Text('Navigate (Map)'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      state.advanceOrderStatus(job.id); // moves to reached
                    },
                    icon: const Icon(Icons.scale_rounded, size: 16),
                    label: const Text('Arrived: Weigh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ScrapAppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (job.status == PickupStatus.reached) ...[
            // Weighing Input Dialog trigger
            ElevatedButton.icon(
              onPressed: () => _showWeighingModal(context, state, job),
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Enter Digital Scale Weights & Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ScrapAppTheme.accentAmberDark,
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showWeighingModal(BuildContext context, ScrapState state, PickupRequest job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actual Scale Weighing',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  'Enter verified weight from electronic scale for order #${job.id}',
                  style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight),
                ),
                const SizedBox(height: 14),

                ...job.items.map((it) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.material.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              Text('Rate: ₹${it.appliedRate.toInt()}/${it.material.unit}', style: const TextStyle(fontSize: 11, color: ScrapAppTheme.primaryGreen)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: (it.actualQty ?? it.estimatedQty).toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              suffixText: it.material.unit,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onChanged: (val) {
                              final d = double.tryParse(val) ?? it.estimatedQty;
                              state.riderUpdateItemWeight(job.id, it.material.id, d);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 14),

                // Customer OTP Entry
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Enter Customer 4-Digit OTP',
                    hintText: 'e.g. ${job.otp}',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: TextButton(
                      onPressed: () => _otpCtrl.text = job.otp,
                      child: const Text('Auto-fill OTP'),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Digital signature pad
                const Text('Customer Signature Verification:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 6),
                const DigitalSignaturePad(),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    state.riderCompletePickup(job.id);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pickup marked complete! Payout released to customer.'),
                        backgroundColor: ScrapAppTheme.primaryGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Complete Pickup & Confirm Settlement'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ScrapAppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
