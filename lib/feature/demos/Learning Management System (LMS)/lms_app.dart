import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'theme.dart';

/// Root of the LMS (Learning Management System) demo.
///
/// A Classplus / univ.live-style education app: mobile/OTP login, a home
/// dashboard, live schedule, batches, study material, videos, courses,
/// performance analytics, chat, payments, assignments and notifications.
class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lmsTheme,
      home: const LmsLoginPage(),
    );
  }
}
