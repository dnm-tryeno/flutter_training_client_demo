import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import 'health_card.dart';

class DoctorGuidanceCard extends StatefulWidget {
  final String specialist;
  final String advice;
  final String reportedProblem;
  final String duration;
  final bool isEmergency;
  final String phoneNumber;
  final VoidCallback onCallHelpline;
  final bool initialExpanded;

  const DoctorGuidanceCard({
    super.key,
    required this.specialist,
    required this.advice,
    required this.reportedProblem,
    required this.duration,
    required this.isEmergency,
    this.phoneNumber = '7380492118',
    required this.onCallHelpline,
    this.initialExpanded = false,
  });

  @override
  State<DoctorGuidanceCard> createState() => _DoctorGuidanceCardState();
}

class _DoctorGuidanceCardState extends State<DoctorGuidanceCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  Widget _consultBullet(String text, double fontScale, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 15,
            color: isDark ? Colors.teal[300] : AppColors.healthGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5 * fontScale,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF334155),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return HealthCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Tappable to toggle)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.tr('recommended_specialist'),
                        style: TextStyle(
                          fontSize: 11 * state.fontScale,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.specialist,
                        style: TextStyle(
                          fontSize: 14.5 * state.fontScale,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.secondary,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
          ),

          // Collapsed brief 1-line hint
          if (!_isExpanded) ...[
            const SizedBox(height: 8),
            Text(
              widget.advice.isNotEmpty
                  ? widget.advice
                  : 'Consult ${widget.specialist} for complete clinical diagnosis.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5 * state.fontScale,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.35,
              ),
            ),
          ],

          // Expanded Full Details
          if (_isExpanded) ...[
            if (widget.advice.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                widget.advice,
                style: TextStyle(
                  fontSize: 13 * state.fontScale,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text(
              state.tr('doctor_share_info'),
              style: TextStyle(
                fontSize: 12.5 * state.fontScale,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            _consultBullet('${state.tr('reported_health_concern')}: ${widget.reportedProblem}', state.fontScale, isDark),
            if (widget.duration.isNotEmpty)
              _consultBullet('${state.tr('symptom_duration')}: ${widget.duration}', state.fontScale, isDark),
            _consultBullet(state.tr('bring_medicines_note'), state.fontScale, isDark),
            const SizedBox(height: 10),

            // Tele-Health Helpline Sub-Card
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.healthGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.healthGreen.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.healthGreen, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.tr('doctor_helpline_title'),
                          style: TextStyle(
                            fontSize: 12 * state.fontScale,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          widget.phoneNumber,
                          style: TextStyle(
                            fontSize: 12 * state.fontScale,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.teal[200] : const Color(0xFF0F766E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: widget.onCallHelpline,
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 13),
                    label: Text(state.tr('call_btn'), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.healthGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // See More / See Less Toggle Button
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? state.tr('see_less_btn') : state.tr('see_more_helpline'),
                      style: TextStyle(
                        fontSize: 12 * state.fontScale,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
