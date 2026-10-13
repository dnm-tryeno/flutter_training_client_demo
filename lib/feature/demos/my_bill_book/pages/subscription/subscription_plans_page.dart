import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({super.key});

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  bool _isYearly = false;
  String _selectedPlan = 'Plus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('myBillBook Subscription Plan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1B4B), // Deep indigo
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top Gradient Hero Section (screenshot 1000046131)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CHOOSE YOUR PLAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Find the right plan for your business.',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),

                        // Monthly / Yearly toggle with badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildDurationToggle('Monthly', !_isYearly, () {
                                    setState(() => _isYearly = false);
                                  }),
                                  _buildDurationToggle('Yearly', _isYearly, () {
                                    setState(() => _isYearly = true);
                                  }),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -12,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Up to 20% Off',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Horizontal Plan Cards Carousel
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildPlanCard('Lite', '₹199', '₹2', 'for First 7 Days'),
                              const SizedBox(width: 12),
                              _buildPlanCard('Plus', '₹349', '₹2', 'for First 7 Days', isHighlighted: true),
                              const SizedBox(width: 12),
                              _buildPlanCard('Pro', '₹399', '₹2', 'for First 7 Days'),
                              const SizedBox(width: 12),
                              _buildPlanCard('Pro Max', '', '₹570', '/ month', isProMax: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plan Details Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Included Access of', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('1 Business', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('|', style: TextStyle(color: AppColors.cardBorder)),
                              Text('1 User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('|', style: TextStyle(color: AppColors.cardBorder)),
                              Text('1 CA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text('Available across', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(children: [Icon(Icons.android, size: 16, color: Color(0xFF10B981)), SizedBox(width: 6), Text('Android', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))]),
                              Text('|', style: TextStyle(color: AppColors.cardBorder)),
                              Row(children: [Icon(Icons.apple, size: 16), SizedBox(width: 6), Text('iOS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))]),
                              Text('|', style: TextStyle(color: AppColors.cardBorder)),
                              Row(children: [Icon(Icons.laptop, size: 16, color: AppColors.primary), SizedBox(width: 6), Text('Web', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))]),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Features Exclusive to Plus
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            children: [
                              TextSpan(text: 'Features Exclusive to '),
                              TextSpan(text: 'Plus', style: TextStyle(color: Color(0xFFEA580C))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('✨ INCLUDES :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                              const SizedBox(height: 12),
                              _buildFeatureLine(Icons.sync, 'Auto sync data across devices'),
                              _buildFeatureLine(Icons.receipt_long, 'Plus Reports such as GST Reports and Profit & Loss'),
                              _buildFeatureLine(Icons.storefront, 'Online Store creation & payments collection'),
                              _buildFeatureLine(Icons.security, 'Multi-staff role permissions & audit tracking'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar: Buy Plus Plan (screenshot 1000046131)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹2 for First 7 Days', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('then ₹349 every month', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Starting ₹2 for 7 Days Trial of Plus Plan!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA580C), // Orange CTA matching screenshot
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Buy Plus Plan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Renews automatically every month. Cancel anytime.',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationToggle(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.textPrimary : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    String name,
    String oldPrice,
    String price,
    String period, {
    bool isHighlighted = false,
    bool isProMax = false,
  }) {
    final isSelected = _selectedPlan == name;

    return InkWell(
      onTap: () => setState(() => _selectedPlan = name),
      child: Container(
        width: 105,
        height: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFFEA580C) // Orange card
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected && !isHighlighted ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            if (oldPrice.isNotEmpty)
              Text(
                oldPrice,
                style: TextStyle(
                  fontSize: 11,
                  decoration: TextDecoration.lineThrough,
                  color: isHighlighted ? Colors.white70 : AppColors.textMuted,
                ),
              )
            else if (isProMax)
              Text(
                'Starts at',
                style: TextStyle(fontSize: 10, color: isHighlighted ? Colors.white70 : AppColors.textMuted),
              ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isHighlighted ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
