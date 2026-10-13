import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/main_navigation_shell.dart';

class MyBillBookApp extends StatelessWidget {
  const MyBillBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myBillBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationShell(),
    );
  }
}
