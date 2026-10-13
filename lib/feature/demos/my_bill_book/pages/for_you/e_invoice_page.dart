import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class EInvoicePage extends StatelessWidget {
  const EInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('e-Invoice'),
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
              ],
            ),
            const SizedBox(height: 24),

            // Illustration container (screenshot 1000046157)
            Container(
              height: 240,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEFCE8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('e-Invoice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                            Icon(Icons.qr_code, size: 22, color: AppColors.textPrimary),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(height: 4),
                        SizedBox(height: 8),
                        Text('IRN: 89ab31...', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        Text('Ack No: 12348920', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            const Text(
              'Easy e-Invoice Generation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            const Text(
              'Generate complete and ready-to-use e-Invoices on your mobile with ease',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
            ),

            const SizedBox(height: 36),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Govt NIC e-Invoice Portal connection verified!')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start Generating e-Invoices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('eInvoicing via mobile (tutorial)', style: TextStyle(fontSize: 15, color: AppColors.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
