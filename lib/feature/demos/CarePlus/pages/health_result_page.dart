import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/health_guidance_result.dart';
import '../models/health_check_input.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/food_card.dart';
import '../widgets/yoga_card.dart';
import '../widgets/medicine_safety_card.dart';
import '../widgets/emergency_card.dart';
import '../widgets/health_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/language_selector_button.dart';
import '../services/pdf_report_service.dart';
import '../services/health_suggestion_engine.dart';
import 'doctor_consult_page.dart';
import 'main_navigation_shell.dart';

class HealthResultPage extends StatefulWidget {
  final HealthGuidanceResult result;
  final HealthCheckInput input;

  const HealthResultPage({
    super.key,
    required this.result,
    required this.input,
  });

  @override
  State<HealthResultPage> createState() => _HealthResultPageState();
}

class _HealthResultPageState extends State<HealthResultPage> {
  // 0: Medicine, 1: Food, 2: Yoga, null: collapsed
  int? _selectedCategoryIndex;

  void _shareReport() {
    final reportText = PdfReportService.generateSummaryText(
      profile: widget.input.profile,
      result: widget.result,
    );
    Clipboard.setData(ClipboardData(text: reportText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Health report copied to clipboard. Ready to share with your doctor.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openDoctorConsult(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DoctorConsultPage(
          initialSpecialty: widget.result.recommendedSpecialist,
        ),
      ),
    );
  }

  Widget _buildTopCategoryButton({
    required int index,
    required IconData icon,
    required String label,
    required bool isDark,
    required double fontScale,
  }) {
    final isSelected = _selectedCategoryIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (_selectedCategoryIndex == index) {
                _selectedCategoryIndex = null;
              } else {
                _selectedCategoryIndex = index;
              }
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : AppColors.primary.withValues(alpha: 0.12))
                  : (isDark ? const Color(0xFF1E293B) : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textSecondaryDark : const Color(0xFF475569)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12 * fontScale,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.primary)
                        : (isDark ? AppColors.textSecondaryDark : const Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final res = widget.result;

    Color riskBadgeColor;
    Color riskBadgeBg;

    switch (res.riskLevel) {
      case RiskLevel.low:
        riskBadgeColor = AppColors.healthGreen;
        riskBadgeBg = isDark ? const Color(0xFF064E3B) : AppColors.healthGreenLight;
        break;
      case RiskLevel.moderate:
        riskBadgeColor = AppColors.warning;
        riskBadgeBg = isDark ? const Color(0xFF78350F) : AppColors.warningLight;
        break;
      case RiskLevel.consultDoctor:
        riskBadgeColor = AppColors.secondary;
        riskBadgeBg = isDark ? const Color(0xFF1E3A8A) : AppColors.secondaryLight;
        break;
      case RiskLevel.emergency:
        riskBadgeColor = AppColors.emergency;
        riskBadgeBg = isDark ? const Color(0xFF881337) : AppColors.emergencyLight;
        break;
    }

    final effectiveMeds = res.medicineSafetyItems.isNotEmpty
        ? res.medicineSafetyItems
        : HealthSuggestionEngine.verifiedMedicineDatabase.take(1).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.tr('result_title'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
        actions: [
          const LanguageSelectorButton(),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            tooltip: 'Copy & Share Health Summary',
            onPressed: _shareReport,
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Return Home',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Emergency Banner if Red Flag detected
              if (res.isEmergency) ...[
                EmergencyCard(
                  redFlags: res.emergencyRedFlags,
                  onCallEmergency: () => _openDoctorConsult(context),
                  onFindHospital: () => _openDoctorConsult(context),
                ),
                const SizedBox(height: 12),
              ],

              // 2. Three Guidance Buttons at Top (Medicine, Food, Yoga)
              Row(
                children: [
                  _buildTopCategoryButton(
                    index: 0,
                    icon: Icons.medication_rounded,
                    label: 'Medicine',
                    isDark: isDark,
                    fontScale: state.fontScale,
                  ),
                  const SizedBox(width: 10),
                  _buildTopCategoryButton(
                    index: 1,
                    icon: Icons.restaurant_rounded,
                    label: 'Food & Diet',
                    isDark: isDark,
                    fontScale: state.fontScale,
                  ),
                  const SizedBox(width: 10),
                  _buildTopCategoryButton(
                    index: 2,
                    icon: Icons.self_improvement_rounded,
                    label: 'Yoga & Exercise',
                    isDark: isDark,
                    fontScale: state.fontScale,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3. Dynamic Content Panel for Selected Button
              if (_selectedCategoryIndex != null) ...[
                AnimatedCrossFade(
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedCategoryIndex == 0) ...[
                        Row(
                          children: [
                            const Icon(Icons.medication_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Medicine Safety & Precautions',
                              style: TextStyle(
                                fontSize: 13.5 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...effectiveMeds.map((m) => MedicineSafetyCard(medicine: m)),
                      ] else if (_selectedCategoryIndex == 1) ...[
                        Row(
                          children: [
                            const Icon(Icons.restaurant_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Food & Nutrition (Aahar)',
                              style: TextStyle(
                                fontSize: 13.5 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...res.foodSuggestions.map((f) => FoodCard(food: f)),
                      ] else if (_selectedCategoryIndex == 2) ...[
                        Row(
                          children: [
                            const Icon(Icons.self_improvement_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Yoga & Gentle Exercise',
                              style: TextStyle(
                                fontSize: 13.5 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...res.yogaExercises.map((y) => YogaCard(yoga: y)),
                      ],
                      const SizedBox(height: 12),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState: _selectedCategoryIndex != null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                ),
              ],

              // 5. Problem Summary Card
              HealthCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Problem Summary',
                              style: TextStyle(
                                fontSize: 12 * state.fontScale,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: riskBadgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            res.riskLevel.hinglishLabel,
                            style: TextStyle(
                              fontSize: 11 * state.fontScale,
                              fontWeight: FontWeight.w800,
                              color: riskBadgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      res.reportedProblem,
                      style: TextStyle(
                        fontSize: 19 * state.fontScale,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (res.possibleCauses.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Possible Reason: ${res.possibleCauses.first}',
                        style: TextStyle(
                          fontSize: 12.5 * state.fontScale,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF334155),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 7. Action Button (Doctor Booking)
              CustomButton(
                text: 'Consult Doctor',
                icon: Icons.local_hospital_rounded,
                variant: ButtonVariant.primary,
                height: 48,
                onPressed: () => _openDoctorConsult(context),
              ),
              const SizedBox(height: 12),

              // 8. Compact Medical Disclaimer
              const DisclaimerBanner(compact: true),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
