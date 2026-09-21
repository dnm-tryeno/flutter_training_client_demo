import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/health_card.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/section_header.dart';
import '../widgets/health_history_card.dart';
import '../widgets/care_plus_logo.dart';
import 'patient_info_page.dart';
import 'health_history_page.dart';
import 'health_result_page.dart';

class HomePage extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomePage({super.key, this.onNavigateTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 0: Dentist, 1: Other
  int _selectedTopTab = 0;

  void _startHealthCheck(BuildContext context, {String? initialProblem, bool? isDiabetes}) {
    final bool diabetesMode = isDiabetes ?? (_selectedTopTab == 0);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientInfoPage(
          initialProblem: initialProblem,
          isDiabetes: diabetesMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isDiabetesTab = _selectedTopTab == 0;

    final diabetesChips = [
      {'label': 'High Blood Sugar (Hyper)', 'query': 'High blood sugar / Hyperglycemia'},
      {'label': 'Low Sugar & Sweating (Hypo)', 'query': 'Low sugar / Hypoglycemia'},
      {'label': 'Frequent Urination (Peshab)', 'query': 'Frequent urination / High glucose'},
      {'label': 'Excessive Thirst (Jyada pyaas)', 'query': 'Excessive thirst & dry mouth'},
      {'label': 'Fatigue & Low Energy', 'query': 'Diabetes fatigue & weakness'},
      {'label': 'Foot Numbness / Tingling', 'query': 'Foot numbness / Diabetic neuropathy'},
      {'label': 'Slow Wound Healing', 'query': 'Slow wound healing in diabetes'},
    ];

    final generalChips = [
      {'label': 'Headache (Sir dard)', 'query': 'Sir dard hai / Headache'},
      {'label': 'Acidity & Gas', 'query': 'Acidity & Gas issue'},
      {'label': 'Back pain / Kamar dard', 'query': 'Back pain / Kamar dard'},
      {'label': 'Fever / Bukhar', 'query': 'Fever / Bukhar'},
      {'label': 'Fatigue & Weakness', 'query': 'Thakan hoti hai / Fatigue & weakness'},
      {'label': 'Blood pressure high', 'query': 'Blood pressure high rehta hai'},
      {'label': 'Sleep trouble', 'query': 'Neend nahi aa rahi / Sleep trouble'},
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: CarePlusLogo(
          fontScale: state.fontScale,
          height: 26 * state.fontScale,
          maxWidth: 132,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => state.initialize(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top 2 Tabs: Diabetes & Other
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Tab 1: Diabetes
                      Expanded(
                        child: _TopTabItem(
                          title: state.tr('tab_diabetes'),
                          icon: Icons.water_drop_outlined,
                          isSelected: _selectedTopTab == 0,
                          activeColor: const Color(0xFF0369A1),
                          fontScale: state.fontScale,
                          onTap: () => setState(() => _selectedTopTab = 0),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Tab 2: Other
                      Expanded(
                        child: _TopTabItem(
                          title: state.tr('tab_other'),
                          icon: Icons.medical_services_rounded,
                          isSelected: _selectedTopTab == 1,
                          activeColor: AppColors.primary,
                          fontScale: state.fontScale,
                          onTap: () => setState(() => _selectedTopTab = 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Greeting & Subtext
                Text(
                  isDiabetesTab ? state.tr('diabetes_greeting') : state.tr('home_greeting'),
                  style: TextStyle(
                    fontSize: 21 * state.fontScale,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDiabetesTab ? state.tr('diabetes_subtext') : state.tr('home_subtext'),
                  style: TextStyle(
                    fontSize: 13.5 * state.fontScale,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Main CTA Hero Banner
                if (isDiabetesTab)
                  _buildDiabetesHeroBanner(context, state)
                else
                  _buildGeneralHeroBanner(context, state),
                const SizedBox(height: 18),

                // Quick Problem Chips Section
                SectionHeader(
                  title: isDiabetesTab ? state.tr('diabetes_quick_problems') : state.tr('home_quick_options'),
                  icon: isDiabetesTab ? Icons.water_drop_outlined : Icons.flash_on_rounded,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (isDiabetesTab ? diabetesChips : generalChips).map((item) {
                    return ActionChip(
                      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      label: Text(
                        item['label']!,
                        style: TextStyle(
                          fontSize: 12.5 * state.fontScale,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      onPressed: () => _startHealthCheck(
                        context,
                        initialProblem: item['query'],
                        isDiabetes: isDiabetesTab,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Daily Insight Tip Card
                HealthCard(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: isDark ? const Color(0xFF132E35) : const Color(0xFFECFDF5),
                  border: Border.all(color: AppColors.healthGreen.withValues(alpha: 0.3)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.healthGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDiabetesTab ? Icons.water_drop_rounded : Icons.tips_and_updates_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDiabetesTab ? state.tr('diabetes_daily_tip_title') : state.tr('daily_tip_title'),
                              style: TextStyle(
                                fontSize: 13.5 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.teal[200] : const Color(0xFF065F46),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isDiabetesTab ? state.tr('diabetes_daily_tip_body') : state.tr('daily_tip_body'),
                              style: TextStyle(
                                fontSize: 12.5 * state.fontScale,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF047857),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Diabetes Specific Supportive Care Card (When Diabetes tab active)
                if (isDiabetesTab) ...[
                  SectionHeader(
                    title: state.tr('diabetes_home_remedies_title'),
                    icon: Icons.spa_outlined,
                  ),
                  HealthCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
                    border: Border.all(color: Colors.teal.withValues(alpha: 0.25)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _remedyRow('Warm Water & Methi Dana', '1 tsp soaked fenugreek seeds in morning aids fasting glucose control.', state.fontScale, isDark),
                        const Divider(height: 16),
                        _remedyRow('Low Glycemic Index Diet', 'Choose whole pulses, oats, and leafy vegetables; avoid refined white flour & sweets.', state.fontScale, isDark),
                        const Divider(height: 16),
                        _remedyRow('Post-Meal 15-Min Walk', 'Brisk walking 15-20 minutes after meals helps reduce sudden glucose spikes.', state.fontScale, isDark),
                        const Divider(height: 16),
                        _remedyRow('Daily Foot Inspection', 'Wash, dry, and inspect feet daily for cuts or dry skin to prevent diabetic sores.', state.fontScale, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Recent Health Checks
                SectionHeader(
                  title: state.tr('recent_checks'),
                  trailing: state.history.isNotEmpty
                      ? TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HealthHistoryPage()),
                          ),
                          child: Text(
                            state.tr('view_all_history'),
                            style: TextStyle(fontSize: 12 * state.fontScale, fontWeight: FontWeight.w700),
                          ),
                        )
                      : null,
                ),
                if (state.history.isEmpty)
                  HealthCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.assignment_outlined, size: 36, color: AppColors.textTertiaryLight),
                        const SizedBox(height: 8),
                        Text(
                          state.tr('no_recent_checks'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13 * state.fontScale,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...state.history.take(2).map(
                        (record) => HealthHistoryCard(
                          record: record,
                          onTap: () {
                            state.setCurrentResult(record.guidanceResult, record.input);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HealthResultPage(result: record.guidanceResult, input: record.input),
                              ),
                            );
                          },
                          onDelete: () => state.deleteHistoryItem(record.id),
                        ),
                      ),
                const SizedBox(height: 14),

                // Compact Medical Disclaimer
                const DisclaimerBanner(compact: true),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _remedyRow(String title, String desc, double fontScale, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13 * fontScale,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.teal[200] : const Color(0xFF0F766E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: TextStyle(
            fontSize: 12 * fontScale,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDiabetesHeroBanner(BuildContext context, CarePlusState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0369A1).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.water_drop_outlined, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Blood Sugar Safety Engine',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.water_drop_rounded, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            state.tr('diabetes_main_cta'),
            style: TextStyle(
              fontSize: 20 * state.fontScale,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check blood glucose control, low sugar (hypo), HbA1c diet & diabetologist consult.',
            style: TextStyle(
              fontSize: 12.5 * state.fontScale,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => _startHealthCheck(
                context,
                initialProblem: 'Diabetes / Blood Sugar Management',
                isDiabetes: true,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0369A1),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_task_rounded, size: 20, color: Color(0xFF0369A1)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        state.tr('diabetes_main_cta'),
                        style: TextStyle(
                          fontSize: 15 * state.fontScale,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralHeroBanner(BuildContext context, CarePlusState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Safe Guidance Engine',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Start Health Checkup',
            style: TextStyle(
              fontSize: 20 * state.fontScale,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enter symptoms to get food, yoga, lifestyle & medicine safety guidance.',
            style: TextStyle(
              fontSize: 12.5 * state.fontScale,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => _startHealthCheck(context, isDiabetes: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryDark,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_task_rounded, size: 20, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        state.tr('home_main_cta'),
                        style: TextStyle(
                          fontSize: 15 * state.fontScale,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTabItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final double fontScale;
  final VoidCallback onTap;

  const _TopTabItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.fontScale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5 * fontScale,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
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
    );
  }
}
