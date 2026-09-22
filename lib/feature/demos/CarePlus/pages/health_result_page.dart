import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/health_guidance_result.dart';
import '../models/health_check_input.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/food_card.dart';
import '../widgets/yoga_card.dart';
import '../widgets/medicine_safety_card.dart';
import '../widgets/doctor_guidance_card.dart';
import '../widgets/emergency_card.dart';
import '../widgets/health_card.dart';
import '../widgets/disclaimer_banner.dart';
import '../services/pdf_report_service.dart';
import '../services/health_suggestion_engine.dart';
import '../localization/app_language.dart';

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
  // 0: Medicine (open by default), 1: Food, 2: Yoga, 3: Doctor, null: OFF
  int? _selectedCategoryIndex = 0;

  Future<void> _shareReport(BuildContext context, HealthGuidanceResult res, CarePlusState state) async {
    final reportText = PdfReportService.generateSummaryText(
      profile: widget.input.profile,
      result: res,
      language: state.language,
    );

    final isHindi = state.language == AppLanguage.hindi;
    final isHinglish = state.language == AppLanguage.hinglish;
    final subject = isHindi
        ? 'केयरप्लस स्वास्थ्य रिपोर्ट - ${widget.input.profile.name.isNotEmpty ? widget.input.profile.name : "मरीज"}'
        : (isHinglish
            ? 'CarePlus Health Report - ${widget.input.profile.name.isNotEmpty ? widget.input.profile.name : "Patient"}'
            : 'CarePlus Health Report - ${widget.input.profile.name.isNotEmpty ? widget.input.profile.name : "Patient"}');

    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;

    try {
      final shareResult = await SharePlus.instance.share(
        ShareParams(
          text: reportText,
          subject: subject,
          sharePositionOrigin: origin,
        ),
      );
      if (shareResult.status == ShareResultStatus.unavailable) {
        if (context.mounted) {
          _showShareOptionsModal(context, reportText, isHindi, isHinglish);
        }
      }
    } catch (_) {
      if (context.mounted) {
        _showShareOptionsModal(context, reportText, isHindi, isHinglish);
      }
    }
  }

  void _showShareOptionsModal(BuildContext context, String reportText, bool isHindi, bool isHinglish) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.share_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi
                                  ? 'स्वास्थ्य रिपोर्ट साझा करें'
                                  : (isHinglish ? 'Health Report Share Karein' : 'Share Health Report'),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              isHindi
                                  ? 'डॉक्टर या परिवार के साथ तुरंत शेयर करें'
                                  : (isHinglish ? 'Doctor ya family ke sath share karein' : 'Share instantly with doctor or family'),
                              style: TextStyle(fontSize: 12.5, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final box = context.findRenderObject() as RenderBox?;
                            final origin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;
                            Navigator.of(ctx).pop();
                            try {
                              await SharePlus.instance.share(
                                ShareParams(
                                  text: reportText,
                                  subject: isHindi ? 'केयरप्लस रिपोर्ट' : 'CarePlus Health Report',
                                  sharePositionOrigin: origin,
                                ),
                              );
                            } catch (_) {
                              await Clipboard.setData(ClipboardData(text: reportText));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isHindi
                                          ? 'रिपोर्ट क्लिपबोर्ड पर कॉपी हो गई है!'
                                          : (isHinglish ? 'Report clipboard par copy ho gayi!' : 'Health report copied to clipboard!'),
                                    ),
                                    backgroundColor: AppColors.healthGreen,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(
                            isHindi ? 'शेयर करें' : (isHinglish ? 'Share Karein' : 'Share via Apps'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: reportText));
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        isHindi
                                            ? 'रिपोर्ट क्लिपबोर्ड पर कॉपी हो गई है!'
                                            : (isHinglish ? 'Report clipboard par copy ho gayi!' : 'Health report copied to clipboard!'),
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppColors.healthGreen,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
                          label: Text(
                            isHindi ? 'कॉपी करें' : (isHinglish ? 'Copy Karein' : 'Copy Text'),
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        isHindi ? 'रिपोर्ट पूर्वावलोकन (Preview):' : 'Report Preview:',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: SelectableText(
                        reportText,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontFamily: 'monospace',
                          height: 1.4,
                          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }

  void _callHelpline(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.phone_in_talk_rounded, color: AppColors.healthGreen),
            SizedBox(width: 8),
            Expanded(child: Text('Doctor Helpline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Connecting you to medical support:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.healthGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.call, color: AppColors.healthGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    number,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.healthGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $number...'),
                  backgroundColor: AppColors.healthGreen,
                ),
              );
            },
            icon: const Icon(Icons.call, size: 16),
            label: const Text('Call Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.healthGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
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
                _selectedCategoryIndex = null; // Toggle OFF
              } else {
                _selectedCategoryIndex = index; // Select ON
              }
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
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
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12 * fontScale,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.primary)
                          : (isDark ? AppColors.textSecondaryDark : const Color(0xFF334155)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryBullet(
    String label,
    String desc,
    double fontScale,
    bool isDark, {
    bool isGreen = false,
    bool isRed = false,
    bool isBlue = false,
    bool isAmber = false,
  }) {
    Color badgeBg;
    Color badgeText;

    if (isGreen) {
      badgeBg = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
      badgeText = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
    } else if (isRed) {
      badgeBg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
      badgeText = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
    } else if (isBlue) {
      badgeBg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE0F2FE);
      badgeText = isDark ? const Color(0xFF93C5FD) : const Color(0xFF0369A1);
    } else if (isAmber) {
      badgeBg = isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);
      badgeText = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
    } else {
      badgeBg = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
      badgeText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: badgeText.withValues(alpha: 0.35), width: 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5 * fontScale,
                fontWeight: FontWeight.w800,
                color: badgeText,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                desc,
                style: TextStyle(
                  fontSize: 15 * fontScale,
                  color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySummaryCard(HealthGuidanceResult res, bool isDark, double fontScale, CarePlusState state) {
    if (_selectedCategoryIndex == 0) {
      // Medicine Short Summary
      final effectiveMeds = res.medicineSafetyItems.isNotEmpty
          ? res.medicineSafetyItems
          : HealthSuggestionEngine.getVerifiedMedicineDatabase(state.language).take(1).toList();

      final medNames = effectiveMeds.map((m) => m.name).take(2).join(', ');

      final purposeText = state.language == AppLanguage.hindi
          ? '${res.reportedProblem} से सुरक्षित अस्थायी राहत'
          : (state.language == AppLanguage.hinglish
              ? '${res.reportedProblem} se safe temporary relief'
              : 'Safe temporary relief for ${res.reportedProblem}');
      final precautionText = state.language == AppLanguage.hindi
          ? 'लेबल पर लिखी खुराक पढ़ें; कभी भी डबल डोज न लें'
          : (state.language == AppLanguage.hinglish
              ? 'Label dosage padhein; double dose na lein'
              : 'Read label dosage; do not take double dose');
      final noticeText = state.language == AppLanguage.hindi
          ? 'यदि दर्द 2-3 दिन से अधिक रहे तो डॉक्टर से मिलें'
          : (state.language == AppLanguage.hinglish
              ? 'Dard agar 2-3 din se zyada rahe toh doctor ko dikhayein'
              : 'Consult doctor if pain persists > 2-3 days');

      return HealthCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 14),
        backgroundColor: isDark ? const Color(0xFF0F243A) : const Color(0xFFF0F8FF),
        border: Border.all(color: AppColors.primary, width: 1.8),
        shadows: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.medication_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.tr('medicine_summary_title'),
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFF67E8F9) : AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaryBullet(state.tr('summary_medicine_name'), medNames, fontScale, isDark, isGreen: true),
            _summaryBullet(state.tr('summary_purpose'), purposeText, fontScale, isDark, isBlue: true),
            _summaryBullet(state.tr('summary_precaution'), precautionText, fontScale, isDark, isAmber: true),
            _summaryBullet(state.tr('summary_notice'), noticeText, fontScale, isDark, isRed: true),
          ],
        ),
      );
    } else if (_selectedCategoryIndex == 1) {
      // Food Short Summary
      final recFoods = res.foodSuggestions.where((f) => f.category == 'Recommended').toList();
      final avoidFoods = res.foodSuggestions.where((f) => f.category == 'Limit/Avoid').toList();
      final eatText = recFoods.isNotEmpty ? recFoods.first.items.take(2).join(', ') : (state.language == AppLanguage.hindi ? 'हल्की खिचड़ी, दही, पानी' : 'Light khichdi, curd, water');
      final avoidText = avoidFoods.isNotEmpty ? avoidFoods.first.items.take(2).join(', ') : (state.language == AppLanguage.hindi ? 'मसालेदार व तला खाना, कोल्ड ड्रिंक' : 'Spicy & oily food, soda');
      final hydrationText = state.language == AppLanguage.hindi
          ? 'प्रतिदिन 8-10 गिलास साफ पानी पिएं'
          : (state.language == AppLanguage.hinglish
              ? 'Rozana 8-10 glass paani zaroor piyein'
              : 'Drink 8-10 glasses water daily');

      return HealthCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 14),
        backgroundColor: isDark ? const Color(0xFF072F24) : const Color(0xFFF0FDF4),
        border: Border.all(color: AppColors.healthGreen, width: 1.8),
        shadows: [
          BoxShadow(
            color: AppColors.healthGreen.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.healthGreen.withValues(alpha: isDark ? 0.25 : 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant_rounded, color: AppColors.healthGreen, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.tr('diet_summary_title'),
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaryBullet(state.tr('summary_eat'), eatText, fontScale, isDark, isGreen: true),
            _summaryBullet(state.tr('summary_avoid'), avoidText, fontScale, isDark, isRed: true),
            _summaryBullet(state.tr('summary_hydration'), hydrationText, fontScale, isDark, isBlue: true),
          ],
        ),
      );
    } else if (_selectedCategoryIndex == 2) {
      // Yoga Short Summary
      final yogaTitles = res.yogaExercises.map((y) => y.title.split('(').first.trim()).toList();
      final posesText = yogaTitles.isNotEmpty ? yogaTitles.take(2).join(', ') : (state.language == AppLanguage.hindi ? 'अनुलोम विलोम, गहरी सांस' : 'Anulom Vilom, Deep Breathing');
      final durationText = state.language == AppLanguage.hindi
          ? '5 से 10 मिनट सौम्य प्राणायाम'
          : (state.language == AppLanguage.hinglish
              ? '5 se 10 mins gentle breathing'
              : '5 to 10 mins gentle breathing');
      final safetyText = state.language == AppLanguage.hindi
          ? 'तेज दर्द या चक्कर आने पर तुरंत रुक जाएं'
          : (state.language == AppLanguage.hinglish
              ? 'Dard ya chakkar aane par stop karein'
              : 'Stop if sharp pain or dizziness occurs');

      return HealthCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 14),
        backgroundColor: isDark ? const Color(0xFF271540) : const Color(0xFFFAF5FF),
        border: Border.all(color: Colors.purple.shade400, width: 1.8),
        shadows: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: isDark ? 0.25 : 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.self_improvement_rounded, color: Colors.purple.shade400, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.tr('yoga_summary_title'),
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFFE9D5FF) : const Color(0xFF581C87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaryBullet(state.tr('summary_poses'), posesText, fontScale, isDark, isGreen: true),
            _summaryBullet(state.tr('summary_duration'), durationText, fontScale, isDark, isAmber: true),
            _summaryBullet(state.tr('summary_safety'), safetyText, fontScale, isDark, isRed: true),
          ],
        ),
      );
    } else {
      // Doctor Consult Summary
      final whenToVisitText = res.isEmergency
          ? (state.language == AppLanguage.hindi ? 'तुरंत आपातकालीन अस्पताल जाएं' : 'Immediate emergency hospital visit')
          : (state.language == AppLanguage.hindi ? 'यदि दर्द 2-3 दिन से अधिक रहे या बढ़े' : 'If pain persists > 2-3 days or worsens');

      return HealthCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 14),
        backgroundColor: isDark ? const Color(0xFF0F2B22) : const Color(0xFFF0FDF4),
        border: Border.all(color: AppColors.secondary, width: 1.8),
        shadows: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: isDark ? 0.25 : 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.medical_services_rounded, color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.tr('doctor_consult_summary_title'),
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFF5EEAD4) : AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaryBullet(state.tr('summary_specialist'), res.recommendedSpecialist, fontScale, isDark, isGreen: true),
            _summaryBullet(state.tr('summary_when_to_visit'), whenToVisitText, fontScale, isDark, isRed: res.isEmergency, isAmber: !res.isEmergency),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Dynamic re-evaluation ensuring active language is always applied
    final res = HealthSuggestionEngine.analyze(widget.input, language: state.language);

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
        : HealthSuggestionEngine.getVerifiedMedicineDatabase(state.language).take(1).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            tooltip: 'Home',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          title: Text(
            state.tr('result_title'),
            style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.primary),
              tooltip: 'Share Health Summary',
              onPressed: () => _shareReport(context, res, state),
            ),
            const SizedBox(width: 6),
          ],
        ),
        floatingActionButton: _selectedCategoryIndex == 3
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.healthGreen.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () => _callHelpline(context, '7380492118'),
                  backgroundColor: AppColors.healthGreen,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: const CircleBorder(),
                  tooltip: 'Call Doctor Helpline',
                  child: const Icon(Icons.phone_in_talk_rounded, size: 28),
                ),
              )
            : null,
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
                    onCallEmergency: () => _callHelpline(context, state.emergencyNumber),
                    onFindHospital: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nearest emergency medical center: Metro Multi-Speciality Hospital (1.2 km)'),
                          backgroundColor: AppColors.emergency,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // 2. Problem Summary Card (At the top)
                HealthCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.favorite_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    state.tr('problem_summary_title'),
                                    style: TextStyle(
                                      fontSize: 12 * state.fontScale,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: riskBadgeBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              res.riskLevel.label(state.language),
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
                          fontSize: 17 * state.fontScale,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (res.possibleCauses.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${state.tr('possible_reason_label')}: ${res.possibleCauses.first}',
                          style: TextStyle(
                            fontSize: 12 * state.fontScale,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF334155),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Four Guidance Buttons (Below Problem Summary)
                Row(
                  children: [
                    _buildTopCategoryButton(
                      index: 0,
                      icon: Icons.medication_rounded,
                      label: state.tr('tab_medicine_short'),
                      isDark: isDark,
                      fontScale: state.fontScale,
                    ),
                    const SizedBox(width: 8),
                    _buildTopCategoryButton(
                      index: 1,
                      icon: Icons.restaurant_rounded,
                      label: state.tr('tab_food_short'),
                      isDark: isDark,
                      fontScale: state.fontScale,
                    ),
                    const SizedBox(width: 8),
                    _buildTopCategoryButton(
                      index: 2,
                      icon: Icons.self_improvement_rounded,
                      label: state.tr('tab_yoga_short'),
                      isDark: isDark,
                      fontScale: state.fontScale,
                    ),
                    const SizedBox(width: 8),
                    _buildTopCategoryButton(
                      index: 3,
                      icon: Icons.medical_services_rounded,
                      label: state.tr('tab_doctor_short'),
                      isDark: isDark,
                      fontScale: state.fontScale,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 4. Dynamic Summary & Details Panel for Selected Tab (Medicine open by default)
                if (_selectedCategoryIndex != null) ...[
                  _buildCategorySummaryCard(res, isDark, state.fontScale, state),
                  if (_selectedCategoryIndex == 0) ...[
                    Row(
                      children: [
                        const Icon(Icons.medication_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            state.tr('medicine_safety_title'),
                            style: TextStyle(
                              fontSize: 13.5 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
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
                        Expanded(
                          child: Text(
                            state.tr('food_title'),
                            style: TextStyle(
                              fontSize: 13.5 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
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
                        Expanded(
                          child: Text(
                            state.tr('yoga_title'),
                            style: TextStyle(
                              fontSize: 13.5 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...res.yogaExercises.map((y) => YogaCard(yoga: y)),
                  ] else if (_selectedCategoryIndex == 3) ...[
                    Row(
                      children: [
                        const Icon(Icons.medical_services_rounded, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            state.tr('doctor_title'),
                            style: TextStyle(
                              fontSize: 13.5 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DoctorGuidanceCard(
                      specialist: res.recommendedSpecialist,
                      advice: res.doctorConsultationAdvice,
                      reportedProblem: res.reportedProblem,
                      duration: res.duration,
                      isEmergency: res.isEmergency,
                      phoneNumber: '7380492118',
                      onCallHelpline: () => _callHelpline(context, '7380492118'),
                    ),
                  ],
                  const SizedBox(height: 14),
                ],

                // 5. Consult a Doctor Action Card (shown when Doctor tab is not currently active)
                if (_selectedCategoryIndex != 3) ...[
                  HealthCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.medical_services_rounded, size: 20, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.tr('consult_doctor_card_title'),
                                style: TextStyle(
                                  fontSize: 13.5 * state.fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                '${state.tr('summary_specialist')}: ${res.recommendedSpecialist}',
                                style: TextStyle(
                                  fontSize: 11.5 * state.fontScale,
                                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIndex = 3;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            state.tr('view_advice_btn'),
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // 6. Compact Medical Disclaimer
                const DisclaimerBanner(compact: true),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
