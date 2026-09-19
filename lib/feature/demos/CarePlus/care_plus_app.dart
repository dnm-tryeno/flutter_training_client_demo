import 'package:flutter/material.dart';
import 'state/care_plus_state.dart';
import 'theme/app_theme.dart';
import 'pages/splash_onboarding_page.dart';
import 'pages/main_navigation_shell.dart';

/// CarePlus Root Widget
///
/// Production-ready health guidance companion app.
/// Provides general health guidance, food/diet advice, yoga/exercise routines,
/// medicine safety educational repository, doctor consultation recommendations,
/// emergency SOS triage, and conversational CarePlus AI assistant.
class CarePlusApp extends StatefulWidget {
  const CarePlusApp({super.key});

  @override
  State<CarePlusApp> createState() => _CarePlusAppState();
}

class _CarePlusAppState extends State<CarePlusApp> {
  late final CarePlusState _state;

  @override
  void initState() {
    super.initState();
    _state = CarePlusState();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarePlusStateScope(
      notifier: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          final isDark = _state.isDarkMode;
          final fontScale = _state.fontScale;

          return MaterialApp(
            title: 'CarePlus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(fontScale: fontScale),
            darkTheme: AppTheme.darkTheme(fontScale: fontScale),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: !_state.isInitialized
                ? const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _state.isDisclaimerAccepted
                    ? const MainNavigationShell()
                    : const SplashOnboardingPage(),
          );
        },
      ),
    );
  }
}
