import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7C5CFF);       // electric violet
  static const Color primaryDark = Color(0xFF6A47F5);    // light-mode primary
  static const Color primaryLight = Color(0xFFB39DDB);
  static const Color accent = Color(0xFFFF4D8D);         // hot pink (likes/CTA)
  static const Color accentGold = Color(0xFFFFB347);

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF0B0B0F);
  static const Color bgDarkSurface = Color(0xFF15151C);
  static const Color bgDarkCard = Color(0xFF1E1E28);     // surface-2
  static const Color bgDarkElevated = Color(0xFF2A2A36); // border

  // ── Light Theme ────────────────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFFAFAFB);
  static const Color bgLightSurface = Color(0xFFFFFFFF);
  static const Color bgLightCard = Color(0xFFF1F1F5);    // surface-2
  static const Color bgLightBorder = Color(0xFFE4E4EC);

  // ── Text — Dark ────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF9A9AAD);  // text-muted (dark)
  static const Color textMuted = Color(0xFF6B6B7D);      // even more muted

  // ── Text — Light ───────────────────────────────────────────────────────────
  static const Color textLightPrimary = Color(0xFF14141A);
  static const Color textLightMuted = Color(0xFF6B6B7D);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2DD4A0);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFFF5470);
  static const Color info = Color(0xFF448AFF);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const List<Color> heroGradient = [
    Color(0xFF7C5CFF),
    Color(0xFFFF4D8D),
  ];
  static const List<Color> cardOverlay = [
    Colors.transparent,
    Color(0xCC000000),
  ];
  static const List<Color> shimmerGradient = [
    Color(0xFF1E1E28),
    Color(0xFF2A2A36),
    Color(0xFF1E1E28),
  ];

  // ── Wallpaper Status Colors ────────────────────────────────────────────────
  static const Color statusApproved = Color(0xFF2DD4A0);
  static const Color statusPending = Color(0xFFFFB020);
  static const Color statusRejected = Color(0xFFFF5470);

  // ── Semantic Token Aliases ─────────────────────────────────────────────────
  static const Color danger = error;
  static const Color surfaceDark = bgDarkSurface;
  static const Color surfaceElevatedDark = bgDarkCard;
  static const Color borderDark = bgDarkElevated;
  static const Color textPrimaryDark = textPrimary;
  static const Color textSecondaryDark = textSecondary;
  static const Color textMutedDark = textMuted;

  static const Color surfaceLight = bgLightSurface;
  static const Color surfaceElevatedLight = bgLightCard;
  static const Color borderLight = bgLightBorder;
  static const Color textPrimaryLight = textLightPrimary;
  static const Color textSecondaryLight = textLightMuted;
  static const Color textMutedLight = textLightMuted;
}
