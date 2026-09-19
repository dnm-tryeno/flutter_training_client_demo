import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/health_card.dart';
import '../widgets/emergency_card.dart';
import '../widgets/disclaimer_banner.dart';

class DoctorConsultPage extends StatefulWidget {
  final String initialSpecialty;
  final bool showEmergencyFirst;

  const DoctorConsultPage({
    super.key,
    this.initialSpecialty = 'General Physician',
    this.showEmergencyFirst = false,
  });

  @override
  State<DoctorConsultPage> createState() => _DoctorConsultPageState();
}

class _DoctorConsultPageState extends State<DoctorConsultPage> {
  void _callHelpline(String number) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('Calling Helpline'),
          ],
        ),
        content: Text('Dialing emergency/medical helpline: $number...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('End Call'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.tr('doctor_title'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency Section
              EmergencyCard(
                redFlags: const [
                  'Severe crushing chest pain or pressure',
                  'Acute breathing difficulty or wheezing',
                  'Sudden loss of speech, facial droop, or limb weakness',
                ],
                onCallEmergency: () => _callHelpline(state.emergencyNumber),
                onFindHospital: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nearest hospital: Metro Multi-Speciality Hospital (1.2 km away)'),
                      backgroundColor: AppColors.emergency,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Helpline Banner
              HealthCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.support_agent_rounded, size: 24, color: AppColors.secondary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'National Tele-Health Helpline',
                            style: TextStyle(
                              fontSize: 14 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Toll-Free 24x7 Medical Guidance',
                            style: TextStyle(
                              fontSize: 12 * state.fontScale,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _callHelpline('104 / 1075'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: const Text('Call 104', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Compact Medical Disclaimer
              const DisclaimerBanner(compact: true),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
