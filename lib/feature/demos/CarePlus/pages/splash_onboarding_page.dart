import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../localization/app_language.dart';
import '../widgets/custom_button.dart';
import '../widgets/care_plus_logo.dart';
import '../widgets/theme_toggle_button.dart';
import 'disclaimer_modal_page.dart';
import 'main_navigation_shell.dart';

class SplashOnboardingPage extends StatefulWidget {
  const SplashOnboardingPage({super.key});

  @override
  State<SplashOnboardingPage> createState() => _SplashOnboardingPageState();
}

class _SplashOnboardingPageState extends State<SplashOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<Map<String, dynamic>> slides = [
    {
      'icon': Icons.health_and_safety_rounded,
      'title': 'Welcome to CarePlus',
      'subtitle': 'Your Simple & Safe Health Guidance Companion',
      'desc':
          'Get personalized, general health guidance, food/diet advice, safe yoga routines, and doctor consultation recommendations.',
      'tag': 'Simple • Safe • Trusted',
    },
    {
      'icon': Icons.restaurant_menu_rounded,
      'title': 'Diet & Exercise Guidance',
      'subtitle': 'Nutritional & Activity Insights',
      'desc':
          'Understand which foods support your body and learn gentle yoga stretches with clear instructions and safety precautions.',
      'tag': 'Food • Yoga • Lifestyle',
    },
    {
      'icon': Icons.shield_rounded,
      'title': 'Medicine Safety First',
      'subtitle': 'Verified Educational Information',
      'desc':
          'CarePlus promotes patient safety with clear medicine precautions and transparent doctor consultation recommendations.',
      'tag': 'Non-Prescriptive • Transparent',
    },
  ];

  void _onNext() {
    if (_currentPage < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _proceedToDisclaimer();
    }
  }

  void _proceedToDisclaimer() {
    final state = CarePlusStateScope.of(context);
    if (!state.isDisclaimerAccepted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DisclaimerModalPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Bar with Language Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CarePlusLogo(fontScale: state.fontScale, height: 26 * state.fontScale),
                  const Spacer(),
                  const ThemeToggleButton(),
                  const SizedBox(width: 8),
                  PopupMenuButton<AppLanguage>(
                    initialValue: state.language,
                    onSelected: (lang) => state.setLanguage(lang),
                    itemBuilder: (ctx) => AppLanguage.values.map((l) {
                      return PopupMenuItem(
                        value: l,
                        child: Text(l.displayName),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.language, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            state.language.displayName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Carousel PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: slides.length,
                  itemBuilder: (ctx, index) {
                    final slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(slide['icon'] as IconData, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            slide['tag'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          slide['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24 * state.fontScale,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          slide['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14 * state.fontScale,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            slide['desc'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5 * state.fontScale,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.primary
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Bottom Actions
              CustomButton(
                text: _currentPage == slides.length - 1 ? 'Get Started' : 'Continue',
                onPressed: _onNext,
              ),
              const SizedBox(height: 10),
              if (_currentPage < slides.length - 1)
                TextButton(
                  onPressed: _proceedToDisclaimer,
                  child: Text(
                    'Skip to Main App',
                    style: TextStyle(
                      fontSize: 13 * state.fontScale,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
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
