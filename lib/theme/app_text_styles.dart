import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'theme_scope.dart';

/// Typography mirrored from Chapter One POS: DM Sans for body/UI,
/// Playfair Display for headings and the brand wordmark.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _dmSans => GoogleFonts.dmSans(color: AppColors.textPrimary);
  static TextStyle get _playfair => GoogleFonts.playfairDisplay(color: AppColors.textPrimary);

  static TextStyle brandWordmark = _playfair.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: Colors.white,
  );

  static TextStyle splashTitle = _playfair.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle h1 = _dmSans.copyWith(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static TextStyle h2 = _dmSans.copyWith(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static TextStyle h3 = _dmSans.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle bodyLarge = _dmSans.copyWith(fontSize: 15, fontWeight: FontWeight.w400);
  static TextStyle body = _dmSans.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.55);
  static TextStyle bodyMedium = _dmSans.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  // navMuted varies by theme, so `small`/`statLabel` need a BuildContext to
  // pick up the live scheme — call as `AppTextStyles.small(context)`.
  static TextStyle small(BuildContext context) =>
      _dmSans.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: context.colors.navMuted);
  static TextStyle caption = _dmSans.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted);

  static TextStyle statValue = _dmSans.copyWith(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static TextStyle statLabel(BuildContext context) =>
      _dmSans.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: context.colors.navMuted);

  static TextStyle button = _dmSans.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle navLabel = _dmSans.copyWith(fontSize: 11, fontWeight: FontWeight.w500);
}
