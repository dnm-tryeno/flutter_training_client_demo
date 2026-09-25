import 'package:flutter/material.dart';
import 'pages/manish_portfolio_page.dart';
import 'theme/app_colors.dart';

class ManishApp extends StatelessWidget {
  const ManishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manish Maurya | Digital Marketing & Web/App Developer',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
      ),
      home: const ManishPortfolioPage(),
    );
  }
}
