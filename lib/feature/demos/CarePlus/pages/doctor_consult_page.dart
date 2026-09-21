import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/health_card.dart';
import '../widgets/emergency_card.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/section_header.dart';
import '../widgets/doctor_profile_card.dart';
import '../services/doctor_consultation_service.dart';

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
  // 0: Diabetes, 1: Other
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    final lower = widget.initialSpecialty.toLowerCase();
    if (lower.contains('diabet') || lower.contains('sugar') || lower.contains('endocrin') || lower.contains('glucose')) {
      _selectedTab = 0;
    } else {
      _selectedTab = 1;
    }
  }

  void _callHelpline(String number) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('Calling Helpline')),
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

    final isDiabetesTab = _selectedTab == 0;
    final doctors = isDiabetesTab
        ? DoctorConsultationService.diabetesDoctors
        : DoctorConsultationService.otherDoctors;

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
              // Top 2 Tabs: Diabetes & Other
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    // Tab 1: Diabetes
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _selectedTab = 0),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isDiabetesTab ? const Color(0xFF0369A1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isDiabetesTab
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF0369A1).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.water_drop_outlined,
                                size: 18,
                                color: isDiabetesTab
                                    ? Colors.white
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    state.tr('tab_diabetes'),
                                    style: TextStyle(
                                      fontSize: 13.5 * state.fontScale,
                                      fontWeight: isDiabetesTab ? FontWeight.w800 : FontWeight.w600,
                                      color: isDiabetesTab
                                          ? Colors.white
                                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Tab 2: Other
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _selectedTab = 1),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isDiabetesTab ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !isDiabetesTab
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_services_rounded,
                                size: 18,
                                color: !isDiabetesTab
                                    ? Colors.white
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    state.tr('tab_other'),
                                    style: TextStyle(
                                      fontSize: 13.5 * state.fontScale,
                                      fontWeight: !isDiabetesTab ? FontWeight.w800 : FontWeight.w600,
                                      color: !isDiabetesTab
                                          ? Colors.white
                                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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

              // Doctors List Header
              SectionHeader(
                title: isDiabetesTab ? state.tr('diabetes_specialists_title') : state.tr('other_specialists_title'),
                subtitle: isDiabetesTab
                    ? 'Book appointments with certified Diabetologists & Endocrinologists'
                    : 'Book appointments with verified specialists',
                icon: isDiabetesTab ? Icons.water_drop_outlined : Icons.medical_services_outlined,
              ),

              ...doctors.map((doc) => DoctorProfileCard(doctor: doc)),
              const SizedBox(height: 14),

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
