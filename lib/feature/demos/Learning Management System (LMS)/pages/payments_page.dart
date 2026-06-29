import 'package:flutter/material.dart';

import '../theme.dart';

/// Payments — outstanding dues and transaction history.
class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = <_Txn>[
      _Txn('UPSC Foundation 2026', 'May 2, 2026', '₹4,999', true),
      _Txn('English for Competitive Exams', 'Apr 18, 2026', '₹1,499', true),
      _Txn('Test Series — Prelims', 'Mar 30, 2026', '₹799', true),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [LmsColors.primary, LmsColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Outstanding due',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                const Text('₹2,000',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                const Text('Installment 2 of 3 • due Jul 5',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: LmsColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening payment gateway…')),
                    ),
                    child: const Text('Pay ₹2,000',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const LmsSectionHeader('Transaction History'),
          for (final t in history)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: LmsColors.success.withValues(alpha: 0.12),
                child: const Icon(Icons.check, color: LmsColors.success),
              ),
              title: Text(t.title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(t.date),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(t.amount,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Text('Paid',
                      style: TextStyle(
                          color: LmsColors.success, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Txn {
  final String title;
  final String date;
  final String amount;
  final bool paid;
  _Txn(this.title, this.date, this.amount, this.paid);
}
