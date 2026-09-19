import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/health_history_card.dart';
import '../widgets/custom_button.dart';
import 'health_result_page.dart';
import 'patient_info_page.dart';

class HealthHistoryPage extends StatefulWidget {
  const HealthHistoryPage({super.key});

  @override
  State<HealthHistoryPage> createState() => _HealthHistoryPageState();
}

class _HealthHistoryPageState extends State<HealthHistoryPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = state.history.where((rec) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return rec.reportedProblem.toLowerCase().contains(q) ||
          rec.symptoms.any((s) => s.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health History',
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search past problems or symptoms...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.history_toggle_off_rounded, size: 56, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty ? 'No matches found.' : 'No saved health checks yet.',
                              style: TextStyle(
                                fontSize: 16 * state.fontScale,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start your first health assessment to track guidance over time.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13 * state.fontScale,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: state.tr('home_main_cta'),
                              width: 200,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const PatientInfoPage()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, idx) {
                        final record = filtered[idx];
                        return HealthHistoryCard(
                          record: record,
                          onTap: () {
                            state.setCurrentResult(record.guidanceResult, record.input);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HealthResultPage(
                                  result: record.guidanceResult,
                                  input: record.input,
                                ),
                              ),
                            );
                          },
                          onDelete: () => state.deleteHistoryItem(record.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
