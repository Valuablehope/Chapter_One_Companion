import 'package:flutter/material.dart';

/// Tokens that are identical across every Chapter One theme (mirrors the
/// `:root` defaults in `frontend/src/index.css` that no entry in
/// `themes.ts` overrides). Tokens that DO vary by theme — the brand ramp,
/// nav/sidebar chrome, and gradients — live in [AppColorScheme] instead and
/// are read reactively via `context.colors` (see `theme_scope.dart`).
class AppColors {
  AppColors._();

  static const Color surface = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF06B6D4);
  static const Color infoBg = Color(0xFFECFEFF);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFFB0B8C8);
  static const Color border = Color(0xFFE2E8F0);

  static const Color gold = Color(0xFFC49A3C);

  static const Color inputFill = Color(0xFFF0F5FF);
}
