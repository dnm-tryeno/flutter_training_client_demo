import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../services/doctor_consultation_service.dart';
import 'health_card.dart';

class DoctorProfileCard extends StatelessWidget {
  final DoctorProfile doctor;
  final VoidCallback? onBook;
  final VoidCallback? onCall;

  const DoctorProfileCard({
    super.key,
    required this.doctor,
    this.onBook,
    this.onCall,
  });

  void _showBookingDialog(BuildContext context, CarePlusState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.event_available_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('Book Consultation')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Text(
              doctor.specialty,
              style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Next Slot: ${doctor.availableTime}',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text('Consultation Fee:')),
                Text(
                  doctor.consultationFee,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.healthGreen, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment request sent to ${doctor.name}! You will receive SMS confirmation.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Confirm Appointment'),
          ),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('Calling Clinic')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connecting to ${doctor.name}\'s clinic desk...'),
            const SizedBox(height: 8),
            Text(
              doctor.clinicHospital,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return HealthCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: doctor.isDiabetesExpert
                    ? const Color(0xFF0369A1).withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  doctor.avatarInitials,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: doctor.isDiabetesExpert ? const Color(0xFF0369A1) : AppColors.primary,
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
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: TextStyle(
                              fontSize: 14.5 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${doctor.rating}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.amber),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        fontSize: 12.5 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: doctor.isDiabetesExpert ? const Color(0xFF0369A1) : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${doctor.qualification} • ${doctor.experienceYears} yrs exp',
                      style: TextStyle(
                        fontSize: 11.5 * state.fontScale,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    doctor.clinicHospital,
                    style: TextStyle(
                      fontSize: 11.5 * state.fontScale,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  doctor.consultationFee,
                  style: TextStyle(
                    fontSize: 12 * state.fontScale,
                    fontWeight: FontWeight.w700,
                    color: AppColors.healthGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall ?? () => _showCallDialog(context),
                  icon: const Icon(Icons.phone_outlined, size: 16),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      state.tr('call_clinic'),
                      style: TextStyle(fontSize: 12 * state.fontScale, fontWeight: FontWeight.w700),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    side: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onBook ?? () => _showBookingDialog(context, state),
                  icon: const Icon(Icons.calendar_today_rounded, size: 15),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      state.tr('book_appointment'),
                      style: TextStyle(fontSize: 12 * state.fontScale, fontWeight: FontWeight.w700),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: doctor.isDiabetesExpert ? const Color(0xFF0369A1) : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
