import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../localization/app_language.dart';
import '../widgets/health_card.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_button.dart';
import 'disclaimer_modal_page.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  void _showClearDataDialog(BuildContext context, CarePlusState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.delete_forever_rounded, color: AppColors.emergency),
            const SizedBox(width: 8),
            Text(state.tr('clear_health_data')),
          ],
        ),
        content: Text(state.tr('confirm_clear_data')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(state.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              await state.clearAllHealthData();
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.tr('data_cleared_success')),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergency),
            child: Text(state.tr('confirm')),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context, CarePlusState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CarePlus Privacy Policy',
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
              const SizedBox(height: 12),
              const Text(
                '1. Data Minimization & Privacy Protection\nCarePlus respects your sensitive health information. Health concerns, symptom queries, and profile attributes are kept strictly confidential and stored securely on your local device.\n\n2. Non-Commercial Data Usage\nWe do NOT sell, rent, or trade personal health data to third-party advertisers or insurance brokers.\n\n3. AI Processing Guardrails\nAll AI interactions adhere to stringent medical safety guidelines prohibiting unauthorized medication prescriptions and ensuring user privacy.\n\n4. Right to Erase\nYou possess complete control to wipe all stored health checks and profile metrics at any time.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Close',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
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
          state.tr('settings_title'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Preferences Section
              SectionHeader(
                title: 'App Preferences & Accessibility',
                icon: Icons.tune_rounded,
              ),
              HealthCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Theme Mode
                    SwitchListTile(
                      title: Text(
                        state.tr('theme_mode'),
                        style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        state.isDarkMode ? 'Dark theme active' : 'Light theme active',
                        style: TextStyle(fontSize: 12 * state.fontScale),
                      ),
                      secondary: Icon(
                        state.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: AppColors.primary,
                      ),
                      value: state.isDarkMode,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => state.toggleDarkMode(val),
                    ),
                    const Divider(height: 1),

                    // Elderly / Large Font Mode
                    SwitchListTile(
                      title: Text(
                        state.tr('elderly_mode'),
                        style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        state.tr('elderly_mode_desc'),
                        style: TextStyle(fontSize: 11.5 * state.fontScale),
                      ),
                      secondary: const Icon(Icons.format_size_rounded, color: AppColors.primary),
                      value: state.isElderlyMode,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => state.toggleElderlyMode(val),
                    ),
                    const Divider(height: 1),

                    // Language Selector
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                      title: Text(
                        state.tr('language_mode'),
                        style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w600),
                      ),
                      trailing: DropdownButton<AppLanguage>(
                        value: state.language,
                        underline: const SizedBox(),
                        items: AppLanguage.values.map((l) {
                          return DropdownMenuItem(
                            value: l,
                            child: Text(l.displayName, style: TextStyle(fontSize: 13 * state.fontScale)),
                          );
                        }).toList(),
                        onChanged: (lang) {
                          if (lang != null) state.setLanguage(lang);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Medical Safety & Administration
              SectionHeader(
                title: 'Medical Compliance & Security',
                icon: Icons.gavel_rounded,
              ),
              HealthCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: AppColors.warningDark),
                      title: Text(
                        state.tr('disclaimer_title'),
                        style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DisclaimerModalPage()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.lock_outline_rounded, color: AppColors.info),
                      title: Text(
                        state.tr('privacy_policy'),
                        style: TextStyle(fontSize: 14 * state.fontScale, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () => _showPrivacyPolicy(context, state),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Danger Zone
              SectionHeader(
                title: 'Data Management',
                icon: Icons.delete_outline_rounded,
              ),
              HealthCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cleaning_services_rounded, color: AppColors.emergency),
                      title: Text(
                        state.tr('clear_health_data'),
                        style: TextStyle(
                          fontSize: 14 * state.fontScale,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emergency,
                        ),
                      ),
                      onTap: () => _showClearDataDialog(context, state),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'CarePlus v1.0.0 (Production Build)\nSafe Health Guidance Companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11 * state.fontScale,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
