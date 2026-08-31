import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

/// Mirrors `frontend/src/styles/themes.ts` — one entry per runtime theme
/// the mother app (Chapter One POS) ships. Ids match `themes.ts`'s `id`
/// field so a persisted choice round-trips identically.
enum AppThemeId { classic, obsidian, emerald, graphite, pink }

class AppThemeDef {
  final AppThemeId id;
  final String name;
  final String description;
  final Color swatchDark;
  final Color swatchMid;
  final Color swatchLight;
  final AppColorScheme scheme;

  const AppThemeDef({
    required this.id,
    required this.name,
    required this.description,
    required this.swatchDark,
    required this.swatchMid,
    required this.swatchLight,
    required this.scheme,
  });
}

const _onBrandFgMutedDark = Color(0x9EFFFFFF); // rgba(255,255,255,0.62)
const _onBrandOverlayDark = Color(0x1FFFFFFF); // rgba(255,255,255,0.12)

const _classicScheme = AppColorScheme(
  pageBackground: Color(0xFFF0F4FA),
  brand50: Color(0xFFE8F1FC),
  brand100: Color(0xFFD1E3F9),
  brand200: Color(0xFFA3C7F3),
  brand300: Color(0xFF75ABED),
  brand400: Color(0xFF4790E7),
  brand500: Color(0xFF3582E2),
  brand600: Color(0xFF2A68B5),
  brand700: Color(0xFF1F4E88),
  brand800: Color(0xFF15345B),
  brand900: Color(0xFF0A1A2E),
  navBg: Color(0xFF0F1C2E),
  navHover: Color(0xFF162438),
  navActive: Color(0xFF1A2F4A),
  navBorder: Color(0xFF1C2D42),
  navText: Color(0xFFA8BBD4),
  navMuted: Color(0xFF5D7898),
  brandGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1A2E), Color(0xFF1F4E88), Color(0xFF3582E2)],
    stops: [0.0, 0.6, 1.0],
  ),
  brandGradientSimple: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3582E2), Color(0xFF1F4E88)],
  ),
  onBrandFg: Colors.white,
  onBrandFgMuted: _onBrandFgMutedDark,
  onBrandOverlay: _onBrandOverlayDark,
);

const _obsidianScheme = AppColorScheme(
  pageBackground: Color(0xFFF7F7F7),
  brand50: Color(0xFFF5F5F5),
  brand100: Color(0xFFEBEBEB),
  brand200: Color(0xFFD6D6D6),
  brand300: Color(0xFFB8B8B8),
  brand400: Color(0xFF8A8A8A),
  brand500: Color(0xFF1A1A1A),
  brand600: Color(0xFF111111),
  brand700: Color(0xFF0A0A0A),
  brand800: Color(0xFF050505),
  brand900: Color(0xFF000000),
  navBg: Color(0xFF111111),
  navHover: Color(0xFF222222),
  navActive: Color(0xFF333333),
  navBorder: Color(0xFF2A2A2A),
  navText: Color(0xFFC0C0C0),
  navMuted: Color(0xFF6B6B6B),
  // gradient-brand is a flat hex in themes.ts (no gradient stops) — represented
  // as a degenerate two-stop gradient of the same color.
  brandGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF111111), Color(0xFF111111)],
  ),
  brandGradientSimple: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A1A), Color(0xFF1A1A1A)],
  ),
  onBrandFg: Colors.white,
  onBrandFgMuted: _onBrandFgMutedDark,
  onBrandOverlay: _onBrandOverlayDark,
);

const _emeraldScheme = AppColorScheme(
  pageBackground: Color(0xFFF0FAF5),
  brand50: Color(0xFFECFDF5),
  brand100: Color(0xFFD1FAE5),
  brand200: Color(0xFFA7F3D0),
  brand300: Color(0xFF6EE7B7),
  brand400: Color(0xFF34D399),
  brand500: Color(0xFF059669),
  brand600: Color(0xFF047857),
  brand700: Color(0xFF065F46),
  brand800: Color(0xFF064E3B),
  brand900: Color(0xFF022C22),
  navBg: Color(0xFF022C22),
  navHover: Color(0xFF064E3B),
  navActive: Color(0xFF065F46),
  navBorder: Color(0xFF0A5040),
  navText: Color(0xFFA7D9C8),
  navMuted: Color(0xFF4D9E87),
  brandGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF022C22), Color(0xFF065F46), Color(0xFF059669)],
    stops: [0.0, 0.6, 1.0],
  ),
  brandGradientSimple: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF065F46)],
  ),
  onBrandFg: Colors.white,
  onBrandFgMuted: _onBrandFgMutedDark,
  onBrandOverlay: _onBrandOverlayDark,
);

const _graphiteScheme = AppColorScheme(
  pageBackground: Color(0xFFF1F3F9),
  brand50: Color(0xFFEEF2FF),
  brand100: Color(0xFFE0E7FF),
  brand200: Color(0xFFC7D2FE),
  brand300: Color(0xFFA5B4FC),
  brand400: Color(0xFF818CF8),
  brand500: Color(0xFF6366F1),
  brand600: Color(0xFF4F46E5),
  brand700: Color(0xFF4338CA),
  brand800: Color(0xFF3730A3),
  brand900: Color(0xFF312E81),
  navBg: Color(0xFF0F172A),
  navHover: Color(0xFF1E293B),
  navActive: Color(0xFF293548),
  navBorder: Color(0xFF1E2D40),
  navText: Color(0xFF94A3B8),
  navMuted: Color(0xFF4B6180),
  brandGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF6366F1)],
    stops: [0.0, 0.6, 1.0],
  ),
  brandGradientSimple: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
  ),
  onBrandFg: Colors.white,
  onBrandFgMuted: _onBrandFgMutedDark,
  onBrandOverlay: _onBrandOverlayDark,
);

const _pinkScheme = AppColorScheme(
  pageBackground: Color(0xFFF6F7F9),
  brand50: Color(0xFFFEF5F5),
  brand100: Color(0xFFFCE8E9),
  brand200: Color(0xFFF9D2D3),
  brand300: Color(0xFFF8B2B2),
  brand400: Color(0xFFF09098),
  brand500: Color(0xFFE8717A),
  brand600: Color(0xFFD45A63),
  brand700: Color(0xFFC24A53),
  brand800: Color(0xFFA93E48),
  brand900: Color(0xFF8A3139),
  // The only light-chrome theme: blush paints the sidebar/bottom-nav itself.
  navBg: Color(0xFFF8B2B2),
  navHover: Color(0xFFFDE8E8),
  navActive: Color(0xFFC24A53),
  navBorder: Color(0xFFF0A0A0),
  navText: Color(0xFFA93E48),
  navMuted: Color(0xFFC24A53),
  brandGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF6A8A8), Color(0xFFF8B2B2), Color(0xFFFBC2C2)],
    stops: [0.0, 0.55, 1.0],
  ),
  brandGradientSimple: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8B2B2), Color(0xFFF4A0A0)],
  ),
  // #F8B2B2 is too light for white text (contrast ~1.75:1) — deep rose instead.
  onBrandFg: Color(0xFF6B262D),
  onBrandFgMuted: Color(0xFFA93E48),
  onBrandOverlay: Color(0x1FC24A53), // rgba(194,74,83,0.12)
);

const kAppThemes = <AppThemeDef>[
  AppThemeDef(
    id: AppThemeId.classic,
    name: 'Classic',
    description: 'The original blue brand palette',
    swatchDark: Color(0xFF0F1C2E),
    swatchMid: Color(0xFF3582E2),
    swatchLight: Color(0xFFE8F1FC),
    scheme: _classicScheme,
  ),
  AppThemeDef(
    id: AppThemeId.obsidian,
    name: 'Obsidian',
    description: 'Pure black & white — no gradients',
    swatchDark: Color(0xFF111111),
    swatchMid: Color(0xFF333333),
    swatchLight: Color(0xFFF5F5F5),
    scheme: _obsidianScheme,
  ),
  AppThemeDef(
    id: AppThemeId.emerald,
    name: 'Emerald',
    description: 'Fresh green tones for a vibrant feel',
    swatchDark: Color(0xFF064E3B),
    swatchMid: Color(0xFF059669),
    swatchLight: Color(0xFFD1FAE5),
    scheme: _emeraldScheme,
  ),
  AppThemeDef(
    id: AppThemeId.graphite,
    name: 'Graphite',
    description: 'Cool slate grey with indigo highlights',
    swatchDark: Color(0xFF1E293B),
    swatchMid: Color(0xFF6366F1),
    swatchLight: Color(0xFFE0E7FF),
    scheme: _graphiteScheme,
  ),
  AppThemeDef(
    id: AppThemeId.pink,
    name: 'Blossom',
    description: 'Blush navigation on a neutral canvas',
    swatchDark: Color(0xFF4A1A20),
    swatchMid: Color(0xFFC24A53),
    swatchLight: Color(0xFFF8B2B2),
    scheme: _pinkScheme,
  ),
];

AppThemeDef themeDefFor(AppThemeId id) =>
    kAppThemes.firstWhere((t) => t.id == id, orElse: () => kAppThemes.first);
