import 'package:flutter/material.dart';

/// App-wide color palette — glassmorphism + vibrant gradients.
class AppColors {
  AppColors._();

  // ── Primary palette ──────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42D4);
  static const Color accent = Color(0xFFFF6584);
  static const Color accentLight = Color(0xFFFF8FA3);

  // ── Background gradients ─────────────────────────────
  static const Color bgTop = Color(0xFF1A1A2E);
  static const Color bgMiddle = Color(0xFF16213E);
  static const Color bgBottom = Color(0xFF0F3460);

  // ── Day / Night sky colours ──────────────────────────
  static const Color sunriseTop = Color(0xFFFFA751);
  static const Color sunriseBottom = Color(0xFFFFE259);
  static const Color dayTop = Color(0xFF56CCF2);
  static const Color dayBottom = Color(0xFF2F80ED);
  static const Color sunsetTop = Color(0xFFEB5757);
  static const Color sunsetBottom = Color(0xFFF2994A);
  static const Color nightTop = Color(0xFF0D0D2B);
  static const Color nightBottom = Color(0xFF1A1A40);

  // ── Glass / card styling ─────────────────────────────
  static const Color glassWhite = Color(0x30FFFFFF);
  static const Color glassBorder = Color(0x50FFFFFF);
  static const Color cardBg = Color(0xFF1E1E3F);
  static const Color cardBgLight = Color(0xFF2A2A5A);

  // ── Stat bar colours ─────────────────────────────────
  static const Color hungerBar = Color(0xFFFF6B6B);
  static const Color happinessBar = Color(0xFFFFD93D);
  static const Color energyBar = Color(0xFF6BCB77);
  static const Color healthBar = Color(0xFF4D96FF);

  // ── Text ─────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xAAFFFFFF);
  static const Color textMuted = Color(0x66FFFFFF);

  // ── Misc ─────────────────────────────────────────────
  static const Color success = Color(0xFF00C9A7);
  static const Color warning = Color(0xFFFFB800);
  static const Color danger = Color(0xFFFF4757);
  static const Color coin = Color(0xFFFFD700);
  static const Color shadow = Color(0x40000000);

  // ── Gradients ────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardBg, cardBgLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
