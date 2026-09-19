import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';
import 'custom_button.dart';

class EmergencyCard extends StatelessWidget {
  final List<String> redFlags;
  final VoidCallback onCallEmergency;
  final VoidCallback? onFindHospital;

  const EmergencyCard({
    super.key,
    this.redFlags = const [],
    required this.onCallEmergency,
    this.onFindHospital,
  });

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);

    return HealthCard(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(vertical: 8),
      backgroundColor: const Color(0xFFFEF2F2),
      border: Border.all(color: AppColors.emergency, width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.emergency,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.emergency_rounded, size: 26, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.tr('emergency_alert_title'),
                      style: TextStyle(
                        fontSize: 16 * state.fontScale,
                        fontWeight: FontWeight.w800,
                        color: AppColors.emergencyDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'High Risk / Immediate Attention Required',
                      style: TextStyle(
                        fontSize: 12 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emergency,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            state.tr('emergency_alert_msg'),
            style: TextStyle(
              fontSize: 13.5 * state.fontScale,
              color: const Color(0xFF7F1D1D),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          if (redFlags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: redFlags
                    .map((flag) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.priority_high_rounded, size: 14, color: AppColors.emergency),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  flag,
                                  style: TextStyle(
                                    fontSize: 12 * state.fontScale,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.emergencyDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          CustomButton(
            text: 'Call Emergency (${state.emergencyNumber})',
            icon: Icons.phone_in_talk_rounded,
            variant: ButtonVariant.emergency,
            onPressed: onCallEmergency,
          ),
        ],
      ),
    );
  }
}
