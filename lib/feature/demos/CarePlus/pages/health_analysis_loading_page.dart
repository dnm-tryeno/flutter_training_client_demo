import 'package:flutter/material.dart';
import '../models/health_check_input.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_result_page.dart';

class HealthAnalysisLoadingPage extends StatefulWidget {
  final HealthCheckInput input;

  const HealthAnalysisLoadingPage({super.key, required this.input});

  @override
  State<HealthAnalysisLoadingPage> createState() => _HealthAnalysisLoadingPageState();
}

class _HealthAnalysisLoadingPageState extends State<HealthAnalysisLoadingPage> {
  int _analysisStep = 0;

  final List<String> _steps = [
    'Evaluating reported symptoms and duration...',
    'Checking allergy & pregnancy safety contraindications...',
    'Generating personalized diet & food suggestions...',
    'Curating gentle yoga & exercise routines...',
    'Preparing medicine safety guidance and doctor advice...',
  ];

  @override
  void initState() {
    super.initState();
    _startAnalysisPipeline();
  }

  Future<void> _startAnalysisPipeline() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      if (mounted) setState(() => _analysisStep = i);
    }

    final state = CarePlusStateScope.of(context);
    final result = await state.runHealthCheck(widget.input);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HealthResultPage(result: result, input: widget.input),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.monitor_heart, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 32),
              Text(
                state.tr('analysis_in_progress'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20 * state.fontScale,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                state.tr('analysis_subtext'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: _steps.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final text = entry.value;
                    final isDone = idx < _analysisStep;
                    final isCurrent = idx == _analysisStep;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          if (isDone)
                            const Icon(Icons.check_circle, size: 18, color: AppColors.healthGreen)
                          else if (isCurrent)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.primary),
                            )
                          else
                            const Icon(Icons.radio_button_unchecked, size: 18, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 12.5 * state.fontScale,
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                color: isCurrent
                                    ? (isDark ? Colors.white : AppColors.primaryDark)
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
