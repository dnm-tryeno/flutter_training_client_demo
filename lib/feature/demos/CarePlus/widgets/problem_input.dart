import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../localization/app_language.dart';

class ProblemInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onQuickSelect;
  final ValueChanged<String>? onChanged;
  final bool isDiabetes;

  const ProblemInputWidget({
    super.key,
    required this.controller,
    required this.onQuickSelect,
    this.onChanged,
    this.isDiabetes = false,
  });

  @override
  State<ProblemInputWidget> createState() => _ProblemInputWidgetState();
}

class _ProblemInputWidgetState extends State<ProblemInputWidget> {
  late int _selectedCategoryTab; // 0: Diabetes, 1: General

  static const List<Map<String, String>> diabetesProblems = [
    {
      'en': 'High Blood Sugar (Hyperglycemia)',
      'hi': 'ब्लड शुगर ज्यादा होना (Hyperglycemia)',
      'query': 'High blood sugar / Hyperglycemia',
    },
    {
      'en': 'Low Sugar & Sweating (Hypo)',
      'hi': 'शुगर लो होना और पसीना (Hypoglycemia)',
      'query': 'Low sugar / Hypoglycemia',
    },
    {
      'en': 'Frequent Urination (Peshab)',
      'hi': 'बार-बार पेशाब आना (Frequent urination)',
      'query': 'Frequent urination / High glucose',
    },
    {
      'en': 'Excessive Thirst & Dry Mouth',
      'hi': 'अत्यधिक प्यास व गला सूखना',
      'query': 'Excessive thirst & dry mouth',
    },
    {
      'en': 'Foot Numbness / Tingling (Sunnpan)',
      'hi': 'पैरों में सुन्नपन व झनझनाहट (Neuropathy)',
      'query': 'Foot numbness / Diabetic neuropathy',
    },
    {
      'en': 'Slow Wound Healing (Ghaav)',
      'hi': 'घाव जल्दी न भरना (Slow healing)',
      'query': 'Slow wound healing in diabetes',
    },
    {
      'en': 'Diabetes Fatigue & Weakness',
      'hi': 'डायबिटीज में अत्यधिक कमजोरी व थकान',
      'query': 'Diabetes fatigue & weakness',
    },
    {
      'en': 'Blurry Vision (Dhundhla dikhna)',
      'hi': 'आँखों के आगे धुंधलापन (Diabetic eye)',
      'query': 'Blurry vision / Diabetic eye',
    },
    {
      'en': 'Sugar Control Diet & HbA1c',
      'hi': 'शुगर कंट्रोल डाइट व HbA1c सलाह',
      'query': 'Diabetes diet & glucose management',
    },
    {
      'en': 'Sudden Hunger & Shakiness',
      'hi': 'अचानक तेज भूख व कंपकंपी (लो शुगर लक्षण)',
      'query': 'Sudden hunger & shakiness',
    },
  ];

  static const List<Map<String, String>> generalProblems = [
    {
      'en': 'Sir dard hai (Headache)',
      'hi': 'सिर में दर्द है (Headache)',
      'query': 'Sir dard hai / Headache',
    },
    {
      'en': 'Pet me dard hai (Stomach pain)',
      'hi': 'पेट में दर्द है (Stomach pain)',
      'query': 'Pet me dard hai / Stomach pain',
    },
    {
      'en': 'Acidity & Gas issue',
      'hi': 'एसिडिटी और गैस की समस्या',
      'query': 'Acidity & Gas issue',
    },
    {
      'en': 'Bukhar hai (Fever)',
      'hi': 'बुखार और हरारत (Fever)',
      'query': 'Fever / Bukhar',
    },
    {
      'en': 'Khansi & Cold (Cough)',
      'hi': 'खांसी और जुकाम (Cough & Cold)',
      'query': 'Cough & Cold issue',
    },
    {
      'en': 'Back pain / Kamar dard',
      'hi': 'कमर में दर्द (Back pain)',
      'query': 'Back pain / Kamar dard',
    },
    {
      'en': 'Thakan hoti hai (Fatigue & weakness)',
      'hi': 'थकान और कमजोरी होती है',
      'query': 'Thakan hoti hai / Fatigue & weakness',
    },
    {
      'en': 'Neend nahi aa rahi (Sleep trouble)',
      'hi': 'नींद नहीं आ रही (Insomnia)',
      'query': 'Neend nahi aa rahi / Sleep trouble',
    },
    {
      'en': 'Blood pressure high rehta hai',
      'hi': 'ब्लड प्रेशर हाई रहता है (High BP)',
      'query': 'Blood pressure high rehta hai',
    },
    {
      'en': 'Joint pain & Body ache',
      'hi': 'जोड़ों और बदन में दर्द (Joint pain)',
      'query': 'Joint pain & Body ache',
    },
  ];

  @override
  void initState() {
    super.initState();
    final lower = widget.controller.text.toLowerCase();
    if (widget.isDiabetes ||
        lower.contains('diabet') ||
        lower.contains('sugar') ||
        lower.contains('glucose') ||
        lower.contains('hba1c') ||
        lower.contains('peshab') ||
        lower.contains('urination') ||
        lower.contains('hypo') ||
        lower.contains('hyper')) {
      _selectedCategoryTab = 0;
    } else {
      _selectedCategoryTab = widget.isDiabetes ? 0 : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDiabetesActive = _selectedCategoryTab == 0;
    final problemsList = isDiabetesActive ? diabetesProblems : generalProblems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.tr('problem_input_title'),
          style: TextStyle(
            fontSize: 15 * state.fontScale,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isDiabetesActive
              ? (state.language == AppLanguage.hindi
                  ? 'अपनी डायबिटीज या ब्लड शुगर संबंधित परेशानी यहाँ लिखें या नीचे चुनें:'
                  : 'Describe your diabetes or blood sugar symptoms, or pick below:')
              : state.tr('problem_input_subtitle'),
          style: TextStyle(
            fontSize: 13 * state.fontScale,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.controller,
          maxLines: 3,
          minLines: 2,
          onChanged: widget.onChanged,
          style: TextStyle(
            fontSize: 15 * state.fontScale,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            hintText: isDiabetesActive
                ? (state.language == AppLanguage.hindi
                    ? 'उदा. ब्लड शुगर 220 है, बार-बार पेशाब और ज्यादा प्यास लग रही है...'
                    : 'e.g. Fasting sugar 180, frequent urination and feeling thirsty...')
                : state.tr('problem_hint'),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Icon(Icons.edit_note_rounded, color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Category Filter Toggle: Diabetes vs General
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Tab 0: Diabetes
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedCategoryTab = 0),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isDiabetesActive ? const Color(0xFF0369A1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isDiabetesActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0369A1).withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.water_drop_outlined,
                          size: 16,
                          color: isDiabetesActive
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              state.language == AppLanguage.hindi
                                  ? 'डायबिटीज समस्याएं'
                                  : 'Diabetes Problems',
                              style: TextStyle(
                                fontSize: 12.5 * state.fontScale,
                                fontWeight: isDiabetesActive ? FontWeight.w800 : FontWeight.w600,
                                color: isDiabetesActive
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
              // Tab 1: General
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedCategoryTab = 1),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: !isDiabetesActive ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: !isDiabetesActive
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_rounded,
                          size: 16,
                          color: !isDiabetesActive
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              state.language == AppLanguage.hindi
                                  ? 'सामान्य समस्याएं'
                                  : 'General Health',
                              style: TextStyle(
                                fontSize: 12.5 * state.fontScale,
                                fontWeight: !isDiabetesActive ? FontWeight.w800 : FontWeight.w600,
                                color: !isDiabetesActive
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
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isDiabetesActive
                    ? (state.language == AppLanguage.hindi
                        ? 'डायबिटीज के मुख्य लक्षण चुनें:'
                        : 'Select Diabetes Specific Problem:')
                    : state.tr('select_common_problems'),
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  fontWeight: FontWeight.w700,
                  color: isDiabetesActive
                      ? const Color(0xFF0369A1)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: problemsList.map((prob) {
            final isSelected = widget.controller.text.toLowerCase().contains(prob['query']!.toLowerCase().split(' ').first);
            final activeColor = isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary;

            return FilterChip(
              avatar: isDiabetesActive
                  ? const Icon(Icons.water_drop_outlined, size: 14, color: Color(0xFF0369A1))
                  : null,
              label: Text(
                state.language == AppLanguage.hindi ? prob['hi']! : prob['en']!,
                style: TextStyle(
                  fontSize: 12 * state.fontScale,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
                ),
              ),
              selected: isSelected,
              selectedColor: activeColor,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              side: BorderSide(
                color: isSelected ? activeColor : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) {
                widget.controller.text = prob['query']!;
                widget.onQuickSelect(prob['query']!);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
