import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';

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
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  late int _selectedTab; // 0: Diabetes, 1: General

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
  void initState() {
    super.initState();
    _selectedTab = widget.isDiabetes ? 0 : 1;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
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

  void _addNewSymptom() {
    final text = _searchCtrl.text.trim();
    if (text.isNotEmpty && !widget.selectedSymptoms.contains(text)) {
      final list = List<String>.from(widget.selectedSymptoms)..add(text);
      widget.onSymptomsChanged(list);
      _searchCtrl.clear();
      setState(() => _searchQuery = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDiabetesActive = _selectedTab == 0;

    final baseList = isDiabetesActive ? diabetesSymptoms : generalSymptoms;

    final filtered = _searchQuery.isEmpty
        ? baseList
        : [...diabetesSymptoms, ...generalSymptoms].where((s) {
            final en = (s['en'] as String).toLowerCase();
            final hi = (s['hi'] as String).toLowerCase();
            final key = (s['key'] as String).toLowerCase();
            final q = _searchQuery.toLowerCase();
            return en.contains(q) || hi.contains(q) || key.contains(q);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isDiabetesActive ? 'डायबिटीज के लक्षण चुनें (Diabetes Symptoms):' : state.tr('symptoms_title'),
                style: TextStyle(
                  fontSize: 15 * state.fontScale,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.selectedSymptoms.isNotEmpty)
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
                    fontSize: 12 * state.fontScale,
                    fontWeight: FontWeight.w700,
                    color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Category Tab Switcher for Symptoms
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
              // Tab 0: Diabetes Symptoms
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedTab = 0),
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
                              'डायबिटीज लक्षण',
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
              // Tab 1: General Symptoms
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedTab = 1),
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
                              'सामान्य लक्षण',
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
        const SizedBox(height: 12),

        TextField(
          controller: _searchCtrl,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: TextStyle(
            fontSize: 14 * state.fontScale,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            hintText: isDiabetesActive
                ? 'डायबिटीज लक्षण खोजें (उदा. शुगर, प्यास, पेशाब)...'
                : state.tr('symptoms_search_hint'),
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
                    ),
                    tooltip: 'Add Custom Symptom',
                    onPressed: _addNewSymptom,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filtered.map((item) {
            final key = item['key'] as String;
            final isSelected = widget.selectedSymptoms.contains(key);
            final iconData = item['icon'] as IconData;
            final isDiabeticSymptom = diabetesSymptoms.any((d) => d['key'] == key);
            final activeColor = isDiabeticSymptom ? const Color(0xFF0369A1) : AppColors.primary;

            return FilterChip(
              avatar: Icon(
                iconData,
                size: 15,
                color: isSelected ? Colors.white : activeColor,
              ),
              label: Text(
                item['en'] as String,
                style: TextStyle(
                  fontSize: 12.5 * state.fontScale,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
                ),
              ),
              selected: isSelected,
              selectedColor: activeColor,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? activeColor : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) => _toggleSymptom(key),
            );
          }).toList(),
        ),
        if (widget.selectedSymptoms.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : (isDiabetesActive
                      ? const Color(0xFF0369A1).withValues(alpha: 0.1)
                      : AppColors.primarySurface),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected: ${widget.selectedSymptoms.join(", ")}',
                    style: TextStyle(
                      fontSize: 12 * state.fontScale,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : (isDiabetesActive ? const Color(0xFF0369A1) : AppColors.primaryDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
