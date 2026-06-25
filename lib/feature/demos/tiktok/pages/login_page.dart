import 'package:flutter/material.dart';

import '../theme.dart';
import 'main_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [TikTokColors.primary, TikTokColors.accent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TikTokColors.primary.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.music_video,
                      size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text(
                  'StarTik',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Short videos. Big stars.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Spacer(),
                _GoogleSignInButton(),
                const SizedBox(height: 16),
                const Text(
                  'By continuing you agree to our\nTerms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
        label: const Text('Continue with Google',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScaffold()),
          );
        },
      ),
    );
  }
}
