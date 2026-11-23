import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class RequestBookingPage extends StatefulWidget {
  final Function(PickupRequest) onBookingCompleted;

  const RequestBookingPage({
    super.key,
    required this.onBookingCompleted,
  });

  @override
  State<RequestBookingPage> createState() => _RequestBookingPageState();
}

class _RequestBookingPageState extends State<RequestBookingPage> {
  int _currentStep = 0;
  final TextEditingController _notesCtrl = TextEditingController();

  final List<String> _dateOptions = [
    'Today, 24 Sep',
    'Tomorrow, 25 Sep',
    'Saturday, 26 Sep',
    'Sunday, 27 Sep',
  ];

  final List<String> _slotOptions = [
    '09:00 AM - 12:00 PM (Morning)',
    '12:00 PM - 03:00 PM (Afternoon)',
    '03:00 PM - 06:00 PM (Evening)',
  ];

  final List<String> _paymentOptions = [
    'Instant UPI (PhonePe/GPay)',
    'Cash on Weighing',
    'Direct Bank NEFT / IMPS',
  ];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.previewMode == UserRole.vendor ? 'Book Bulk Godown Pickup' : 'Schedule Scrap Pickup',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        actions: [
          if (state.cartQuantities.isNotEmpty)
            TextButton(
              onPressed: () {
                state.clearCart();
              },
              child: const Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Step Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            child: Row(
              children: [
                _buildStepBubble(0, 'Materials', Icons.checklist_rounded),
                _buildStepDivider(0),
                _buildStepBubble(1, 'Address & Slot', Icons.calendar_today_rounded),
                _buildStepDivider(1),
                _buildStepBubble(2, 'Review', Icons.check_circle_outline_rounded),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(state, isDark),
            ),
          ),

          // Bottom Bar with calculation and Next/Submit CTA
          _buildBottomAction(state, isDark),
        ],
      ),
    );
  }

  Widget _buildStepBubble(int stepIndex, String title, IconData icon) {
    final isCompleted = _currentStep > stepIndex;
    final isCurrent = _currentStep == stepIndex;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted || isCurrent ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check_rounded : icon,
            size: 16,
            color: isCompleted || isCurrent ? Colors.white : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
            color: isCurrent ? ScrapAppTheme.primaryGreen : ScrapAppTheme.textSubLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(int afterStep) {
    final isPassed = _currentStep > afterStep;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 2,
        color: isPassed ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildStepContent(ScrapState state, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildMaterialSelectionStep(state, isDark);
      case 1:
        return _buildAddressAndSlotStep(state, isDark);
      case 2:
        return _buildReviewStep(state, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 0: Material and Weight Selection
  Widget _buildMaterialSelectionStep(ScrapState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Materials & Quantities',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${state.cartQuantities.length} items added',
                style: const TextStyle(
                  color: ScrapAppTheme.primaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'You can add multiple scrap items in a single pickup request.',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: ScrapAppTheme.textSubLight),
        ),
        const SizedBox(height: 14),

        // List of all materials with quick add/qty counters
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.materials.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final mat = state.materials[index];
            final inCart = state.cartQuantities.containsKey(mat.id);
            final qty = state.cartQuantities[mat.id] ?? 0.0;
            final applicableRate = mat.getRateFor(qty > 0 ? qty : 10, state.previewMode);

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: inCart ? const Color(0xFFF0FDF4) : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: inCart ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
                  width: inCart ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        mat.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: mat.color.withValues(alpha: 0.15),
                            child: Icon(mat.icon, color: mat.color, size: 24),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '₹${applicableRate.toStringAsFixed(0)} / ${mat.unit}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: ScrapAppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!inCart)
                    ElevatedButton(
                      onPressed: () {
                        state.updateCartQuantity(
                          mat.id,
                          state.previewMode == UserRole.vendor ? 250.0 : (mat.unit == 'kg' ? 10.0 : 1.0),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScrapAppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('+ Add', style: TextStyle(fontSize: 11)),
                    )
                  else
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            final step = state.previewMode == UserRole.vendor
                                ? 50.0
                                : (mat.unit == 'kg' ? 5.0 : 1.0);
                            state.updateCartQuantity(mat.id, qty - step);
                          },
                          icon: const Icon(Icons.remove_circle_outline_rounded, size: 22, color: Colors.red),
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
                            final step = state.previewMode == UserRole.vendor
                                ? 50.0
                                : (mat.unit == 'kg' ? 5.0 : 1.0);
                            state.updateCartQuantity(mat.id, qty + step);
                          },
                          icon: const Icon(Icons.add_circle_outline_rounded, size: 22, color: ScrapAppTheme.primaryGreen),
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
      ],
    );
  }

  // STEP 1: Address and Time Slot
  Widget _buildAddressAndSlotStep(ScrapState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Pickup Location',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: state.addresses.map((addr) {
            final isSel = addr.id == state.selectedAddress.id;
            return InkWell(
              onTap: () => state.setSelectedAddress(addr),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFFF0FDF4) : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSel ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
                    width: isSel ? 2 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isSel ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: isSel ? ScrapAppTheme.primaryGreen : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                addr.label,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                              if (addr.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('DEFAULT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addr.fullAddress,
                            style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight),
                          ),
                          Text(
                            'Landmark: ${addr.landmark} • ${addr.city} (${addr.pincode})',
                            style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        Text(
          'Select Pickup Date',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _dateOptions.map((date) {
              final isSel = date == state.bookingDate;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: isSel,
                  onSelected: (val) {
                    if (val) state.setBookingDate(date);
                  },
                  label: Text(date),
                  selectedColor: ScrapAppTheme.primaryGreen,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : ScrapAppTheme.textMainLight,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Preferred Time Slot',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: _slotOptions.map((slot) {
            final isSel = slot == state.bookingSlot;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSel ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
                    width: isSel ? 1.5 : 1,
                  ),
                ),
                tileColor: isSel ? const Color(0xFFF0FDF4) : (isDark ? const Color(0xFF1E293B) : Colors.white),
                leading: Icon(
                  Icons.access_time_filled_rounded,
                  color: isSel ? ScrapAppTheme.primaryGreen : ScrapAppTheme.textSubLight,
                ),
                title: Text(slot, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                trailing: isSel ? const Icon(Icons.check_circle_rounded, color: ScrapAppTheme.primaryGreen) : null,
                onTap: () => state.setBookingSlot(slot),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 2: Payment, Optional Photos & Summary
  Widget _buildReviewStep(ScrapState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Order Card
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
              Text(
                'Materials Breakdown',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              const Divider(height: 20),
              ...state.cartQuantities.entries.map((entry) {
                final mat = state.materials.firstWhere((m) => m.id == entry.key);
                final qty = entry.value;
                final rate = mat.getRateFor(qty, state.previewMode);
                final total = qty * rate;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${mat.name} (${qty.toInt()} ${mat.unit} × ₹$rate)'),
                      Text(
                        '₹${total.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Scrap Value'),
                  Text(
                    '₹${state.cartEstimatedTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Doorstep Pickup Fee'),
                  Text(
                    state.calculatedPickupFee == 0.0 ? 'FREE' : '₹${state.calculatedPickupFee.toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: state.calculatedPickupFee == 0.0 ? ScrapAppTheme.primaryGreen : Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Estimated Cash Payout',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  Text(
                    '₹${(state.cartEstimatedTotal - state.calculatedPickupFee).toStringAsFixed(0)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: ScrapAppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Payment Method Preference
        Text(
          'Payout Settlement Method',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Column(
          children: _paymentOptions.map((pay) {
            final isSel = pay == state.paymentMethod;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSel ? ScrapAppTheme.primaryGreen : const Color(0xFFE2E8F0),
                  ),
                ),
                tileColor: isSel ? const Color(0xFFF0FDF4) : (isDark ? const Color(0xFF1E293B) : Colors.white),
                leading: Icon(
                  pay.contains('UPI') ? Icons.qr_code_rounded : (pay.contains('Cash') ? Icons.payments_rounded : Icons.account_balance_rounded),
                  color: isSel ? ScrapAppTheme.primaryGreen : ScrapAppTheme.textSubLight,
                ),
                title: Text(pay, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                trailing: isSel ? const Icon(Icons.check_circle_rounded, color: ScrapAppTheme.primaryGreen) : null,
                onTap: () => state.setPaymentMethod(pay),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Optional Scrap Photos simulation
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.camera_alt_rounded, color: ScrapAppTheme.primaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Attach Scrap Photos (Optional)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(
                      state.attachedPhotosCount > 0 ? '${state.attachedPhotosCount} photos attached' : 'Helps rider arrange vehicle space',
                      style: const TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  final newCount = state.attachedPhotosCount == 0 ? 2 : 0;
                  state.setAttachedPhotosCount(newCount);
                },
                child: Text(state.attachedPhotosCount > 0 ? 'Remove' : '+ Add Photos'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Special Instructions / Notes
        TextField(
          controller: _notesCtrl,
          decoration: const InputDecoration(
            labelText: 'Special Pickup Instructions (Optional)',
            hintText: 'e.g. Call before coming, gate password...',
            prefixIcon: Icon(Icons.note_alt_rounded, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(ScrapState state, bool isDark) {
    final canProceed = state.cartQuantities.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                child: const Text('Back'),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                        if (_currentStep < 2) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          _confirmAndSubmitBooking(state);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ScrapAppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  _currentStep == 2 ? 'Confirm & Book Pickup' : 'Continue (${state.cartQuantities.length} items)',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAndSubmitBooking(ScrapState state) {
    final newOrder = state.submitBooking(notes: _notesCtrl.text.trim());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: ScrapAppTheme.primaryGreen, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Pickup Request Confirmed!',
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Booking ID: ${newOrder.id}',
                style: const TextStyle(fontWeight: FontWeight.w800, color: ScrapAppTheme.primaryGreen),
              ),
              const SizedBox(height: 10),
              Text(
                'Our dispatch hub has received your request. Pickup Agent will arrive on ${newOrder.slotDate} during ${newOrder.slotTime}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx); // close dialog
                  widget.onBookingCompleted(newOrder);
                },
                icon: const Icon(Icons.location_searching_rounded),
                label: const Text('Track Order Live'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ScrapAppTheme.primaryGreen,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
