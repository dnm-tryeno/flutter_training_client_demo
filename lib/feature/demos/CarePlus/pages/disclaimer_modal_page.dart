import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/custom_button.dart';
import 'main_navigation_shell.dart';

class DisclaimerModalPage extends StatelessWidget {
  const DisclaimerModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, size: 40, color: AppColors.warningDark),
              ),
              const SizedBox(height: 18),
              Text(
                state.tr('disclaimer_title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20 * state.fontScale,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please review carefully before using CarePlus',
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.tr('disclaimer_text'),
                          style: TextStyle(
                            fontSize: 14 * state.fontScale,
                            height: 1.6,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF78350F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        _ruleItem(
                          '1. Non-Diagnostic Companion',
                          'CarePlus is not a doctor and does not provide formal medical diagnoses or prescriptions.',
                          state,
                          isDark,
                        ),
                        const SizedBox(height: 10),
                        _ruleItem(
                          '2. Medicine Modification Warning',
                          'Never start, stop, or adjust any medicine dosage without direct consultation with a licensed physician.',
                          state,
                          isDark,
                        ),
                        const SizedBox(height: 10),
                        _ruleItem(
                          '3. Emergency Protocol',
                          'For severe symptoms (chest pain, shortness of breath, sudden weakness), call emergency services immediately.',
                          state,
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: state.tr('disclaimer_accept'),
                icon: Icons.check_circle_outline,
                onPressed: () async {
                  await state.acceptDisclaimer();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ruleItem(String title, String body, CarePlusState state, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.check, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12 * state.fontScale,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
