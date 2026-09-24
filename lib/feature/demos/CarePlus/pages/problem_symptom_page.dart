import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/health_check_input.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/problem_input.dart';
import '../widgets/symptom_selector.dart';
import '../widgets/custom_button.dart';
import 'health_analysis_loading_page.dart';

class ProblemSymptomPage extends StatefulWidget {
  final UserProfile profile;
  final String? initialProblem;
  final bool isDiabetes;

  const ProblemSymptomPage({
    super.key,
    required this.profile,
    this.initialProblem,
    this.isDiabetes = false,
  });

  @override
  State<ProblemSymptomPage> createState() => _ProblemSymptomPageState();
}

class _ProblemSymptomPageState extends State<ProblemSymptomPage> {
  final TextEditingController _problemCtrl = TextEditingController();
  final TextEditingController _conditionsCtrl = TextEditingController();
  final TextEditingController _medsCtrl = TextEditingController();
  final TextEditingController _allergiesCtrl = TextEditingController();

  late bool _isDiabetes;
  List<String> _selectedSymptoms = [];
  String _selectedDuration = '2 – 3 days';

  @override
  void initState() {
    super.initState();
    _isDiabetes = widget.isDiabetes;
    final lower = (widget.initialProblem ?? '').toLowerCase();
    if (lower.contains('diabet') ||
        lower.contains('sugar') ||
        lower.contains('glucose') ||
        lower.contains('hba1c') ||
        lower.contains('peshab') ||
        lower.contains('urination') ||
        lower.contains('hypo') ||
        lower.contains('hyper')) {
      _isDiabetes = true;
    }

    if (widget.initialProblem != null && widget.initialProblem!.isNotEmpty) {
      _problemCtrl.text = widget.initialProblem!;
    }
    if (widget.profile.conditions.isNotEmpty) {
      _conditionsCtrl.text = widget.profile.conditions.join(', ');
    }
    if (widget.profile.currentMedications.isNotEmpty) {
      _medsCtrl.text = widget.profile.currentMedications.join(', ');
    }
    if (widget.profile.allergies.isNotEmpty) {
      _allergiesCtrl.text = widget.profile.allergies.join(', ');
    }
  }

  @override
  void dispose() {
    _problemCtrl.dispose();
    _conditionsCtrl.dispose();
    _medsCtrl.dispose();
    _allergiesCtrl.dispose();
    super.dispose();
  }

  void _onAnalyze() {
    final problem = _problemCtrl.text.trim();
    if (problem.isEmpty && _selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your health problem or select at least one symptom.'),
          backgroundColor: AppColors.warningDark,
        ),
      );
      return;
    }

    final conditions = _conditionsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final meds = _medsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final allergies = _allergiesCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updatedProfile = widget.profile.copyWith(
      conditions: conditions,
      currentMedications: meds,
      allergies: allergies,
    );

    final input = HealthCheckInput(
      profile: updatedProfile,
      mainProblem: problem.isNotEmpty ? problem : _selectedSymptoms.join(', '),
      symptoms: _selectedSymptoms,
      duration: _selectedDuration,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HealthAnalysisLoadingPage(input: input),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final durations = [
      state.tr('duration_1day'),
      state.tr('duration_few_days'),
      state.tr('duration_1week'),
      state.tr('duration_chronic'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.tr('problem_input_title'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.tr('step_2_of_2'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.tr('problem_symptoms_title'),
                    style: TextStyle(
                      fontSize: 13 * state.fontScale,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Problem Input
              ProblemInputWidget(
                controller: _problemCtrl,
                isDiabetes: _isDiabetes,
                onQuickSelect: (val) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),

              // Symptom Selector
              SymptomSelectorWidget(
                selectedSymptoms: _selectedSymptoms,
                isDiabetes: _isDiabetes,
                onSymptomsChanged: (list) => setState(() => _selectedSymptoms = list),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Duration Selector
              Text(
                state.tr('duration_title'),
                style: TextStyle(
                  fontSize: 15 * state.fontScale,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: durations.map((d) {
                  final isSelected = _selectedDuration == d;
                  return ChoiceChip(
                    label: Text(
                      d,
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
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    onSelected: (_) => setState(() => _selectedDuration = d),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Existing Conditions
              Text(
                state.tr('existing_conditions'),
                style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _conditionsCtrl,
                decoration: InputDecoration(
                  hintText: state.tr('existing_conditions_hint'),
                  prefixIcon: const Icon(Icons.history_edu_rounded, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Current Medicines
              Text(
                state.tr('current_medicines'),
                style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _medsCtrl,
                decoration: InputDecoration(
                  hintText: state.tr('current_medicines_hint'),
                  prefixIcon: const Icon(Icons.medication_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Allergies
              Text(
                state.tr('allergies'),
                style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _allergiesCtrl,
                decoration: InputDecoration(
                  hintText: state.tr('allergies_hint'),
                  prefixIcon: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: CustomButton(
            text: state.tr('btn_analyze'),
            icon: Icons.analytics_outlined,
            onPressed: _onAnalyze,
          ),
        ),
      ),
    );
  }
}
