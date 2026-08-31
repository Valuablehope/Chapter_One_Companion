import 'package:flutter/material.dart';

/// The subset of Chapter One's design tokens that actually differ between
/// themes (mirrors the CSS custom properties each entry in
/// `frontend/src/styles/themes.ts` overrides). Tokens that are identical
/// across every theme (status colors, text colors, card/border/input colors)
/// stay as plain constants in [AppColors] and are not part of this class.
class AppColorScheme {
  final Color pageBackground;

  final Color brand50;
  final Color brand100;
  final Color brand200;
  final Color brand300;
  final Color brand400;
  final Color brand500;
  final Color brand600;
  final Color brand700;
  final Color brand800;
  final Color brand900;

  final Color navBg;
  final Color navHover;
  final Color navActive;
  final Color navBorder;
  final Color navText;
  final Color navMuted;

  final Gradient brandGradient;
  final Gradient brandGradientSimple;

  /// Text/overlay colors for content painted on top of [brandGradient]
  /// (PageBanner, splash, login mark) — white on every dark-chrome theme,
  /// deep rose on Blossom's light blush chrome.
  final Color onBrandFg;
  final Color onBrandFgMuted;
  final Color onBrandOverlay;

  const AppColorScheme({
    required this.pageBackground,
    required this.brand50,
    required this.brand100,
    required this.brand200,
    required this.brand300,
    required this.brand400,
    required this.brand500,
    required this.brand600,
    required this.brand700,
    required this.brand800,
    required this.brand900,
    required this.navBg,
    required this.navHover,
    required this.navActive,
    required this.navBorder,
    required this.navText,
    required this.navMuted,
    required this.brandGradient,
    required this.brandGradientSimple,
    required this.onBrandFg,
    required this.onBrandFgMuted,
    required this.onBrandOverlay,
  });
}
