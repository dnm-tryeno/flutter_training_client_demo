import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../widgets/custom_button.dart';
import 'main_navigation_shell.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailCtrl = TextEditingController(text: 'rohan.sharma@example.com');
  final TextEditingController _passCtrl = TextEditingController(text: 'password123');
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onProceed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSignUp ? 'Create CarePlus Account' : 'Sign In to CarePlus',
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isSignUp ? 'Join CarePlus for secure health tracking' : 'Welcome Back',
                style: TextStyle(
                  fontSize: 22 * state.fontScale,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your health data is stored securely and privately.',
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isSignUp ? 'Create Account' : 'Sign In',
                onPressed: _onProceed,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Continue as Guest',
                variant: ButtonVariant.subtle,
                onPressed: _onProceed,
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp ? 'Already have an account? Sign In' : "Don't have an account? Sign Up",
                    style: TextStyle(
                      fontSize: 13 * state.fontScale,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
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
