import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/health_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/section_header.dart';
import '../services/health_suggestion_engine.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _emergencyCtrl;
  late TextEditingController _aiPromptCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _emergencyCtrl = TextEditingController();
    _aiPromptCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = CarePlusStateScope.of(context);
    if (_emergencyCtrl.text.isEmpty) {
      _emergencyCtrl.text = state.emergencyNumber;
      _aiPromptCtrl.text = state.adminContent.aiSystemPrompt;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emergencyCtrl.dispose();
    _aiPromptCtrl.dispose();
    super.dispose();
  }

  void _saveConfigs() {
    final state = CarePlusStateScope.of(context);
    state.updateEmergencyNumber(_emergencyCtrl.text.trim());
    state.updateAdminContent(
      state.adminContent.copyWith(
        emergencyNumber: _emergencyCtrl.text.trim(),
        aiSystemPrompt: _aiPromptCtrl.text.trim(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Admin configuration saved successfully!'),
        backgroundColor: AppColors.primary,
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
          'CarePlus Admin CMS',
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Analytics'),
            Tab(text: 'Content & Meds'),
            Tab(text: 'AI & Emergency'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Analytics
            _buildAnalyticsTab(state, isDark),

            // Tab 2: Content & Medicine Review
            _buildContentReviewTab(state, isDark),

            // Tab 3: AI & Emergency Config
            _buildConfigTab(state, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab(CarePlusState state, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Platform Real-Time Analytics',
            subtitle: 'Overview of patient activity and health checks',
            icon: Icons.analytics_outlined,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _statCard('Total Patients', '1 (Local)', Icons.people_outline, AppColors.primary, state, isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  'Health Checks',
                  '${state.history.length}',
                  Icons.assignment_turned_in_outlined,
                  AppColors.healthGreen,
                  state,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  'Educational Meds',
                  '${HealthSuggestionEngine.verifiedMedicineDatabase.length}',
                  Icons.medication_outlined,
                  AppColors.info,
                  state,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  'Emergency Alert Dial',
                  state.emergencyNumber,
                  Icons.emergency_outlined,
                  AppColors.emergency,
                  state,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          HealthCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDFA),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Medical Compliance Status: Active',
                      style: TextStyle(
                        fontSize: 14 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'All educational health topics and medicine safety entries adhere to non-prescriptive clinical guidelines. Last global review: September 2026.',
                  style: TextStyle(
                    fontSize: 12.5 * state.fontScale,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String label,
    String val,
    IconData icon,
    Color color,
    CarePlusState state,
    bool isDark,
  ) {
    return HealthCard(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            val,
            style: TextStyle(
              fontSize: 20 * state.fontScale,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12 * state.fontScale,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentReviewTab(CarePlusState state, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: HealthSuggestionEngine.verifiedMedicineDatabase.length,
      itemBuilder: (ctx, idx) {
        final med = HealthSuggestionEngine.verifiedMedicineDatabase[idx];
        return HealthCard(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      med.name,
                      style: TextStyle(
                        fontSize: 15 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.healthGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'VERIFIED',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.healthGreen),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Reviewer: ${med.medicalReviewer}',
                style: TextStyle(fontSize: 12 * state.fontScale, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              Text(
                'Source: ${med.sourceReference} • Last Checked: ${med.lastReviewedDate}',
                style: TextStyle(fontSize: 11 * state.fontScale, color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfigTab(CarePlusState state, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Emergency Service & AI Rules',
            subtitle: 'Configure emergency phone numbers and LLM guardrails',
            icon: Icons.settings_suggest_rounded,
          ),
          const SizedBox(height: 12),
          Text(
            'Country / Local Emergency Number',
            style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _emergencyCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. 112 (India/EU), 911 (US), 108',
              prefixIcon: Icon(Icons.phone_in_talk, color: AppColors.emergency),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'CarePlus AI System Prompt & Guardrails',
            style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _aiPromptCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'LLM system instructions enforcing non-prescriptive safety...',
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: Icon(Icons.security_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Save Configurations',
            icon: Icons.save_rounded,
            onPressed: _saveConfigs,
          ),
        ],
      ),
    );
  }
}
