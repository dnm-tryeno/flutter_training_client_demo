import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../localization/app_language.dart';

class ProblemInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onQuickSelect;
  final ValueChanged<String>? onChanged;
  final bool isDiabetes;

  const ProblemInputWidget({
    super.key,
    required this.controller,
    this.onQuickSelect,
    this.onChanged,
    this.isDiabetes = false,
  });

  @override
  State<ProblemInputWidget> createState() => _ProblemInputWidgetState();
}

class _ProblemInputWidgetState extends State<ProblemInputWidget> {
  final TextEditingController _customProblemCtrl = TextEditingController();

  @override
  void dispose() {
    _customProblemCtrl.dispose();
    super.dispose();
  }

  void _addCustomProblem() {
    final text = _customProblemCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.controller.text = text;
      });
      widget.onChanged?.call(text);
      widget.onQuickSelect?.call(text);
      _customProblemCtrl.clear();
    }
  }

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

  String? _getCurrentSelectedQuery(List<Map<String, String>> problemsList) {
    final text = widget.controller.text.trim().toLowerCase();
    if (text.isEmpty) return null;
    for (final p in problemsList) {
      final q = p['query']!.toLowerCase();
      final en = p['en']!.toLowerCase();
      final hi = p['hi']!.toLowerCase();
      if (q == text || en == text || hi == text || text.contains(q) || q.contains(text)) {
        return p['query'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final problemsList = widget.isDiabetes ? diabetesProblems : generalProblems;
    final selectedQuery = _getCurrentSelectedQuery(problemsList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isDiabetes
              ? (state.language == AppLanguage.hindi ? 'डायबिटीज समस्या चुनें:' : 'Select Diabetes Concern:')
              : (state.language == AppLanguage.hindi ? 'मुख्य स्वास्थ्य समस्या चुनें:' : 'Select Health Concern:'),
          style: TextStyle(
            fontSize: 14 * state.fontScale,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isDiabetes
                  ? const Color(0xFF0369A1).withValues(alpha: 0.4)
                  : AppColors.primary.withValues(alpha: 0.4),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedQuery,
              hint: Row(
                children: [
                  Icon(
                    widget.isDiabetes ? Icons.water_drop_outlined : Icons.health_and_safety_outlined,
                    size: 18,
                    color: widget.isDiabetes ? const Color(0xFF0369A1) : AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.controller.text.isNotEmpty
                          ? widget.controller.text
                          : (widget.isDiabetes
                              ? (state.language == AppLanguage.hindi
                                  ? '-- डायबिटीज समस्या चुनें (Dropdown) --'
                                  : '-- Select Diabetes Problem --')
                              : (state.language == AppLanguage.hindi
                                  ? '-- स्वास्थ्य समस्या चुनें (Dropdown) --'
                                  : '-- Select Health Problem --')),
                      style: TextStyle(
                        fontSize: 13 * state.fontScale,
                        color: widget.controller.text.isNotEmpty
                            ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                            : (isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight),
                        fontWeight: widget.controller.text.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: widget.isDiabetes ? const Color(0xFF0369A1) : AppColors.primary,
              ),
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              items: problemsList.map((prob) {
                final label = state.language == AppLanguage.hindi ? prob['hi']! : prob['en']!;
                return DropdownMenuItem<String>(
                  value: prob['query'],
                  child: Row(
                    children: [
                      Icon(
                        widget.isDiabetes ? Icons.water_drop_rounded : Icons.check_circle_outline_rounded,
                        size: 16,
                        color: widget.isDiabetes ? const Color(0xFF0369A1) : AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13 * state.fontScale,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    widget.controller.text = val;
                  });
                  widget.onChanged?.call(val);
                  widget.onQuickSelect?.call(val);
                }
              },
            ),
          ),
        ),

        // Custom Add Problem Bar
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _customProblemCtrl,
                  style: TextStyle(fontSize: 13 * state.fontScale),
                  decoration: InputDecoration(
                    hintText: state.language == AppLanguage.hindi
                        ? '+ अन्य समस्या लिखें (Custom problem)...'
                        : '+ Type custom problem...',
                    hintStyle: TextStyle(
                      fontSize: 12 * state.fontScale,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.isDiabetes ? const Color(0xFF0369A1) : AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _addCustomProblem(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: _addCustomProblem,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  state.language == AppLanguage.hindi ? 'जोड़ें' : 'Add',
                  style: TextStyle(
                    fontSize: 12.5 * state.fontScale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isDiabetes ? const Color(0xFF0369A1) : AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
