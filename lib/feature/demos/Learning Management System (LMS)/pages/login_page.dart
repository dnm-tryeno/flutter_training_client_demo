import 'package:flutter/material.dart';

import '../theme.dart';
import 'main_scaffold.dart';

/// Mobile number + OTP login with a Truecaller-style quick option,
/// mirroring the reference app's onboarding.
class LmsLoginPage extends StatefulWidget {
  const LmsLoginPage({super.key});

  @override
  State<LmsLoginPage> createState() => _LmsLoginPageState();
}

class _LmsLoginPageState extends State<LmsLoginPage> {
  bool _otpSent = false;
  final _phone = TextEditingController(text: '98765 43210');

  void _enter() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LmsMainScaffold()),
    );
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [LmsColors.primary, LmsColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.school,
                    size: 52, color: LmsColors.primary),
              ),
              const SizedBox(height: 20),
              const Text(
                'EduLearn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Learn. Practice. Succeed.',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                decoration: const BoxDecoration(
                  color: LmsColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _otpSent ? 'Enter OTP' : 'Login / Sign up',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: LmsColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _otpSent
                          ? 'We sent a 4-digit code to +91 ${_phone.text}'
                          : 'Continue with your mobile number',
                      style: const TextStyle(
                          color: LmsColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    if (!_otpSent) ...[
                      TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            child: Text('🇮🇳  +91',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0),
                          hintText: 'Mobile number',
                          filled: true,
                          fillColor: LmsColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _primaryButton('Get OTP',
                          () => setState(() => _otpSent = true)),
                      const SizedBox(height: 16),
                      Row(children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR',
                              style: TextStyle(
                                  color: LmsColors.textSecondary,
                                  fontSize: 12)),
                        ),
                        Expanded(child: Divider()),
                      ]),
                      const SizedBox(height: 16),
                      _truecallerButton(),
                    ] else ...[
                      _OtpRow(),
                      const SizedBox(height: 20),
                      _primaryButton('Verify & Continue', _enter),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => setState(() => _otpSent = false),
                          child: const Text('Change number',
                              style: TextStyle(color: LmsColors.primary)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'By continuing you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: LmsColors.textSecondary, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: LmsColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(label,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _truecallerButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: LmsColors.accent,
          side: const BorderSide(color: LmsColors.accent),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.verified_user),
        label: const Text('Continue with Truecaller',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        onPressed: _enter,
      ),
    );
  }
}

class _OtpRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (i) {
        return SizedBox(
          width: 60,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: LmsColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      }),
    );
  }
}
