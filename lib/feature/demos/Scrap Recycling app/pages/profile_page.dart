import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_model.dart';
import '../state/scrap_state.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onOpenOrderHistory;

  const ProfilePage({super.key, this.onOpenOrderHistory});

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVendor = state.previewMode == UserRole.vendor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isVendor ? 'Godown & Business Profile' : 'My Account',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isVendor
                      ? [const Color(0xFFD97706), const Color(0xFFF59E0B)]
                      : [const Color(0xFF047857), const Color(0xFF10B981)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isVendor ? const Color(0xFFD97706) : const Color(0xFF047857)).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      isVendor ? Icons.warehouse_rounded : Icons.person_rounded,
                      size: 32,
                      color: isVendor ? const Color(0xFFD97706) : const Color(0xFF047857),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isVendor ? state.vendorProfile.businessName : state.userName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.phoneNumber,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isVendor ? 'VERIFIED GODOWN PARTNER' : 'RETAIL SELLER',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Eco Impact Certificate Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded, color: Color(0xFF047857), size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Green Recycling Champion',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF047857),
                          ),
                        ),
                        const Text(
                          'You have helped save 18 trees and prevent 340 kg of landfill waste.',
                          style: TextStyle(fontSize: 11, color: ScrapAppTheme.textSubLight),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Eco Certificate downloaded & ready to share!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF047857)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Certificate', style: TextStyle(fontSize: 11, color: Color(0xFF047857))),
                  ),
                ],
              ),
            ),

            // Orders & History
            if (onOpenOrderHistory != null) ...[
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                leading: const Icon(Icons.inventory_2_outlined, color: ScrapAppTheme.primaryGreen),
                title: const Text('My Pickups & Scrap History', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                subtitle: Text('${state.orders.length} pickup requests logged', style: const TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: onOpenOrderHistory,
              ),
              const SizedBox(height: 16),
            ],

            // Settings & Preferences
            Text(
              'App Settings & Preferences',
              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),

            // Language Toggle Tile
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              leading: const Icon(Icons.language_rounded, color: ScrapAppTheme.primaryGreen),
              title: const Text('App Language / भाषा', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: Text(state.currentLanguage == 'en' ? 'English (Current)' : 'हिंदी (वर्तमान)', style: const TextStyle(fontSize: 11)),
              trailing: Switch(
                value: state.currentLanguage == 'hi',
                activeThumbColor: ScrapAppTheme.primaryGreen,
                onChanged: (val) {
                  state.setLanguage(val ? 'hi' : 'en');
                },
              ),
            ),

            const SizedBox(height: 8),

            // Dark Mode Tile
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              leading: const Icon(Icons.dark_mode_rounded, color: ScrapAppTheme.primaryGreen),
              title: const Text('Dark Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: Text(isDark ? 'Dark theme enabled' : 'Light theme enabled', style: const TextStyle(fontSize: 11)),
              trailing: Switch(
                value: state.isDarkMode,
                activeThumbColor: ScrapAppTheme.primaryGreen,
                onChanged: (_) => state.toggleTheme(),
              ),
            ),

            const SizedBox(height: 8),

            // Help & FAQs
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              leading: const Icon(Icons.help_outline_rounded, color: ScrapAppTheme.primaryGreen),
              title: const Text('Scrap Quality FAQs & Pricing Policy', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: const Text('Learn how scrap grading and deductions work', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                _showFaqModal(context);
              },
            ),

            const SizedBox(height: 20),

            // Reset Demo / Logout Button
            OutlinedButton.icon(
              onPressed: () {
                state.logout();
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.red),
              label: const Text('Log Out & Reset Demo (Back to Splash)', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFaqModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scrap Quality & Deductions Policy',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                '1. Moisture deduction: Wet cardboard or newspaper will have up to 5% tare adjustment.\n'
                '2. Electronic scales: Certified digital weighing machines calibrated under Weights & Measures Act.\n'
                '3. Bulk vendor payments: Direct RTGS/NEFT settlement within 2 hours of hub receipt.\n'
                '4. Free doorstep pickup: Applicable on orders with scrap weight ≥ 15 kg or value ≥ ₹200.',
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
