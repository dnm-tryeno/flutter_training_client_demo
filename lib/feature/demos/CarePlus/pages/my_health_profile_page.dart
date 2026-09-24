import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/profile_card.dart';
import '../widgets/health_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/section_header.dart';
import 'health_history_page.dart';

class MyHealthProfilePage extends StatelessWidget {
  const MyHealthProfilePage({super.key});

  void _showEditProfileSheet(BuildContext context, CarePlusState state) {
    final profile = state.userProfile;
    final nameCtrl = TextEditingController(text: profile.name);
    final ageCtrl = TextEditingController(text: profile.age.toString());
    final weightCtrl = TextEditingController(text: profile.weightKg.toInt().toString());
    final heightCtrl = TextEditingController(text: profile.heightCm.toInt().toString());
    final locationCtrl = TextEditingController(text: profile.location);
    final conditionsCtrl = TextEditingController(text: profile.conditions.join(', '));
    final allergiesCtrl = TextEditingController(text: profile.allergies.join(', '));
    final medsCtrl = TextEditingController(text: profile.currentMedications.join(', '));
    String gender = profile.gender;
    bool isPregnant = profile.isPregnant;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Health Profile',
                      style: TextStyle(
                        fontSize: 18 * state.fontScale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ageCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Age (Yrs)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: gender,
                        decoration: const InputDecoration(labelText: 'Gender'),
                        items: ['Male', 'Female', 'Other'].map((g) {
                          return DropdownMenuItem(value: g, child: Text(g));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setSheetState(() => gender = val);
                        },
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: locationCtrl,
            decoration: const InputDecoration(labelText: 'Location / City'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: conditionsCtrl,
            decoration: const InputDecoration(
              labelText: 'Existing Conditions (comma separated)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: allergiesCtrl,
            decoration: const InputDecoration(
              labelText: 'Allergies (comma separated)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: medsCtrl,
            decoration: const InputDecoration(
              labelText: 'Current Medications (comma separated)',
            ),
          ),
          if (gender == 'Female') ...[
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Currently Pregnant'),
              value: isPregnant,
              activeThumbColor: AppColors.secondary,
              onChanged: (val) => setSheetState(() => isPregnant = val),
            ),
          ],
          const SizedBox(height: 20),
          CustomButton(
            text: 'Save Changes',
            onPressed: () {
              final updated = profile.copyWith(
                name: nameCtrl.text.trim(),
                age: int.tryParse(ageCtrl.text.trim()) ?? profile.age,
                gender: gender,
                heightCm: double.tryParse(heightCtrl.text.trim()) ?? profile.heightCm,
                weightKg: double.tryParse(weightCtrl.text.trim()) ?? profile.weightKg,
                location: locationCtrl.text.trim(),
                conditions: conditionsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                allergies: allergiesCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                currentMedications: medsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                isPregnant: gender == 'Female' ? isPregnant : false,
              );
              state.updateUserProfile(updated);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Health profile updated successfully!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
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
    final profile = state.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.tr('profile_title'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.primary),
            tooltip: 'View History',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HealthHistoryPage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Summary Card with BMI Gauge
              ProfileCard(
                profile: profile,
                onEdit: () => _showEditProfileSheet(context, state),
              ),
              const SizedBox(height: 16),

              // Health Checks Stats Tile
              HealthCard(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HealthHistoryPage()),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fact_check_rounded, size: 24, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.tr('health_records_count'),
                            style: TextStyle(
                              fontSize: 12 * state.fontScale,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.history.length} Checks Recorded',
                            style: TextStyle(
                              fontSize: 16 * state.fontScale,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Known Medical Conditions
              SectionHeader(
                title: state.tr('saved_conditions'),
                icon: Icons.monitor_heart_outlined,
              ),
              if (profile.conditions.isEmpty)
                _emptyPlaceholder('No known chronic conditions reported.', state, isDark)
              else
                ...profile.conditions.map((c) => _detailTile(c, Icons.check_circle_outline, AppColors.info, isDark)),
              const SizedBox(height: 16),

              // Known Allergies
              SectionHeader(
                title: state.tr('saved_allergies'),
                icon: Icons.warning_amber_rounded,
              ),
              if (profile.allergies.isEmpty)
                _emptyPlaceholder('No known drug or food allergies reported.', state, isDark)
              else
                ...profile.allergies.map((a) => _detailTile(a, Icons.warning_outlined, AppColors.warning, isDark)),
              const SizedBox(height: 16),

              // Current Medicines
              SectionHeader(
                title: state.tr('saved_medicines'),
                icon: Icons.medication_outlined,
              ),
              if (profile.currentMedications.isEmpty)
                _emptyPlaceholder('No ongoing medications reported.', state, isDark)
              else
                ...profile.currentMedications
                    .map((m) => _detailTile(m, Icons.medication_rounded, AppColors.primary, isDark)),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile(String text, IconData icon, Color color, bool isDark) {
    return HealthCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyPlaceholder(String text, CarePlusState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12 * state.fontScale,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
