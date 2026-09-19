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

class HomePage extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomePage({super.key, this.onNavigateTab});

  void _startHealthCheck(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PatientInfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
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
                // Greeting & Subtext
                Text(
                  state.tr('home_greeting'),
                  style: TextStyle(
                    fontSize: 22 * state.fontScale,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.tr('home_subtext'),
                  style: TextStyle(
                    fontSize: 13.5 * state.fontScale,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Main CTA Hero Banner: "Check My Health"
                Container(
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
                          onPressed: () => _startHealthCheck(context),
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
                              Text(
                                state.tr('home_main_cta'),
                                style: TextStyle(
                                  fontSize: 15 * state.fontScale,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),


                // Daily Health Insight Tip Card
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
                        child: const Icon(Icons.tips_and_updates_rounded, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.tr('daily_tip_title'),
                              style: TextStyle(
                                fontSize: 13.5 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.teal[200] : const Color(0xFF065F46),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.tr('daily_tip_body'),
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
}
