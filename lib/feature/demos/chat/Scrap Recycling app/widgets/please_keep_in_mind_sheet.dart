import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PleaseKeepInMindSheet extends StatelessWidget {
  final VoidCallback onProceed;

  const PleaseKeepInMindSheet({
    super.key,
    required this.onProceed,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onProceed}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PleaseKeepInMindSheet(
        onProceed: () {
          Navigator.pop(ctx);
          onProceed();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle / close button
          const SizedBox(height: 12),
          Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Please keep in mind',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildRuleCard(
                  imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&auto=format&fit=crop&q=80',
                  icon: Icons.chair_rounded,
                  title: 'We buy only in scrap rates',
                ),
                const SizedBox(height: 12),
                _buildRuleCard(
                  imageUrl: 'https://images.unsplash.com/photo-1546484396-fb3fc6f95f98?w=300&auto=format&fit=crop&q=80',
                  icon: Icons.forest_rounded,
                  title: 'We do not buy Wood',
                ),
                const SizedBox(height: 12),
                _buildRuleCard(
                  imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=300&auto=format&fit=crop&q=80',
                  icon: Icons.wine_bar_rounded,
                  title: 'We do not buy Glass',
                ),
                const SizedBox(height: 12),
                _buildRuleCard(
                  imageUrl: 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=300&auto=format&fit=crop&q=80',
                  icon: Icons.checkroom_rounded,
                  title: 'We do not buy Clothes/\nTextile Material',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: ElevatedButton(
              onPressed: onProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E7E34),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Okay, I understand',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required String imageUrl,
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFEF3C7),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Image / icon cutout with Red X badge
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFFFDE68A),
                      child: Icon(icon, color: const Color(0xFFB45309), size: 28),
                    ),
                  ),
                ),
              ),
              // Frosted circle with Red X
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade400, width: 1.5),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFDC2626),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
