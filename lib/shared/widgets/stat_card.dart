import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final String? trend;
  final bool isPositiveTrend;
  final Color? accentColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trend,
    this.isPositiveTrend = true,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = accentColor ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 15,
                    color: primaryAccent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.sora(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  isPositiveTrend ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 14,
                  color: isPositiveTrend ? AppColors.success : AppColors.danger,
                ),
                const SizedBox(width: 4),
                Text(
                  trend!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPositiveTrend ? AppColors.success : AppColors.danger,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
