import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../localization/app_language.dart';

class SymptomSelectorWidget extends StatefulWidget {
  final List<String> selectedSymptoms;
  final Function(List<String>) onSymptomsChanged;
  final bool isDiabetes;

  const SymptomSelectorWidget({
    super.key,
    required this.selectedSymptoms,
    required this.onSymptomsChanged,
    this.isDiabetes = false,
  });

  @override
  State<SymptomSelectorWidget> createState() => _SymptomSelectorWidgetState();
}

class _SymptomSelectorWidgetState extends State<SymptomSelectorWidget> {
  final TextEditingController _customCtrl = TextEditingController();

  static const List<Map<String, dynamic>> diabetesSymptoms = [
    {'key': 'High Blood Sugar', 'en': 'High Sugar (Sugar badhna)', 'hi': 'ब्लड शुगर बढ़ना (High Sugar)', 'icon': Icons.water_drop_outlined},
    {'key': 'Low Blood Sugar', 'en': 'Low Sugar & Sweating (Hypo)', 'hi': 'शुगर लो होना व पसीना (Hypoglycemia)', 'icon': Icons.bloodtype_outlined},
    {'key': 'Frequent Urination', 'en': 'Frequent Urination (Peshab)', 'hi': 'बार-बार पेशाब आना (Frequent Urination)', 'icon': Icons.water_damage_outlined},
    {'key': 'Excessive Thirst', 'en': 'Excessive Thirst (Jyada pyaas)', 'hi': 'अत्यधिक प्यास व गला सूखना', 'icon': Icons.local_drink_outlined},
    {'key': 'Foot Numbness', 'en': 'Foot Numbness (Sunnpan)', 'hi': 'पैरों में सुन्नपन व झनझनाहट (Neuropathy)', 'icon': Icons.do_not_step_outlined},
    {'key': 'Slow Healing', 'en': 'Slow Wound Healing (Ghaav)', 'hi': 'घाव देरी से भरना (Slow Healing)', 'icon': Icons.healing_outlined},
    {'key': 'Blurry Vision', 'en': 'Blurry Vision (Dhundhla dikhna)', 'hi': 'आँखों में धुंधलापन (Diabetic Eye)', 'icon': Icons.visibility_off_outlined},
    {'key': 'Extreme Fatigue', 'en': 'Fatigue / Kamzori', 'hi': 'कमजोरी व सुस्ती (Extreme Fatigue)', 'icon': Icons.bedtime_outlined},
    {'key': 'Dry Mouth', 'en': 'Dry Mouth (Gala sukhna)', 'hi': 'मुंह सूखना (Dry Mouth)', 'icon': Icons.sentiment_neutral_outlined},
    {'key': 'Sudden Hunger', 'en': 'Sudden Hunger & Shakiness', 'hi': 'अचानक तेज भूख व कपकपी', 'icon': Icons.restaurant_outlined},
    {'key': 'Dizziness', 'en': 'Dizziness / Chakkar', 'hi': 'चक्कर आना (Dizziness)', 'icon': Icons.refresh_rounded},
    {'key': 'Weight Loss', 'en': 'Unexplained Weight Loss', 'hi': 'अचानक वजन कम होना', 'icon': Icons.monitor_weight_outlined},
  ];

  static const List<Map<String, dynamic>> generalSymptoms = [
    {'key': 'Headache', 'en': 'Headache (Sir dard)', 'hi': 'सिर दर्द (Headache)', 'icon': Icons.psychology_outlined},
    {'key': 'Fever', 'en': 'Fever (Bukhar)', 'hi': 'बुखार (Fever)', 'icon': Icons.thermostat_rounded},
    {'key': 'Acidity', 'en': 'Acidity & Gas', 'hi': 'एसिडिटी व गैस (Acidity)', 'icon': Icons.local_fire_department_outlined},
    {'key': 'Pain', 'en': 'Body Ache / Pain', 'hi': 'बदन दर्द (Body Ache)', 'icon': Icons.bolt_rounded},
    {'key': 'Cough', 'en': 'Cough / Khansi', 'hi': 'खांसी / जुकाम (Cough)', 'icon': Icons.sick_outlined},
    {'key': 'Weakness', 'en': 'Weakness / Thakan', 'hi': 'थकान (Weakness)', 'icon': Icons.bedtime_outlined},
    {'key': 'Vomiting', 'en': 'Vomiting / Ulti', 'hi': 'उल्टी व जी घबराना (Vomiting)', 'icon': Icons.sentiment_very_dissatisfied_outlined},
    {'key': 'Dizziness', 'en': 'Dizziness / Chakkar', 'hi': 'चक्कर आना (Dizziness)', 'icon': Icons.refresh_rounded},
    {'key': 'Shortness of breath', 'en': 'Shortness of Breath', 'hi': 'सांस फूलना (Breathing issue)', 'icon': Icons.air_rounded},
    {'key': 'Chest tightness', 'en': 'Chest Tightness', 'hi': 'सीने में भारीपन (Chest tightness)', 'icon': Icons.favorite_border_rounded},
    {'key': 'Joint pain', 'en': 'Joint Pain / Gathiya', 'hi': 'जोड़ों में दर्द (Joint Pain)', 'icon': Icons.accessibility_new_rounded},
    {'key': 'Nausea', 'en': 'Nausea / Ji Ghabrana', 'hi': 'जी मिचलाना (Nausea)', 'icon': Icons.sentiment_dissatisfied_outlined},
    {'key': 'Back pain', 'en': 'Back Pain / Kamar dard', 'hi': 'कमर दर्द (Back pain)', 'icon': Icons.accessibility_rounded},
    {'key': 'Sleeplessness', 'en': 'Sleeplessness / Anidra', 'hi': 'नींद न आना (Insomnia)', 'icon': Icons.nightlight_round},
    {'key': 'Skin Rash', 'en': 'Skin Rash / Khujli', 'hi': 'खुजली व दाने (Skin rash)', 'icon': Icons.healing_outlined},
  ];

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _toggleSymptom(String key) {
    final list = List<String>.from(widget.selectedSymptoms);
    if (list.contains(key)) {
      list.remove(key);
    } else {
      list.add(key);
    }
    widget.onSymptomsChanged(list);
  }

  void _addCustomSymptom() {
    final text = _customCtrl.text.trim();
    if (text.isNotEmpty && !widget.selectedSymptoms.contains(text)) {
      final list = List<String>.from(widget.selectedSymptoms)..add(text);
      widget.onSymptomsChanged(list);
      _customCtrl.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDiabetesActive = widget.isDiabetes;
    final currentList = isDiabetesActive ? diabetesSymptoms : generalSymptoms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isDiabetesActive
                    ? (state.language == AppLanguage.hindi
                        ? 'डायबिटीज लक्षण चुनें (Dropdown):'
                        : 'Select Diabetes Symptoms:')
                    : (state.language == AppLanguage.hindi
                        ? 'सामान्य लक्षण चुनें (Dropdown):'
                        : 'Select Symptoms (Dropdown):'),
                style: TextStyle(
                  fontSize: 13.5 * state.fontScale,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.selectedSymptoms.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDiabetesActive
                          ? const Color(0xFF0369A1).withValues(alpha: 0.15)
                          : AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.selectedSymptoms.length} selected',
                      style: TextStyle(
                        fontSize: 11.5 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => widget.onSymptomsChanged([]),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 11 * state.fontScale,
                        color: AppColors.emergency,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 6),

        // Dropdown Menu for Symptoms
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDiabetesActive
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
              value: null, // Keeps as selector trigger
              hint: Row(
                children: [
                  Icon(
                    isDiabetesActive ? Icons.water_drop_outlined : Icons.checklist_rtl_rounded,
                    size: 18,
                    color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isDiabetesActive
                          ? (state.language == AppLanguage.hindi
                              ? '-- डायबिटीज लक्षण चुनें या जोड़ें --'
                              : '-- Select / Add Diabetes Symptom --')
                          : (state.language == AppLanguage.hindi
                              ? '-- लक्षण चुनें या जोड़ें --'
                              : '-- Select / Add Symptom --'),
                      style: TextStyle(
                        fontSize: 13 * state.fontScale,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
              ),
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              items: currentList.map((item) {
                final key = item['key'] as String;
                final isSelected = widget.selectedSymptoms.contains(key);
                final label = state.language == AppLanguage.hindi ? item['hi'] as String : item['en'] as String;
                final iconData = item['icon'] as IconData;

                return DropdownMenuItem<String>(
                  value: key,
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : iconData,
                        size: 16,
                        color: isSelected
                            ? AppColors.healthGreen
                            : (isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13 * state.fontScale,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? Colors.teal[200] : const Color(0xFF065F46))
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.healthGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Added',
                            style: TextStyle(
                              fontSize: 10 * state.fontScale,
                              fontWeight: FontWeight.w700,
                              color: AppColors.healthGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  _toggleSymptom(val);
                }
              },
            ),
          ),
        ),

        // Selected Symptoms Badges (Compact)
        if (widget.selectedSymptoms.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.selectedSymptoms.map((symptomKey) {
              final found = [...diabetesSymptoms, ...generalSymptoms].firstWhere(
                (e) => e['key'] == symptomKey,
                orElse: () => {'key': symptomKey, 'en': symptomKey, 'hi': symptomKey, 'icon': Icons.check_circle_outline},
              );
              final label = state.language == AppLanguage.hindi ? found['hi'] as String : found['en'] as String;

              return Container(
                padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : (isDiabetesActive
                          ? const Color(0xFF0369A1).withValues(alpha: 0.1)
                          : AppColors.primarySurface),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDiabetesActive
                        ? const Color(0xFF0369A1).withValues(alpha: 0.4)
                        : AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12 * state.fontScale,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : (isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primaryDark),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => _toggleSymptom(symptomKey),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Optional custom symptom input
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: _customCtrl,
                  style: TextStyle(fontSize: 13 * state.fontScale),
                  decoration: InputDecoration(
                    hintText: state.language == AppLanguage.hindi ? 'अन्य कोई लक्षण टाइप करें...' : 'Type any other symptom...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixIcon: const Icon(Icons.add, size: 16),
                  ),
                  onSubmitted: (_) => _addCustomSymptom(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addCustomSymptom,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ],
    );
  }
}
