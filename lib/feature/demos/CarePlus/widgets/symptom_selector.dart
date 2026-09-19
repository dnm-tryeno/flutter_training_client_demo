import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';

class SymptomSelectorWidget extends StatefulWidget {
  final List<String> selectedSymptoms;
  final Function(List<String>) onSymptomsChanged;

  const SymptomSelectorWidget({
    super.key,
    required this.selectedSymptoms,
    required this.onSymptomsChanged,
  });

  @override
  State<SymptomSelectorWidget> createState() => _SymptomSelectorWidgetState();
}

class _SymptomSelectorWidgetState extends State<SymptomSelectorWidget> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  static const List<Map<String, String>> defaultSymptoms = [
    {'key': 'Headache', 'en': 'Headache (Sir dard)', 'icon': '🧠'},
    {'key': 'Fever', 'en': 'Fever (Bukhar)', 'icon': '🌡️'},
    {'key': 'Acidity', 'en': 'Acidity & Gas', 'icon': '🔥'},
    {'key': 'Pain', 'en': 'Body Ache / Pain', 'icon': '⚡'},
    {'key': 'Cough', 'en': 'Cough / Khansi', 'icon': '🤧'},
    {'key': 'Weakness', 'en': 'Weakness / Thakan', 'icon': '🥱'},
    {'key': 'Vomiting', 'en': 'Vomiting / Ulti', 'icon': '🤢'},
    {'key': 'Dizziness', 'en': 'Dizziness / Chakkar', 'icon': '💫'},
    {'key': 'Shortness of breath', 'en': 'Shortness of Breath', 'icon': '🫁'},
    {'key': 'Chest tightness', 'en': 'Chest Tightness', 'icon': '❤️‍🩹'},
    {'key': 'Joint pain', 'en': 'Joint Pain / Gathiya', 'icon': '🦴'},
    {'key': 'Nausea', 'en': 'Nausea / Ji Ghabrana', 'icon': '😣'},
    {'key': 'Back pain', 'en': 'Back Pain / Kamar dard', 'icon': '🧍'},
    {'key': 'Sleeplessness', 'en': 'Sleeplessness / Anidra', 'icon': '🌙'},
    {'key': 'Skin Rash', 'en': 'Skin Rash / Khujli', 'icon': '🩹'},
  ];

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

    final filtered = defaultSymptoms.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s['en']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s['key']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              state.tr('symptoms_title'),
              style: TextStyle(
                fontSize: 15 * state.fontScale,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            if (widget.selectedSymptoms.isNotEmpty)
              Text(
                '${widget.selectedSymptoms.length} selected',
                style: TextStyle(
                  fontSize: 12 * state.fontScale,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchCtrl,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: TextStyle(
            fontSize: 14 * state.fontScale,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            hintText: state.tr('symptoms_search_hint'),
            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.primary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary),
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
            final key = item['key']!;
            final isSelected = widget.selectedSymptoms.contains(key);

            return FilterChip(
              avatar: Text(item['icon']!, style: const TextStyle(fontSize: 14)),
              label: Text(
                item['en']!,
                style: TextStyle(
                  fontSize: 12.5 * state.fontScale,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
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
              color: isDark ? const Color(0xFF1E293B) : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected: ${widget.selectedSymptoms.join(", ")}',
                    style: TextStyle(
                      fontSize: 12 * state.fontScale,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.primaryDark,
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
