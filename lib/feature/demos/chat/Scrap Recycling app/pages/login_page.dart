import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';
import '../widgets/scrap_collector_video_bg.dart';

class ScrapLoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const ScrapLoginPage({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<ScrapLoginPage> createState() => _ScrapLoginPageState();
}

class _ScrapLoginPageState extends State<ScrapLoginPage> {
  final PageController _pageController = PageController();
  int _activeIntroPage = 0;

  UserRole _selectedRole = UserRole.customer;
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  final TextEditingController _nameController = TextEditingController(text: 'Vikram Malhotra');
  final TextEditingController _vendorShopController = TextEditingController(text: 'Shree Ganesh Scrap Godown');
  final TextEditingController _gstinController = TextEditingController(text: '07AAACG9283K1Z5');

  bool _isOtpStage = false;
  final List<TextEditingController> _otpControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _otpFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  int _resendCountdown = 30;
  Timer? _countdownTimer;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _onboardingSlides = [
    {
      'title': 'Doorstep Scrap Pickup',
      'hindi': 'घर बैठे कबाड़ बेचें',
      'desc': 'Book pickup in 60s. Verified agents collect at your chosen time slot.',
      'icon': Icons.local_shipping_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Certified Digital Scales',
      'hindi': '100% सटीक डिजिटल कांटा',
      'desc': 'Govt-certified electronic scale weighing right in front of you.',
      'icon': Icons.scale_rounded,
      'color': const Color(0xFF38BDF8),
    },
    {
      'title': 'Commercial Bulk Slabs',
      'hindi': 'थोक विक्रेताओं के लिए विशेष स्लैब',
      'desc': 'Automatic higher slab rates for scrap godowns & commercial sellers.',
      'icon': Icons.trending_up_rounded,
      'color': const Color(0xFFFBBF24),
    },
    {
      'title': 'Instant UPI / Cash Payout',
      'hindi': 'हाथों-हाथ नकद या यूपीआई भुगतान',
      'desc': 'Immediate payout via UPI QR or hard cash as soon as weighed.',
      'icon': Icons.currency_rupee_rounded,
      'color': const Color(0xFF34D399),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _vendorShopController.dispose();
    _gstinController.dispose();
    _countdownTimer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 30;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleSendOtp() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isOtpStage = true;
    });
    _startCountdown();
  }

  void _fillDemoOtp() {
    final demoCode = ['8', '4', '9', '2'];
    for (int i = 0; i < 4; i++) {
      _otpControllers[i].text = demoCode[i];
    }
    setState(() {});
  }

  void _verifyAndProceed() {
    final enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit OTP or tap Auto-fill'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final state = ScrapStateScope.of(context);
      final finalName = _selectedRole == UserRole.vendor
          ? _vendorShopController.text.trim()
          : _nameController.text.trim();

      state.login(
        phone: '+91 ${_phoneController.text.trim()}',
        name: finalName.isNotEmpty ? finalName : 'Valued User',
        role: _selectedRole,
      );

      widget.onLoginSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrapCollectorVideoBackground(
        overlayOpacity: 0.72,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Brand Strip & Direct Entry
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF047857)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.recycling_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KABADA',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'कबाड़ा • स्मार्ट रीसाइक्लिंग',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6EE7B7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Direct Entry Button
                      TextButton.icon(
                        onPressed: () {
                          final state = ScrapStateScope.of(context);
                          state.login(
                            phone: '+91 98765 43210',
                            name: _selectedRole == UserRole.vendor
                                ? 'Shree Ganesh Scrap Godown'
                                : 'Vikram Malhotra',
                            role: _selectedRole,
                          );
                          widget.onLoginSuccess();
                        },
                        icon: const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFFFDE68A)),
                        label: Text(
                          'Direct Entry',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.white24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Compact Highlights Carousel
                  SizedBox(
                    height: 105,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingSlides.length,
                      onPageChanged: (i) => setState(() => _activeIntroPage = i),
                      itemBuilder: (context, i) {
                        final slide = _onboardingSlides[i];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: slide['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  slide['icon'] as IconData,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      slide['title'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      slide['hindi'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6EE7B7),
                                      ),
                                    ),
                                    Text(
                                      slide['desc'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Carousel Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_onboardingSlides.length, (index) {
                      final isActive = index == _activeIntroPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 16 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF34D399) : Colors.white30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Role Segment Switcher (Customer vs Vendor)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedRole = UserRole.customer),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.customer
                                    ? ScrapAppTheme.primaryGreen
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.home_rounded, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Customer (Retail)',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedRole = UserRole.vendor),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.vendor
                                    ? ScrapAppTheme.accentAmberDark
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.warehouse_rounded, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Vendor (Bulk Godown)',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Simple Frosted Login Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!_isOtpStage) ...[
                          Text(
                            _selectedRole == UserRole.customer
                                ? 'Sell Scrap & Earn Cash'
                                : 'Commercial Bulk Scrap Portal',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: ScrapAppTheme.textMainLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enter mobile number to get instant verification code.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: ScrapAppTheme.textSubLight,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Phone Input
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 6),
                                const Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(width: 1, height: 22, color: const Color(0xFFCBD5E1)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      hintText: '98765 43210',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Name / Business Name
                          TextField(
                            controller: _selectedRole == UserRole.vendor
                                ? _vendorShopController
                                : _nameController,
                            decoration: InputDecoration(
                              labelText: _selectedRole == UserRole.vendor
                                  ? 'Godown / Shop Name'
                                  : 'Full Name',
                              isDense: true,
                              prefixIcon: Icon(
                                _selectedRole == UserRole.vendor
                                    ? Icons.store_rounded
                                    : Icons.person_rounded,
                                size: 20,
                              ),
                            ),
                          ),

                          if (_selectedRole == UserRole.vendor) ...[
                            const SizedBox(height: 10),
                            TextField(
                              controller: _gstinController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: const InputDecoration(
                                labelText: 'GSTIN (Optional for tax invoice)',
                                isDense: true,
                                prefixIcon: Icon(Icons.badge_rounded, size: 20),
                              ),
                            ),
                          ],

                          const SizedBox(height: 18),

                          ElevatedButton(
                            onPressed: _handleSendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedRole == UserRole.vendor
                                  ? ScrapAppTheme.accentAmberDark
                                  : ScrapAppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get OTP Code',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ] else ...[
                          // OTP Verification Step
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Enter 4-Digit Code',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextButton(
                                onPressed: () => setState(() => _isOtpStage = false),
                                child: const Text('Change Phone', style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                          Text(
                            'Sent to +91 ${_phoneController.text.trim()}',
                            style: const TextStyle(fontSize: 12, color: ScrapAppTheme.textSubLight),
                          ),
                          const SizedBox(height: 16),

                          // 4 OTP Boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 50,
                                height: 54,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: ScrapAppTheme.primaryGreen,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: ScrapAppTheme.primaryGreen,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    if (val.isNotEmpty && index < 3) {
                                      _otpFocusNodes[index + 1].requestFocus();
                                    } else if (val.isEmpty && index > 0) {
                                      _otpFocusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 14),

                          // Auto-fill Demo Chip
                          Center(
                            child: InkWell(
                              onTap: _fillDemoOtp,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF6EE7B7)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF047857)),
                                    SizedBox(width: 6),
                                    Text(
                                      'Auto-fill Demo OTP: 8492',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF047857),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          ElevatedButton(
                            onPressed: _isSubmitting ? null : _verifyAndProceed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ScrapAppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Verify & Continue', style: TextStyle(fontWeight: FontWeight.w800)),
                                      SizedBox(width: 6),
                                      Icon(Icons.check_circle_rounded, size: 18),
                                    ],
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Simple Footer
                  const Center(
                    child: Text(
                      '100% Verified Weights • Instant UPI • ISO 14001',
                      style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
