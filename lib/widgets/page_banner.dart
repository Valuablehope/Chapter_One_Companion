import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_scope.dart';

/// Gradient hero banner used atop every main screen, mirroring
/// Chapter One's `PageBanner` component (icon pill + title + subtitle).
class PageBanner extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const PageBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: colors.brandGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: AppShadows.medium,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: _blob(90, colors.onBrandOverlay),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: _blob(60, colors.onBrandOverlay),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.onBrandOverlay,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: HeroIcon(icon, color: colors.onBrandFg, size: 26),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTextStyles.h1.copyWith(color: colors.onBrandFg)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(color: colors.onBrandFgMuted),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: AppSpacing.md), trailing!],
            ],
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
