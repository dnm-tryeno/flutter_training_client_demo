import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_selector_button.dart';
import 'problem_symptom_page.dart';

class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _locationCtrl;

  String _gender = 'Male';
  bool _isPregnant = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _ageCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _locationCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = CarePlusStateScope.of(context).userProfile;
    if (_nameCtrl.text.isEmpty) {
      _nameCtrl.text = profile.name;
      _ageCtrl.text = profile.age > 0 ? profile.age.toString() : '30';
      _weightCtrl.text = profile.weightKg > 0 ? profile.weightKg.toInt().toString() : '68';
      _heightCtrl.text = profile.heightCm > 0 ? profile.heightCm.toInt().toString() : '170';
      _locationCtrl.text = profile.location;
      _gender = profile.gender;
      _isPregnant = profile.isPregnant;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final state = CarePlusStateScope.of(context);
    final age = int.tryParse(_ageCtrl.text.trim()) ?? 30;
    final weight = double.tryParse(_weightCtrl.text.trim()) ?? 68.0;
    final height = double.tryParse(_heightCtrl.text.trim()) ?? 170.0;

    final updatedProfile = state.userProfile.copyWith(
      name: _nameCtrl.text.trim(),
      age: age,
      gender: _gender,
      weightKg: weight,
      heightCm: height,
      location: _locationCtrl.text.trim(),
      isPregnant: _gender == 'Female' ? _isPregnant : false,
    );

    state.updateUserProfile(updatedProfile);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProblemSymptomPage(profile: updatedProfile),
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
          state.tr('patient_info_title'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
        actions: const [
          LanguageSelectorButton(),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                      child: const Text(
                        'Step 1 of 2',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Personal Details',
                      style: TextStyle(
                        fontSize: 13 * state.fontScale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  state.tr('patient_info_subtitle'),
                  style: TextStyle(
                    fontSize: 13.5 * state.fontScale,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 20),

                // Full Name
                Text(
                  state.tr('full_name'),
                  style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameCtrl,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter name' : null,
                  decoration: InputDecoration(
                    hintText: state.tr('full_name_hint'),
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),

                // Age & Gender Row
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.tr('age'),
                            style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _ageCtrl,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final num = int.tryParse(v ?? '');
                              if (num == null || num <= 0 || num > 120) {
                                return 'Invalid age';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: state.tr('age_hint'),
                              prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.tr('gender'),
                            style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                width: 1.2,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _gender,
                                isExpanded: true,
                                items: ['Male', 'Female', 'Other'].map((g) {
                                  return DropdownMenuItem(
                                    value: g,
                                    child: Text(g, style: TextStyle(fontSize: 14 * state.fontScale)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _gender = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Height & Weight Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.tr('height_cm'),
                            style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _heightCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g. 170',
                              prefixIcon: Icon(Icons.height, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.tr('weight_kg'),
                            style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _weightCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g. 68',
                              prefixIcon: Icon(Icons.monitor_weight_outlined, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location
                Text(
                  state.tr('location'),
                  style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(
                    hintText: state.tr('location_hint'),
                    prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                  ),
                ),

                // Pregnancy Question (if Female)
                if (_gender == 'Female') ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🤰', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Text(
                              state.tr('pregnancy_question'),
                              style: TextStyle(
                                fontSize: 13.5 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.secondaryDark,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isPregnant,
                          activeThumbColor: AppColors.secondary,
                          activeTrackColor: AppColors.secondaryLight,
                          onChanged: (val) => setState(() => _isPregnant = val),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
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
            text: state.tr('btn_next'),
            icon: Icons.arrow_forward_rounded,
            onPressed: _onNext,
          ),
        ),
      ),
    );
  }
}
