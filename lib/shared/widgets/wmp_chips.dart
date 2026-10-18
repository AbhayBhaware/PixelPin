import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';

/// Pill-shaped filter chip for wallpaper categories
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999), // Pill
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact keyword tag chip
class TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;

  const TagChip({
    super.key,
    required this.tag,
    this.onTap,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#$tag',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Status badge for uploads and applications (Pending / Approved / Rejected / Draft)
class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final cleanStatus = status.toLowerCase().trim();

    Color color;
    IconData icon;
    String displayText;

    switch (cleanStatus) {
      case 'approved':
      case 'active':
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        displayText = 'Approved';
        break;
      case 'rejected':
      case 'declined':
        color = AppColors.danger;
        icon = Icons.cancel_rounded;
        displayText = 'Rejected';
        break;
      case 'pending':
      case 'under_review':
        color = AppColors.warning;
        icon = Icons.access_time_filled_rounded;
        displayText = 'Pending Review';
        break;
      case 'draft':
      default:
        color = AppColors.textMutedDark;
        icon = Icons.edit_note_rounded;
        displayText = 'Draft';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            displayText,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
