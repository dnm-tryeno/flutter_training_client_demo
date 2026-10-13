import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AutomatedBillsPage extends StatelessWidget {
  const AutomatedBillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Automated Bills'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Dot indicators
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
                SizedBox(width: 6),
                CircleAvatar(radius: 4, backgroundColor: Color(0xFFE2E8F0)),
                SizedBox(width: 6),
                CircleAvatar(radius: 4, backgroundColor: Color(0xFFE2E8F0)),
              ],
            ),
            const SizedBox(height: 24),

            // Illustration container (screenshot 1000046152)
            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Tired of creating\nrepeated bills !!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('📑 🔁 ⏰', style: TextStyle(fontSize: 42)),
                ],
              ),
            ),

            const SizedBox(height: 36),

            const Text(
              'Creating repeated bills?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            const Text(
              'We\'ve got you covered! Now repeat invoices can be created automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
            ),

            const SizedBox(height: 36),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recurring billing template creator opened')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('New Automated Bill', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Learn More', style: TextStyle(fontSize: 15, color: AppColors.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
