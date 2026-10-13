import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ConnectDesktopPage extends StatelessWidget {
  const ConnectDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connect to Computer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Laptop & Phone Syncing Mockup (screenshot 1000046156)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.laptop_chromebook, size: 64, color: Colors.white),
                        SizedBox(width: 14),
                        Icon(Icons.sync_alt, size: 32, color: Color(0xFF60A5FA)),
                        SizedBox(width: 14),
                        Icon(Icons.phone_android, size: 48, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Crown Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👑', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    children: [
                      TextSpan(text: 'Available on '),
                      TextSpan(text: 'Plus, Pro & Pro Max', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEA580C))),
                      TextSpan(text: ' plan'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Use myBillBook on Computer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your data gets synced automatically',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Visit : https://mybillbook.in/',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 24),

            // Feature Checklist (screenshot 1000046156)
            _buildFeatureRow(Icons.bolt, 'Create Bills Faster on your Computer'),
            _buildFeatureRow(Icons.grid_view_rounded, 'Bulk Upload and Bulk Edit Items'),
            _buildFeatureRow(Icons.print_outlined, 'Print Invoices using any USB printer'),
            _buildFeatureRow(Icons.palette_outlined, 'Design your own Invoice Format'),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('14-Day Free Desktop Sync Trial started!')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start 14 Day Free Trial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Learn how to connect to desktop',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
