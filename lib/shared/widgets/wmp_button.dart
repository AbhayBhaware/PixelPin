import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelpin/core/theme/app_colors.dart';

enum WMPButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
}

enum WMPButtonSize {
  small,
  medium,
  large,
}

class WMPButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final WMPButtonVariant variant;
  final WMPButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const WMPButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = WMPButtonVariant.primary,
    this.size = WMPButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double height = switch (size) {
      WMPButtonSize.small => 38,
      WMPButtonSize.medium => 48,
      WMPButtonSize.large => 54,
    };

    final double fontSize = switch (size) {
      WMPButtonSize.small => 13,
      WMPButtonSize.medium => 15,
      WMPButtonSize.large => 16,
    };

    final double iconSize = switch (size) {
      WMPButtonSize.small => 16,
      WMPButtonSize.medium => 18,
      WMPButtonSize.large => 20,
    };

    final EdgeInsets padding = switch (size) {
      WMPButtonSize.small => const EdgeInsets.symmetric(horizontal: 14),
      WMPButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20),
      WMPButtonSize.large => const EdgeInsets.symmetric(horizontal: 26),
    };

    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == WMPButtonVariant.primary || variant == WMPButtonVariant.danger
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize, color: _getTextColor(isDark)),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: GoogleFonts.sora(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: _getTextColor(isDark),
          ),
        ),
      ],
    );

    if (variant == WMPButtonVariant.primary) {
      return Container(
        height: height,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? null
              : const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: onPressed == null ? (isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight) : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: padding,
              child: Center(child: buttonContent),
            ),
          ),
        ),
      );
    }

    // Secondary, Ghost, Danger
    Color bgColor;
    Color? borderColor;

    switch (variant) {
      case WMPButtonVariant.secondary:
        bgColor = isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;
        borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
        break;
      case WMPButtonVariant.ghost:
        bgColor = Colors.transparent;
        borderColor = null;
        break;
      case WMPButtonVariant.danger:
        bgColor = AppColors.danger;
        borderColor = null;
        break;
      case WMPButtonVariant.primary:
        bgColor = AppColors.primary;
        break;
    }

    return Container(
      height: height,
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: onPressed == null ? bgColor.withValues(alpha: 0.4) : bgColor,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: padding,
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(bool isDark) {
    if (onPressed == null) {
      return isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    }
    switch (variant) {
      case WMPButtonVariant.primary:
      case WMPButtonVariant.danger:
        return Colors.white;
      case WMPButtonVariant.secondary:
      case WMPButtonVariant.ghost:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    }
  }
}
